import SwiftUI

struct Source: Decodable {
    let id: String?
    let name: String
}

struct News: Decodable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [News]
}

class NewsAPI: ObservableObject {
    @Published var news = [News]()
    @Published var searchTerm = ""
    
func fetchNews() {
    let base = searchTerm.isEmpty ? "https://newsapi.org/v2/top-headlines?country=us" : "https://newsapi.org/v2/top-headlines"
    let query = searchTerm.isEmpty ? "" : "?q=\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
    let apiKey = "&apiKey=b39a5c0b11da4a2597d048c140b41d57"
    let url = URL(string: base + query + apiKey)!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data {
            if let decodedResponse = try? JSONDecoder().decode(NewsResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.news = decodedResponse.articles
                }
                return
            }
        }
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
    }.resume()
}
}
struct NewsView: View {
        @ObservedObject var api = NewsAPI()
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        TextField("Search", text: $api.searchTerm, onCommit: {
                            api.fetchNews()
                        })
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .keyboardType(.default)
                        ForEach(api.news, id: \.title) { item in
                            Link(destination: URL(string: item.url)!, label: {
                                VStack(alignment: .leading) {
                                    if let imageUrl = item.urlToImage, let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image.resizable().scaledToFit()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    Text(item.title)
                                        .font(.headline).multilineTextAlignment(.leading)
                                    Text(item.source.name)
                                        .font(.subheadline).multilineTextAlignment(.leading)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(60)
                            }).frame(alignment: .leading)
                                .foregroundColor(.black)
                            Divider() // Add this line
                        }
                    }
                }
                .navigationTitle("Recent News")
            }
            .onAppear(perform: {
                api.fetchNews()
            })
        }
    }


#Preview {
    NewsView()
}
