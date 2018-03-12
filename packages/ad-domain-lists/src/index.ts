export * from './DomainService'

import { DomainService } from './DomainService'

const lookup = new DomainService()
lookup.addresses('googlevideo.com').then(addresses => console.log(addresses))
