#!/bin/bash

shopt -s globstar

# Initialise variables
function showHelp() {
echo "----------------"
echo "Convert videos for Plex Media Server"
echo "----------------"
echo "Converts all videos in nested folders to h264 and audio to aac using HandBrake with the Normal preset."
echo "This saves Plex from having to transcode files which is CPU intensive."
echo
echo "Prerequisites"
echo
echo "Requires HandBrackCLI and media-info."
echo "    $ brew cask install handbrakecli"
echo "    $ brew install media-info"
echo "This script uses glob patterns, which requires Bash 4+ and globstar enabled"
echo "    $ bash --version"
echo "    Mac https://gist.github.com/reggi/475793ea1846affbcfe8"
echo
echo "----------------"
echo
echo "Command line options:"
echo "-c          Codec to modify. Default is MPEG-4"
echo "-d          Delete original."
echo "-f          Force overwriting of files if already exist in output destination."
echo "-o          Output folder directory path."
echo "            Default is the same directory as the input file."
echo "-p          The directory path of the movies to be tidied."
echo "            Default is '.', the location of this script."
echo "-q          Quality of HandBrake encoding preset. Default is 'Normal'."
echo "            - Normal"
echo "            - Universal"
echo "            - High Profile"
echo "            https://handbrake.fr/docs/en/latest/workflow/select-preset.html"
echo "-r          Run transcoding. Exclude for dry run."
echo "-s          Skip transcoding if there is already a matching file name in the output destination."
echo "            Force takes precedence over skipping files and will overwrite them if both flags present."
echo "-w          Workspace directory path for processing. Set a local directory for faster transcoding over network."
echo
echo "Examples:"
echo "    Dry run all movies in the Movies directory"
echo "        .convert-videos-for-plex.sh -p Movies"
echo
echo "    Transcode all movies in the current directory force overwriting matching .mp4 files."
echo "        .convert-videos-for-plex.sh -fr"
echo
echo "    Transcode all network movies using Desktop as temp directory and delete original files."
echo "        .convert-videos-for-plex.sh -rd -p /Volumes/Public/Movies -w ~/Desktop"
echo
}

codec="MPEG-4"
delete=false
path="./"
out=""
name=""
ext=".mp4"
force=false
skip=false
forceOverwrite=false
run=false
workspace=""
fileIn=""
fileOut=""
count=0
qualityPreset="Fast 1080p30"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

while getopts "h?dfsrp:o:c:w:q:" opt; do
    case "$opt" in
    h|\?)
        showHelp
        exit 0
        ;;
    d)  del=true
        ;;
    f)  force=true
        ;;
    s)  skip=true
        ;;
    r)  run=true
        ;;
    p)  path="$OPTARG"
        ;;
    o)  out="$OPTARG"
        ;;
    c)  codec="$OPTARG"
        ;;
    w)  workspace="$OPTARG"
        ;;
    q)  qualityPreset="$OPTARG"
        ;;
    esac
done

# Reset OPTIND
shift $((OPTIND-1))

echo
if [[ $run == true ]]; then
    echo -e "${BLUE}TRANSCODING${NC}"
else
    echo -e "${BLUE}DRY RUN${NC}"
fi
echo "----------------"

# Make sure all user inputted paths have trailing slashes
if [[ $path != */ ]]; then
    path=$path"/"
fi
if [[ $out != "" && $out != */ ]]; then
    out=$out"/"
fi
if [[ $workspace != "" && $workspace != */ ]]; then
    workspace=$workspace"/"
fi

for i in "${path}"**/*.*; do
    forceOverwrite=false

    # Prevent processing on non-files
    if [[ $i !=  *\*.* ]]; then
        # Loop over avi, mkv, iso, img, mp4 and m4v files only.
        if [[ $i == *.avi || $i == *.mkv || $i == *.iso || $i == *.img || $i == *.mp4 || $i == *.m4v ]]; then
            ((count++))
            echo
            echo "${count}) Checking: "$i

            if [[ $(mediainfo --Inform="Video;%Format%" "$i") == *$codec* 
                || $(mediainfo --Inform="Video;%Format%" "$i") == "HEVC" 
                || $(mediainfo --Inform="Video;%Format%" "$i") == "xvid" 
                || ($(mediainfo --Inform="Video;%Format%" "$i") == "AVC" 
                    && ($(mediainfo --Inform="Video;%Format_Profile%" "$i") == *"@L5"
                        || $(mediainfo --Inform="Video;%Format_Profile%" "$i") == "High@"*))
                ]]; then
                # Get file name minus extension
                name=${i%.*}

                # Set out directory if different from current
                if [[ $out != "" ]]; then
                    name=${name##*/}
                    name=$out$name
                fi

                # Check for existing .mp4; ask for overwrite or set force overwrite.
                if [[ -e $name$ext ]]; then
                    if [[ $force == false ]]; then
                        if [[ $skip == false ]]; then

                            read -p "'$name$ext' already exists. Do you wish to overwrite it?" -n 1 -r
                            echo
                            if [[ $REPLY =~ ^[Yy]$ ]]; then
                                forceOverwrite=true
                                echo -e "${BLUE}Overwriting:${NC} "$name$ext
                            else
                                echo -e "${RED}Skipping (already exists):${NC} "$name$ext
                                continue
                            fi
                        else
                            echo -e "${RED}Skipping (already exists):${NC} "$name$ext
                            continue
                        fi
                    else
                        forceOverwrite=true
                        echo -e "${BLUE}Overwriting:${NC} "$name$ext
                    fi
                fi

                echo "Transcoding: "${i} to $name$ext

                if [[ $run == true ]]; then
                    # Set file locations: in situ or separate workspace
                    if [[ $workspace == "" ]]; then
                        fileIn="${i}"
                        fileOut="${name}"
                    else
                        echo "Copying "$i" to "$workspace
                        cp "$i" "${workspace}"
                        fileIn=$workspace${i##*/}
                        fileOut=${fileIn%.*}
                    fi

                    # Modified from http://pastebin.com/9JnS23fK
                    HandBrakeCLI -i "${fileIn}" -o "${fileOut}""_processing""${ext}" --preset="${qualityPreset}" -O -s "scan" --audio-lang-list 'und' --all-audio
         
                    # if HandBrake did not exit gracefully, continue with next iteration
                    if [[ $? -ne 0 ]]; then
                        continue
                    else
                        # Delete original files
                        if [[ $del == true ]]; then
                            rm -f "${i}"
                        elif [[ $forceOverwrite == true ]]; then
                            rm -f "${name}""${ext}"
                        fi

                        mv "${fileOut}""_processing""${ext}" "${fileOut}""${ext}"
                        chmod 666 "${fileOut}""${ext}"

                        # Move files from workspace back to original locations
                        if [[ $workspace != "" ]]; then
                            echo "Copying from workspace ""${fileOut}${ext}"" to ""$(dirname "${name}${ext}")"
                            cp "${fileOut}${ext}" "$(dirname "${name}${ext}")"
                            rm -f "${fileIn}"
                            rm -f "${fileOut}""${ext}"
                        fi
                        echo -e "${GREEN}Transcoded:${NC} "$name$ext
                    fi

                else
                    echo -e "${GREEN}Transcoded (DRY RUN):${NC} "$name$ext
                fi
            else
                echo -e "${RED}Skipping (not ${codec}, will already play in Plex)${NC}"
            fi
        fi
    fi
done

exit 0
