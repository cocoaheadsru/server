import Fluent
import Vapor

extension Droplet {

  func setupSocial() throws {
    let socials = [
      Social.Nets.fb,
      Social.Nets.vk,
      Social.Nets.github]

    try socials.forEach { socialName in
      if try Social.find(by: socialName) == nil {
        let social = Social(name: socialName)
        try social.save()
      }
    }

  }

}
