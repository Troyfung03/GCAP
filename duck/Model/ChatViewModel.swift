import Foundation
import ChatGPT  // Import the ChatGPT library

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []

    private let chatGPT: ChatGPT

    init() {
        // Initialize the ChatGPT with your API key and default model
        self.chatGPT = ChatGPT(apiKey: "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", defaultModel: .gpt3)
    }

    func sendUserMessage(_ message: String) async {
        let userMessage = ChatMessage.user(message)
        DispatchQueue.main.async {
            self.messages.append(userMessage) // Append user message to chat history
        }

        do {
            let botResponse = try await chatGPT.ask(message)
            receiveBotMessage(botResponse)
        } catch {
            print("Failed to get response: \(error)")
            receiveBotMessage("Sorry, there was an error processing your request.")
        }
    }

    func streamUserMessage(_ message: String) async {
        let userMessage = ChatMessage.user(message)
        DispatchQueue.main.async {
            self.messages.append(userMessage) // Append user message to chat history
        }

        do {
            for try await nextWord in try await chatGPT.streamedAnswer.ask(message) {
                let currentText = nextWord.trimmingCharacters(in: .whitespacesAndNewlines)
                DispatchQueue.main.async {
                    if let lastMessage = self.messages.last, lastMessage.role == .assistant {
                        self.messages[self.messages.count - 1].content += currentText
                    } else {
                        self.receiveBotMessage(currentText)
                    }
                }
            }
        } catch {
            print("Failed to stream response: \(error)")
            receiveBotMessage("Sorry, there was an error streaming your request.")
        }
    }

    private func receiveBotMessage(_ message: String) {
        let botMessage = ChatMessage.assistant(message)
        DispatchQueue.main.async {
            self.messages.append(botMessage) // Append bot message to chat history
        }
    }
}
