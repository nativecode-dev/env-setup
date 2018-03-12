#!env python
# -*- coding: utf-8 -*-
import base64

from dnsdumpster.DNSDumpsterAPI import DNSDumpsterAPI

domain = 'googlevideo.com'

print('Gethering domain information... : {}'.format(domain))
response = DNSDumpsterAPI(True).search(domain)

if response:
    print("\n\n####### Domain #######")
    print(response['domain'])

    print("\n\n####### DNS Servers #######")
    for entry in response['dns_records']['dns']:
        print(("{domain} ({ip}) {as} {provider} {country}".format(**entry)))

    print("\n\n####### MX Records #######")
    for entry in response['dns_records']['mx']:
        print(("{domain} ({ip}) {as} {provider} {country}".format(**entry)))

    print("\n\n####### Host Records (A) #######")
    for entry in response['dns_records']['host']:
        if entry['reverse_dns']:
            print(("{domain} ({reverse_dns}) ({ip}) {as} {provider} {country}".format(**entry)))
        else:
            print(("{domain} ({ip}) {as} {provider} {country}".format(**entry)))

    print("\n\n####### TXT Records #######")
    for entry in response['dns_records']['txt']:
        print(entry)
