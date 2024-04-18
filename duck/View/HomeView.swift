import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationStack{
                    GifImage("duck")
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.4)
                    
                    Text("Nice to meet you!")
                        .font(.title2)
                        .padding()
                        .bold()
                    Text("I am the duck manager ^_^")
                        .font(.title2)
                        .bold()
                }.navigationTitle("Homepage")
            }
        }
    }
}

#Preview {
    HomeView()
}
