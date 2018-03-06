import Vapor

//swiftlint:disable superfluous_disable_command
//swiftlint:disable force_try
extension Samples {

  @discardableResult
  func createEventSample(pastCount: Int = 30, comingCount: Int = 1) throws -> [Event] {

    let photoController = PhotoController(drop: drop)
    let randomPhotoURL = "https://picsum.photos/200/300?image="

    func storePastEvent() throws -> Event {
      return try! storeEvent(date: Date.randomValueInPast, isRegistrationOpen: false)
    }

    func storeComingEvent() throws -> Event {
      return try! storeEvent(date: Date.randomValueInFuture, isRegistrationOpen: true)
    }

    func storeEvent(date: Date = Date.randomValue, isRegistrationOpen: Bool) throws -> Event {
      let city = City(cityName: String.randomValue)
      try! city.save()

      let place = Place(
        title: String.randomValue,
        address: String.randomValue,
        description: String.randomValue,
        latitude: Double.randomValue,
        longitude: Double.randomValue,
        cityId: city.id!
      )
      let photoURL = "\(randomPhotoURL)\(Int.random(min: 0, max: 200))"
      
      try! place.save()

      let event = Event(
        title: String.randomValue,
        description: String.randomValue,
        photo: String.randomValue,
        placeId: place.id!,
        isRegistrationOpen: isRegistrationOpen,
        startDate: date,
        endDate: date)

      try! event.save()
      event.photo = try! photoController.downloadAndSavePhoto(for: event, with: photoURL)
      try! event.save()
      return event
    }

    var events: [Event] = []
    for _ in 1...Int.random(min: 2, max: pastCount) {
      let event = try! storePastEvent()
      events.append(event)
    }

    for _ in 1...Int.random(min: 2, max: comingCount) {
      let event = try! storeComingEvent()
      events.append(event)
    }

    return events
  }

}
