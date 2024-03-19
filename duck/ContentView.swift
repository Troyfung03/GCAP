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
    @State private var currentTab: String = "Expenses"
    var body: some View{
        TabView(selection: $currentTab){
            HomeView().tag("Home").tabItem {
                Image(systemName: "house")
            }
            CategoryView().tag("Category").tabItem{
                    Image(systemName:"list.bullet.rectangle.fill")
            }
            ExpenseView().tag("Expenses").tabItem { 
                    Image(systemName:"dollarsign.arrow.circlepath")
            }
            TimesView().tag("Time Manager").tabItem {
                    Image(systemName:"calendar")
            }
            NewsView().tag("News").tabItem {
                    Image(systemName:"newspaper")
            }
            ChatBotView().tag("ChatBot").tabItem {
                    Image(systemName:"shared.with.you")
            }
            
        }
    }
}


#Preview {
    ContentView()
}
