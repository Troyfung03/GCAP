import SwiftUI
struct CalendarCell: View {
    @EnvironmentObject var dateHolder: DateHolder
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    @State private var isShowingNotes = false
    @State private var notes = ""

    var body: some View {
        ZStack {
            Button(action: {
                isShowingNotes.toggle()
            }) {
                VStack {
                    Text(monthStruct().day())
                        .foregroundColor(textColor(type: monthStruct().monthType))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                }
                .background(notes.isEmpty ? Color.clear : Color.yellow)
                .cornerRadius(8)
            }
        }                .
        sheet(isPresented: $isShowingNotes){
            AddExpenseView()
                .interactiveDismissDisabled()
        }
        
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

