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
            CategoryView()
                .tag("Category").tabItem{
                    Image(systemName:"list.bullet.rectangle.fill")
                    Text("Category")
                }
            HomeView().tag("Home").tabItem {
                Image(systemName: "house.circle.fill")
                Text("Home")}
            ExpenseView()
                .tag("Expenses").tabItem { Image(systemName:"dollarsign.arrow.circlepath")
                    Text("Expenses")
                }
        }
        }
    }

#Preview {
    ContentView()
}
