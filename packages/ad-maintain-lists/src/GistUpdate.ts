import * as rest from 'typed-rest-client/RestClient'

const $package = require('../package.json')

export interface GistFileContent {
  content: string
}

export interface GistFile extends GistFileContent {
  size: number
  raw_url: string
  type: string
  language: string
  truncated: boolean
}

export interface GistFiles<T extends GistFile | GistFileContent> {
  [filename: string]: T
}

export interface GistCreate {
  description: string
  files: GistFiles<GistFileContent>
  public: boolean
}

export enum GitHubUserType {
  User = "User"
}

export interface GitHubUser {
  login: string
  id: number
  type: GitHubUserType
  site_admin: boolean
}

export interface GistFork {
  user: GitHubUser
  url: string
  id: string
  created_at: Date
  updated_at: Date
}

export interface GistHistory {
  url: string
  version: string
  user: GitHubUser
  change_status: {
    deletions: number
    additions: number
    total: number
  }
  committed_at: Date
}

export interface Gist {
  url: string
  forks_url: string
  commits_url: string
  id: string
  description: string
  public: boolean
  owner: GitHubUser
  user: any
  files: GistFiles<GistFile>
  truncated: boolean
  comments: number
  comments_url: string
  html_url: string
  git_pull_url: string
  git_push_url: string
  created_at: Date
  updated_at: Date
  forks: GistFork[]
  history: GistHistory[]
}

export class GistUpdate {
  private readonly gist = new rest.RestClient($package.name, 'https://gist.github.com')

  async create(create: GistCreate): Promise<Gist> {
    const response = await this.gist.create<Gist>('gists', create)
    return response.result
  }

  async update(gistId: string, content: string): Promise<void> {
    await this.gist.client.patch(`/gists/${gistId}`, content)
  }
}
