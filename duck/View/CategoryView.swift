//
//  CategoryView.swift
//  duck
//
//  Created by troyfung on 7/3/2024.
//

import SwiftUI
import SwiftData
struct CategoryView: View {
    @Query(animation: .snappy) private var allCategories : [Category]
    @Environment(\.modelContext) private var context
    @State private var categoryName: String = ""
    @State private var addCategory: Bool = false
    var body: some View {
        NavigationStack{
            List{
                ForEach(allCategories){ category in
                DisclosureGroup{
                    if let expenses = category.expenses, !expenses.isEmpty{
                        ForEach(expenses){ expense in
                            ExpenseCardView(expense: expense)
                        }
                    }else{
                        ContentUnavailableView{
                            Label("No Expenses", systemImage:"tray.fill")
                        } 
                    }
                }label:{
                    Text(category.categoryName)
                }
                }
            }.navigationTitle("Categories")
            .overlay{
                if allCategories.isEmpty{
                    ContentUnavailableView{
                        Label("No Categories", systemImage:"tray.fill")
                    }
                }
            }
                .toolbar{
                    ToolbarItem(placement:.topBarTrailing){
                        Button{
                            addCategory.toggle()
                        } label:{
                            Image(systemName:"plus.circle.fill").font(.title3)
                        }
                    }
                }
                .sheet(isPresented: $addCategory){
                    categoryName="" } content : {
                   NavigationStack{
                    List{
Section("Title"){
    TextField("Category Name", text: $categoryName)
}

                    }
                    .navigationTitle("Category Name")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading){
                            Button("Cancel"){
                                addCategory = false
                            }
                            .tint(.red)
                        }
                        ToolbarItem(placement: .topBarTrailing){
                            Button("Add"){
                                let category = Category(categoryName: categoryName)
                                context.insert(category)
                                categoryName = ""
                                 addCategory = false
                            }
                            .disabled(categoryName.isEmpty)
                        }
                    }
                   }
                }.presentationDetents([.height(180)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    CategoryView()
}
