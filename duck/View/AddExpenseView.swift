import SwiftUI
import SwiftData
struct AddExpenseView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @State private var subtitle: String = ""

    @State private var date: Date = .init()
        @State private var amount: CGFloat = 0 
    @State private var category: String = ""
    @Query(animation: .snappy) private var allCategories: [Category]
    var body: some View{
        NavigationStack{
            List{
Section("Title"){
    TextField("Magic Keyboard", text: $title)
}
Section("subtitle"){
TextField("Magic Keyboard", text: $subtitle)
}
Section("Amount"){
    Text("$").fontWeight(.semibold)
    TextField("0.0", value: $amount, format: .currency(code: "HKD"))
}
Section("Date"){
    DatePicker("", selection: $date, displayedComponents: [.date])
    .datePickerStyle(.graphical)
    .labelsHidden()
}
if !allCategories.isEmpty{
HStack{
    Text("Category")
    Spacer()
Picker("",selection: $category){
    ForEach(allCategories){

        Text($0.categoryName)
        .tag($0)
    }
}.pickerStyle(.menu)
.labelsHidden()
}}}
            .navigationTitle("Add Expense")
            .toolbar(
                ToolbarItem(placement: .topBarLeading){
                    Button ("Cancel"){
                        dismiss()
                    }
                    .tint( .red)
                },

                ToolbarItem(placement: .topBarTrailing){
                    Button("Add", action: addExpense){
                        saveExpense()
                    }
                }
            )
        }
    }
    func addExpense(){
        let newExpense = Expense(context: modelContext)
        newExpense.title = title
        newExpense.subtitle = subtitle
        newExpense.date = date
        newExpense.amount = amount
        newExpense.category = category
        modelContext.save()
        dismiss()
    }
}