//
//  duckApp.swift
//  duck
//
//  Created by troyfung on 6/3/2024.
//

import SwiftUI
import SwiftData

@main
struct duckApp: App {
    
    var body: some Scene {
        WindowGroup {
            let dateHolder = DateHolder()
            ContentView()
                .environmentObject(dateHolder)
        } 
        .modelContainer(for: [Expense.self, Category.self, Notes.self])
    }
}
