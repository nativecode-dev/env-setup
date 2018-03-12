import * as nslookup from 'nslookup'

export class DomainService {
  addresses(domain: string): Promise<any[]> {
    return new Promise((resolve, reject) => {
      nslookup('googlevideo.com')
        .type('mx')
        .end((error: any, addresses: any[]) => {
          if (error) {
            reject(error)
          }
          resolve(addresses)
        })
    })
  }
}
