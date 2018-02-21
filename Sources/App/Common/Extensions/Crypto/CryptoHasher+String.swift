import Crypto

extension CryptoHasher {
  static func makeMD5(from string: String) throws -> String {
    let md5 = CryptoHasher(hash: .md5, encoding: .hex)
    return try md5.make(string.makeBytes()).makeString()
  }
}
