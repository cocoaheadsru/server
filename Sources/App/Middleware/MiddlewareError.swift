import Foundation

enum MiddlewareError: Error {
  case missingClientToken
  case missingDomain
}
