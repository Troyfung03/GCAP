import SwiftUI
import SwiftData

@Model
class Notes{
    
    var title: String
    var desc: String
    var date: Date
    
    
    init(title: String, desc: String,date: Date) {
        self.title = title
        self.desc = desc
        self.date = date
    }
}

