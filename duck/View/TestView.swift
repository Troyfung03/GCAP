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
    
func fetchNews(region: String, category: String?) {
    var base = "https://newsapi.org/v2/top-headlines/sources?country=\(region)"
    let apiKey = "&apiKey=b39a5c0b11da4a2597d048c140b41d57"
    var url = URL(string: base + apiKey)!
    
    if !searchTerm.isEmpty {
        let query = "&q=\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        url = URL(string: base + query + apiKey)!
    }

    print("URL: \(url)") // Print the URL

    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.news = decodedResponse.articles
                }
            } catch {
                print("Decoding failed: \(error)") // Print decoding errors
            }
        } else if let error = error {
            print("Fetch failed: \(error.localizedDescription)") // Print network errors
        }
    }.resume()
}}

struct NewsView: View {
    @ObservedObject var api = NewsAPI()
    
    // Add these state variables
    @State private var selectedRegion = "us"
    @State private var selectedCategory =  "None" // Set default category to "None"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Search", text: $api.searchTerm, onCommit: {
                        api.fetchNews(region: selectedRegion, category: selectedCategory)
                    })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass") // Add a search logo
                        }
                            .padding(.horizontal, 8)
                    )
                    .padding(.horizontal)
                    .keyboardType(.default)
                    
                    // Add this picker for region
                    Picker("Region", selection: $selectedRegion) {
                        Text("US").tag("us")
                        Text("UK").tag("gb")
                        // Add more regions as needed
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Add this picker for category
                    Picker("Category", selection: $selectedCategory) {
                        Text("General").tag("general")
                        Text("Business").tag("business")
                        Text("Technology").tag("technology")
                        // Add more categories as needed
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    ForEach(api.news, id: \.title) { item in
                        Link(destination: URL(string: item.url)!, label: {
                            VStack(alignment: .leading) {
                                if let imageUrl = item.urlToImage, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFit()
                                    } placeholder: {
                                        Image("News")
                                            .resizable()
                                            .scaledToFit()
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
            api.fetchNews(region: selectedRegion, category: selectedCategory)
        })
    }
}

#Preview {
    NewsView()
}
