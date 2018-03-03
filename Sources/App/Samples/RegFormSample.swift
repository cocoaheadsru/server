import Vapor
import Foundation
//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
final class RegFormSample {

  private let events: [Event]

  init() {
    self.events = try! Event
      .makeQuery()
      .filter(Event.Keys.endDate, .greaterThanOrEquals, Date())
      .all()
  }

  func createSample() throws {

    events.forEach { (event)  in

      let regForm = RegForm(
        eventId: event.id!,
        formName: String.randomValue,
        description: String.randomValue)

      try! regForm.save()

      for _ in 1...Int.random(min: 2, max: 5) {

        let type = ["checkbox", "radio", "string"].randomValue

        let regField = RegField(
          regFormId: regForm.id!,
          required: Bool.randomValue,
          name: String.randomValue,
          type: RegField.FieldType(type),
          placeholder: String.randomValue,
          defaultValue: String.randomValue)

        try! regField.save()

        for _ in 1...Int.random(min: 2, max: 5) {
          let regFiedlAnswers = RegFieldAnswer(
            value: String.randomValue,
            regFieldId: regField.id!)
          try! regFiedlAnswers.save()
        }

      }

    }

  }

}
