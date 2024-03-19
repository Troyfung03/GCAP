//
//  HomeView.swift
//  duck
//
//  Created by troyfung on 19/3/2024.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ExpenseView()) {
                    Text("Category")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .tag("Category")
                .tabItem{
                    Image(systemName:"list.bullet.rectangle.fill")
                    Text("Category")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
