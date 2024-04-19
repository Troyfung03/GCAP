import SwiftUI

struct TimesView: View
{
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View
    {
        VStack(spacing: 1)
        {
            DateScrollerView()
                .environmentObject(dateHolder)
                .padding()
            dayOfWeekStack
            calendarGrid
            
        }
    }
    
    var dayOfWeekStack: some View
    {
        HStack(spacing: 1)
        {
            Text("Sun").dayOfWeek()
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thu").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
        }
    }
    
    var calendarGrid: some View
    {
        VStack(spacing: 1)
        {
            let daysInMonth = CalendarHelper().daysInMonth(dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(dateHolder.date)
            let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
            let prevMonth = CalendarHelper().minusMonth(dateHolder.date)
            let daysInPrevMonth = CalendarHelper().daysInMonth(prevMonth)
            ForEach(0..<6)
            {
                row in
                HStack(spacing: 1)
                {
                    ForEach(1..<8)
                    {
                        column in
                        let count = column + (row * 7)
                        let cDate = CalendarHelper().cDate(count: count, startingSpaces: startingSpaces, firstDayOfMonth: firstDayOfMonth)
                            CalendarCell(count: count, startingSpaces: startingSpaces, cDate: cDate, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                                .environmentObject(dateHolder)
                           
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}
extension Text
{
    func dayOfWeek() -> some View
    {
        self.frame(maxWidth: .infinity)
            .padding(.top, 1)
            .lineLimit(1)
    }
}
