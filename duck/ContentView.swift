//
//  ContentView.swift
//  duck
//
//  Created by troyfung on 6/3/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //View Properties
    @State private var currentTab: String = "Home"
    
    var body: some View {
        NavigationView {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag("Home").tabItem {
                        Image(systemName:"house")
                    }
                NewsView()
                    .tag("News").tabItem {
                        Image(systemName:"newspaper")
                    }
                ChatBotView(viewModel: ChatViewModel())
                    .tag("ChatBot").tabItem {
                        Image(systemName:"shared.with.you")
                    }
                ExpenseView().tag("Expenses").tabItem {
                    Image(systemName:"dollarsign.arrow.circlepath")
                }
                TimesView()
                    .tag("Time Manager").tabItem {
                        Image(systemName:"calendar")
                    }
                
            }}}}

#Preview {
    ContentView()
}
