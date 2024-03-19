//
//  ExpenseView.swift
//  duck
//
//  Created by troyfung on 7/3/2024.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {
    // Grouped Expenses Properties
    @Query(sort:[ SortDescriptor(\Expense.date, order: .reverse)], animation: .snappy) 
    private var allExpenses: [Expense]
    
    
    @State private var groupedExpenses: [GroupedExpenses] = []
    var body: some View {
        NavigationStack{
            List{
            }
            .navigationTitle("Expenses")
            .overlay{
                if allExpenses.isEmpty || groupedExpenses.isEmpty{
                    ContentUnavailableView{
                        Label("No Expenses", systemImage:"tray.fill")
                    }
                }
            }
            //new category add button
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                    }label:{
                        Image(systemName: "plus.circle.fill").font(.title3)
                    }
                }
                
            }
            
        }
    }}

#Preview {
  ExpenseView()
}
