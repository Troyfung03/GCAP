import SwiftUI

struct NotesCardView: View {
    @Bindable var note: Notes
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack {
                    Text(note.title)
                        .font(.title3)
                        .bold()
                }
                HStack {
                    Text(note.desc)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
