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
    
func fetchNews(region: String, category: String) {
    var base = "https://newsapi.org/v2/top-headlines?country=\(region)&category=\(category)"
    let apiKey = "&apiKey=b39a5c0b11da4a2597d048c140b41d57"
    
    var url = URL(string: base+apiKey)!
    
    if !searchTerm.isEmpty {
        let query = "q=\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        base = "https://newsapi.org/v2/everything?\(query)&sortBy=popularity"
        url = URL(string: base + apiKey)!
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
    @State private var selectedCategory =  "general"
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Add this picker for region
                    Picker("Category", selection: $selectedCategory) {
                        Text("General").tag("general")
                        Text("Business").tag("business")
                        Text("Technology").tag("technology")
                        
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
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
                    let regions = ["Argentina": "ar", "Greece": "gr", "Netherlands": "nl", "South Africa": "za", "Australia": "au", "Hong Kong": "hk", "New Zealand": "nz", "South Korea": "kr", "Austria": "at", "Hungary": "hu", "Nigeria": "ng", "Sweden": "se", "Belgium": "be", "India": "in", "Norway": "no", "Switzerland": "ch", "Brazil": "br", "Indonesia": "id", "Philippines": "ph", "Taiwan": "tw", "Bulgaria": "bg", "Ireland": "ie", "Poland": "pl", "Thailand": "th", "Canada": "ca", "Israel": "il", "Portugal": "pt", "Turkey": "tr", "China": "cn", "Italy": "it", "Romania": "ro", "UAE": "ae", "Colombia": "co", "Japan": "jp", "Russia": "ru", "Ukraine": "ua", "Cuba": "cu", "Latvia": "lv", "Saudi Arabia": "sa", "United Kingdom": "gb", "Czech Republic": "cz", "Lithuania": "lt", "Serbia": "rs", "United States": "us", "Egypt": "eg", "Malaysia": "my", "Singapore": "sg", "Venezuela": "ve", "France": "fr", "Mexico": "mx", "Slovakia": "sk", "Germany": "de", "Morocco": "ma", "Slovenia": "si"]
                    let sortedRegions = regions.keys.sorted()
                    
                    Menu {
                        ForEach(sortedRegions, id: \.self) { region in
                            Button(action: {
                                selectedRegion = regions[region] ?? "us"
                            }) {
                                Text(region)
                            }
                        }
                    } label: {
                        var selectedRegionName: String {
                            return regions.first(where: { $1 == selectedRegion })?.key ?? "United States"
                        }
                        Text("Region: \(selectedRegionName)")
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
        .onChange(of: selectedRegion) { newValue in
            api.fetchNews(region: newValue, category: selectedCategory)
        }
        .onChange(of: selectedCategory) { newValue in
            api.fetchNews(region: selectedRegion, category: newValue)
        }
       }
}
#Preview {
    NewsView()
}
