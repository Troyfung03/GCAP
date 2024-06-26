import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var date: Date = .init()
    @State private var amount: CGFloat = 0
    @State private var category: Category? = nil
    @Query (animation: .snappy) private var allCategories: [Category]
    
    var body: some View{
        NavigationStack{
            List{
                Section("Title"){
                    TextField("Type Something!", text: $title)
                }
                Section("subtitle"){
                    TextField("Type Something As Well!", text: $subtitle)
                }
                Section("Amount"){
                    HStack(spacing: 4){
                        Text("$").fontWeight(.semibold)
                        TextField("0.0", value: $amount, formatter: formatter)
                    }
                }
                if !allCategories.isEmpty
                {
                    HStack{
                        Text("Category")
                        Spacer()
                        Menu{
                            ForEach(allCategories){ category in Button(category.categoryName){
                                self.category = category
                            }}
                            
                        }label:{
                            if let categoryName = category?.categoryName{
                                Text(categoryName)
                            }else{
                                Text("None")                
                            }
                        }
                    }
                }
                Section("Date"){
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button ("Cancel"){
                        dismiss()
                    }
                    .tint( .red)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add", action: addExpense)
                        .disabled(isAddButtonDisabled)
                }
            }
        }
    }
    var isAddButtonDisabled: Bool{
        return title.isEmpty || subtitle.isEmpty || amount == .zero}
    
    func addExpense() {
        let expense = Expense(title: title, subt: subtitle, amount: amount, date: date, category: category)
        context.insert(expense)
        dismiss()
    }
    
    var formatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits=2
        return formatter
    }
    
}
