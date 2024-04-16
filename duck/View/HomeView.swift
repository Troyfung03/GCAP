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
                NavigationStack{
                    List{
                        Text("Recent Schedules")
                        Rectangle().frame(height: 100).padding()
                        Text("Recent News")
                        Rectangle().frame(height: 100).padding()
                    }.navigationTitle("Home")
                } .padding(.trailing)
                
            }
        }
    }
}
#Preview {
    HomeView()
}
