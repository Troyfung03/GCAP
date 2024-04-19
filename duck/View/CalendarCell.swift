import SwiftUI
import SwiftData

struct CalendarCell: View {
    @Query(sort:[ SortDescriptor(\Notes.date, order: .reverse)], animation: .snappy)
    private var allNotes: [Notes]
    
    @EnvironmentObject var dateHolder: DateHolder
    let count: Int
    let startingSpaces: Int
    let cDate: Date
    let daysInMonth: Int
    let daysInPrevMonth: Int
    @State private var isShowingNotes = false
    @State private var notes = ""
    
    var hasNotesForCDate: Bool {
        allNotes.contains { Calendar.current.isDate($0.date, inSameDayAs: cDate) }
    }
    
    
    var body: some View {
        ZStack {
            Button(action: {
                isShowingNotes.toggle()
            }) {
                VStack {
                    Text(monthStruct().day())
                        .foregroundColor(textColor(type: monthStruct().monthType))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal) // Only apply horizontal padding
                    
                }
                .background(hasNotesForCDate ? Color.yellow.opacity(0.5) : Color.clear)
            }
            .disabled(monthStruct().monthType != .Current) // Disable the button if the month type is not Current
            
            NavigationLink(destination: NotesView(cDate:cDate), isActive: $isShowingNotes) {
                EmptyView()
            }
        }.cornerRadius(20)
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black : Color.gray
    }
    
    func monthStruct() -> MonthStruct
    {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        if(count <= start)
        {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        }
        else if (count - start > daysInMonth)
        {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
}

