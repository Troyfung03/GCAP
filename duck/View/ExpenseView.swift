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
    
    @State private var addExpense: Bool = false
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
                        addExpense.toggle()
                    }label:{
                        Image(systemName: "plus.circle.fill").font(.title3)
                    }
                }
                
            }
            .onChange(of: allExpenses,initial: true){
                oldValue, newValue in
                if groupedExpenses.isEmpty{
                    createGroupedExpenses(newValue)
                }
            }
            .sheet(isPresented: $addExpense){
                AddExpenseView()
            }
        }}
        
        
        func createGroupedExpenses(_ expenses:[Expense]){
            Task.detached(priority: .high){
                let groupedDict = Dictionary(grouping: expenses){
                    expense in
                    let dateComponents = Calendar.current.dateComponents([.day,.month, .year], from: expense.date)
                    return dateComponents
                }
                
                
                let sortedDict = groupedDict.sorted{
                    let calendar = Calendar.current
                    let date1 = calendar.date(from: $0.key) ?? .init()
                    let date2 = calendar.date(from: $1.key) ?? .init()
                    return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
                }
                
                
                await MainActor.run{
                    groupedExpenses = sortedDict.compactMap({
                        dict in
                        let date = Calendar.current.date(from: dict.key) ?? .init()
                        
                        return .init(date:date, expenses: dict.value)
                    })
                    
                                                            }
                }
    }
    }
                                                            
#Preview {
  ExpenseView()
}
