import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationStack{
                    GifImage("duck")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Text("Hello! I am the duck manager")
                        .font(.title2)
                        .padding()
                        .bold()
                    
                }.navigationTitle("Home")
            }
        }
    }
}
#Preview {
    HomeView()
}
