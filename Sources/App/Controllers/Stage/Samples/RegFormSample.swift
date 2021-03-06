import Vapor
import Foundation
//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
extension Samples {

  func createRegFormSample() throws {

    try! Event
      .makeQuery()
      .filter(Event.Keys.endDate, .greaterThanOrEquals, Date())
      .all()
      .forEach { (event)  in

      let regForm = RegForm(
        eventId: event.id!,
        formName: String.randomValue,
        description: String.randomValue)

      try! regForm.save()

      for _ in 1...Int.random(min: 2, max: 3) {

        let type = ["checkbox", "radio", "string"].randomValue

        let regField = RegField(
          regFormId: regForm.id!,
          required: Bool.randomValue,
          name: String.randomValue,
          type: RegField.FieldType(type),
          placeholder: String.randomValue,
          defaultValue: String.randomValue)

        try! regField.save()

        for _ in 1...Int.random(min: 2, max: 3) {
          let regFiedlAnswers = RegFieldAnswer(
            value: String.randomValue,
            regFieldId: regField.id!)
          try! regFiedlAnswers.save()
        }

      }

    }

  }

}
