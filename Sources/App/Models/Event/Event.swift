import Vapor
import FluentProvider

// sourcery: AutoModelGeneratable
// sourcery: toJSON, Preparation, Timestampable, ResponseRepresentable
final class Event: Model {
    
  let storage = Storage()
  
  // sourcery: relatedModel = Place, ignoreInJSON
  var placeId: Identifier
  var title: String
  var description: String
  var photoUrl: String
  var isRegistrationOpen: Bool = true
  var startDate: Int
  var endDate: Int
  var hide: Bool = false
  
  init(title: String,
       description: String,
       photoUrl: String,
       placeId: Identifier,
       isRegistrationOpen: Bool = true,
       startDate: Int, endDate: Int,
       hide: Bool = false) {
    self.title = title
    self.description = description
    self.photoUrl = photoUrl
    self.placeId = placeId
    self.isRegistrationOpen = isRegistrationOpen
    self.startDate = startDate
    self.endDate = endDate
    self.hide = hide
  }
  
  // sourcery:inline:auto:Event.AutoModelGeneratable
  init(row: Row) throws {
    placeId = try row.get(Keys.placeId)
    title = try row.get(Keys.title)
    description = try row.get(Keys.description)
    photoUrl = try row.get(Keys.photoUrl)
    isRegistrationOpen = try row.get(Keys.isRegistrationOpen)
    startDate = try row.get(Keys.startDate)
    endDate = try row.get(Keys.endDate)
    hide = try row.get(Keys.hide)
  }

  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.placeId, placeId)
    try row.set(Keys.title, title)
    try row.set(Keys.description, description)
    try row.set(Keys.photoUrl, photoUrl)
    try row.set(Keys.isRegistrationOpen, isRegistrationOpen)
    try row.set(Keys.startDate, startDate)
    try row.set(Keys.endDate, endDate)
    try row.set(Keys.hide, hide)
    return row
  }
  // sourcery:end
}

extension Event {
  
  // sourcery: nestedJSONRepresentableField
  func place() throws -> Place? {
    return try parent(id: placeId).get()
  }
  
  func speeches() throws -> [Speech] {
    return try Speech.makeQuery().filter(Speech.Keys.eventId, id).all()
  }
  
  // sourcery: nestedJSONField
  func status() -> String {
//    $session = Session::findOne(['token' => $token]);
//    $eventRegForm = EventRegForm::findOne(['event_id' => $this->id]);
//    $registraion = EventReg::find()->andWhere(['!=', 'status', 'canceled'])->andWhere(['user_id' => $session->user_id, 'event_form' => $eventRegForm->id])->one();
//
//    if (!empty($registraion->status)) {
//      return $registraion->status;
//    }
//    else if(!$this->is_registration_open) {
//      return "registrationClosed";
//    }
//    return "canRegister";
    return ""
  }
  
  // sourcery: nestedJSONField
  func speakersPhotos() throws -> [String] {
    let photoPaths = try speeches().flatMap { speech in
        return try speech.speakers().flatMap { speaker in
            return try speaker.user()?.photo
        }
    }
    let photoURLs = photoPaths.map { "http://upapi.ru/photos/" + $0 }
    return photoURLs
  }
  
  func registrationForm() throws -> RegForm? {
    return try children().first()
  }
}
