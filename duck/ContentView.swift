//
//  ContentView.swift
//  duck
//
//  Created by troyfung on 6/3/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var currentTab: String = "Expenses"
    var body: some View{
        TabView(selection: $currentTab){
            ExpenseView()
                .tag("Expenses").tabItem { Image(systemName:"dollarsign.arrow.circlepath")
                    Text("Expenses")
                }
            CategoryView()
                .tag("Category").tabItem{
                Image(systemName:"list.bullet.rectangle.fill")
                Text("Category")
            }
                
            }

        }
    }

#Preview {
    ContentView()
}
