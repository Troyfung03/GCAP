import SwiftUI
import ChatGPT  // Assuming ChatGPT is some sort of API connection library

struct ChatBotView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var newMessage = ""

    var body: some View {
        VStack {
            MessagesListView(messages: viewModel.messages)
            HStack {
                TextField("Enter your message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Send") {
                    Task {  // Use Task to handle asynchronous actions
                        await viewModel.sendUserMessage(newMessage)
                        newMessage = ""  // Clear the input field
                    }
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
    }
}

struct MessagesListView: View {
    var messages: [ChatMessage]
    
    var body: some View {
        ScrollView {
            ForEach(messages, id: \.content) { message in
                MessageRow(message: message)
            }
        }
    }
}

struct MessageRow: View {
    var message: ChatMessage

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                messageBubble(message.content, backgroundColor: .blue)
            } else {
                messageBubble(message.content, backgroundColor: .gray)
                Spacer()
            }
        }
    }

    /// Helper function to create a message bubble
    @ViewBuilder
    func messageBubble(_ text: String, backgroundColor: Color) -> some View {
        Text(text)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
