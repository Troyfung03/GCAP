import SwiftUI
import SwiftData

struct NotesView: View {
    @Query(sort:[ SortDescriptor(\Notes.date, order: .reverse)], animation: .snappy)
    private var notes: [Notes]
    @State private var addNotes: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notes) { note in
                        Text(note.title)
                    }
                }
                .overlay {
                    if notes.isEmpty {
                        Text("No Notes")
                    }
                }
                
                Button(action: {
                    addNotes.toggle()
                }) {
                    Image(systemName:"plus.circle.fill")
                        .font(.title3)
                        .padding()
                }
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
            }
            .sheet(isPresented: $addNotes){
                AddNotesView()
            }
        }
    }
}
