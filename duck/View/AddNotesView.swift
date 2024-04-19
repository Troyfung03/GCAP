import SwiftUI
import SwiftData

struct AddNotesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var date: Date
    init(cDate: Date) {
        _date = State(initialValue: cDate)
    }
    var body: some View{
        NavigationStack{
            List{
                Section("Title"){
                    TextField("Type Something!", text: $title)
                }
                Section("Description"){
                    ZStack(alignment: .topLeading) {
                        if desc.isEmpty {
                            Text("Type Something!")
                                .foregroundColor(.gray)
                        }
                        TextEditor(text: $desc)
                    }
                    .frame(height: 100) // Set a fixed height for the TextEditor
                }
                Section("Date"){
                    DatePicker("", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                
            }
            .navigationTitle("Jot Notes")
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

