import HTTP
import Vapor
import Fluent

final class SocialHelper {

  static func storeSocialProfile(for user: User, socialUserId: String, social: String) throws {

    guard let userId = user.id else {
      throw Abort(.internalServerError, reason: "Can't get user.id")
    }

    guard let socialid = try Social.find(by: social)?.id else {
      throw Abort(.internalServerError, reason: "Can't get social.id")
    }

    let socialAccount = SocialAccount(
      userId: userId,
      socialId: socialid,
      socialUserId: socialUserId)

    try socialAccount.save()

  }

}
