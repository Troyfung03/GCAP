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
    @Environment(\.modelContext) private var context
    @State private var showCategoryView = false
  var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    showCategoryView = true
                }) {
                    Text("Go to Category View")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .background(
                    NavigationLink(
                        destination: CategoryView(),
                        isActive: $showCategoryView,
                        label: { EmptyView() }
                    ))
                List {
                    ForEach($groupedExpenses) { $group in
                        Section(group.groupTitle) {
                            ForEach(group.expenses) { expense in
                                ExpenseCardView(expense: expense)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button {
                                            context.delete(expense)
                                            withAnimation {
                                                group.expenses.removeAll(where: { $0.id == expense.id })
                                                if group.expenses.isEmpty {
                                                    groupedExpenses.removeAll(where: { $0.id == group.id })
                                                }
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }    .tint(.red)
                                        
                                    }
                            }
                        }
                    }
                }
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
                    ToolbarItem(placement:.topBarTrailing){
                        Button{
                            addExpense.toggle()
                        } label:{
                            Image(systemName:"plus.circle.fill").font(.title3)
                        }
                    }
                }
                .onChange(of: allExpenses,initial:true){
                    oldValue,  newValue in
                    if newValue.count > oldValue.count || groupedExpenses.isEmpty{
                        createGroupedExpenses(newValue)
                    }
                    
                }
            
            
            
                .sheet(isPresented: $addExpense){
                    AddExpenseView()
                        .interactiveDismissDisabled()
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
            
            await MainActor.run {
                groupedExpenses = sortedDict.compactMap ({
                    dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return GroupedExpenses(date: date, expenses: dict.value)
                })
            }
        }
    }
    
}

#Preview{
    ExpenseView()
}
