import SwiftUI
import SwiftData
import Swift
struct LineGraph: Shape {
    var data: [Double]
    
    init(data: [Double]) {
        self.data = data
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if data.count > 1 {
            let xInterval = rect.width / CGFloat(data.count - 1)
            let yInterval = (rect.height != 0 && data.max() ?? 1 != 0) ? (data.max() ?? 1) / Double(rect.height) : 1
            
            path.move(to: CGPoint(x: 0, y: rect.height - CGFloat(data[0] / yInterval)))
            
            for i in 1..<data.count {
                let x = CGFloat(i) * xInterval
                let y = rect.height - CGFloat(data[i] / yInterval)
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}


struct ExpenseGraphView: View {
    @Binding var groupedExpenses: [GroupedExpenses]
    var currentMonthAndYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }
    var body: some View {
        VStack {
            HStack {
                Text(currentMonthAndYear)
                    .font(.title2)
                    .bold()
                    .padding(.vertical)
                Spacer()
            }
            HStack {
                Text("Weeks")
                    .rotationEffect(.degrees(-90))
                    .frame(width: 0)
                    .offset(y: -30)
                
                VStack {
                    let data = prepareData()
                    let lineGraph = LineGraph(data: data.map { $0.expenses })
                    let maxValue = ceil((data.map { $0.expenses }.max() ?? 0) / 1000) * 1000
                    let steps = Int(maxValue / 1000)
                    ZStack {
                        BackgroundLines(maxValue: maxValue, steps: steps)
                        lineGraph
                            .stroke(Color.blue, lineWidth: 2)
                            .padding([.leading, .trailing])
                    }
                    HStack {
                        ForEach(data, id: \.weekNumber) { weekData in
                            Spacer()
                            Text("Week \(weekData.weekNumber)")
                                .font(.system(size: 14))
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    func prepareData() -> [(weekNumber: Int, expenses: Double)] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let rangeOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: Date())
        let numberOfWeeks = rangeOfWeeks?.count ?? 4
        
        var data = [(weekNumber: Int, expenses: Double)]()
        
        for week in 1...numberOfWeeks {
            let startOfWeek = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, weekOfMonth: week))
            
            var totalExpenseForWeek = 0.0
            for expenseGroup in groupedExpenses {
                let expenseDate = expenseGroup.date
                if calendar.component(.month, from: expenseDate) == currentMonth && calendar.component(.year, from: expenseDate) == currentYear && calendar.component(.weekOfMonth, from: expenseDate) == week {
                    totalExpenseForWeek += expenseGroup.expenses.reduce(0) { $0 + $1.amount }
                }
            }
            
            data.append((weekNumber: week, totalExpenseForWeek))
        }
        
        return data
    }
    
}

struct BackgroundLines: View {
    var maxValue: Double
    var steps: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let height = geometry.size.height
                    let width = geometry.size.width
                    let interval = steps != 0 ? height / CGFloat(steps) : height
                    
                    for index in stride(from: steps, through: 0, by: -1) {
                        let y = CGFloat(index) * interval
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: width, y: y))
                    }
                }
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                
                ForEach(Array(stride(from: 0, to: steps, by: 1)), id: \.self) { index in
                    let y = steps != 0 ? CGFloat(index) * (geometry.size.height / CGFloat(steps)) : 0
                    let labelValue = steps != 0 ? (steps - index) * (Int(maxValue) / steps) : 0
                    Text("\(labelValue)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .position(x: 0, y: y) // Use position instead of offset
                }
            }
        }
    }
}

struct ExpenseView: View {
    // Grouped Expenses Properties
    @Query(sort:[ SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy)
    private var allExpenses: [Expense]
    @State private var addExpense: Bool = false
    @State private var groupedExpenses: [GroupedExpenses] = []
    @State private var originalGroupedExpenses: [GroupedExpenses] = []
    @State private var showCategoryView = false
    @Environment(\.modelContext) private var context
    @State private var trendData: [Double] = []
    @State private var searchText: String = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack {
                        Text("Expenses")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            showCategoryView = true
                        }) {
                            Image(systemName: "folder") // replace "folder" with your desired SF Symbol name
                                .resizable()
                                .frame(width: 24, height: 24) // adjust the size as needed
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.trailing)
                        .background(
                            NavigationLink(
                                destination: CategoryView(),
                                isActive: $showCategoryView,
                                label: { EmptyView() }
                            ))
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: Text("Search"))
                    List {
                        if($searchText.wrappedValue.isEmpty){
                            ExpenseGraphView(groupedExpenses: $groupedExpenses)
                        }
                        ForEach($groupedExpenses) { $group in
                            Section(group.groupTitle) {
                                ForEach(group.expenses) { expense in
                                    ExpenseCardView(expense: expense)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button {
                                                context.delete(expense)
                                                withAnimation {
                                                    group.expenses.removeAll(where: { $0.id == expense.id })
                                                    if group.expenses.isEmpty {
                                                        groupedExpenses.removeAll(where: { $0.id == group.id })
                                                    }
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }    .tint(.red)
                                        }
                                }
                            }
                        }
                        .overlay{
                            if allExpenses.isEmpty || groupedExpenses.isEmpty{
                                ContentUnavailableView{
                                    Label("No Expenses", systemImage:"tray.fill")
                                }
                            }
                        }
                    }
                }
                .toolbar{
                    ToolbarItem(placement:.topBarTrailing){
                        Button{
                            addExpense.toggle()
                        } label:{
                            Image(systemName:"plus.circle.fill").font(.title3)
                        }
                    }
                }
                .onChange(of: searchText,initial:false){
                    oldValue,  newValue in
                    if !newValue.isEmpty{
                        filterExpenses(newValue)
                    }else{
                        groupedExpenses = originalGroupedExpenses
                    }
                    
                }
                .onChange(of: allExpenses,initial:true){
                    oldValue,  newValue in
                    if newValue.count > oldValue.count || groupedExpenses.isEmpty || showCategoryView {
                        createGroupedExpenses(newValue)
                    }
                }
                
                
                .sheet(isPresented: $addExpense){
                    AddExpenseView()
                        .interactiveDismissDisabled()
                }
                
                
            }       }}
    
    func filterExpenses(_ text: String) {
        Task.detached(priority: .high) {
            let query = text.lowercased()
            let filteredExpenses = originalGroupedExpenses.compactMap {group -> GroupedExpenses? in
                let expenses = group.expenses.filter{
                    $0.title.lowercased().contains(query) || $0.subt.lowercased().contains(query)}
                if expenses.isEmpty{
                    return nil
                }
                return .init(date: group.date, expenses: expenses)
            }
            
            await MainActor.run{
                groupedExpenses = filteredExpenses
            }
            
        }
    }
    
    
    func createGroupedExpenses(_ expenses: [Expense]) {
        Task.detached(priority: .high){
            let groupedDict = Dictionary(grouping: expenses){
                expense in
                let dateComponents = Calendar.current.dateComponents([.day,.month, .year], from: expense.date)
                return dateComponents
            }
            
            let sortedDict = groupedDict.sorted{
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            await MainActor.run {
                groupedExpenses = sortedDict.compactMap ({
                    dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return GroupedExpenses(date: date, expenses: dict.value)
                })
                originalGroupedExpenses = groupedExpenses
            }
        }
    }}

