import SwiftUI
import SwiftData

struct AddNotesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var date: Date = .init()
    var body: some View{
        NavigationStack{
            List{
                Section("Title"){
                    TextField("Type Something!", text: $title)
                }
                Section("Description"){
                    TextField("Type Something As Well!", text: $desc)
                }
                Section("Date"){
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
 
            }
            .navigationTitle("Drop Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button ("Cancel"){
                        dismiss()
                    }
                    .tint( .red)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add", action: addNote)
                        .disabled(isAddButtonDisabled)
                }
            }
        }
    }
    var isAddButtonDisabled: Bool{
        return title.isEmpty || desc.isEmpty}
    
func addNote() {
    let notes = Notes(title: title, desc: desc, date: date)
    context.insert(notes)
    try? context.save() // Save the context
    dismiss()
}
}

