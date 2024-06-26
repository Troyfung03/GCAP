import SwiftUI
import SwiftData

struct CategoryView: View {
    @Query(animation: .snappy) private var allCategories : [Category]
    @Environment(\.modelContext) private var context
    @State private var categoryName: String = ""
    @State private var addCategory: Bool = false
    @State private var deleteRequest: Bool = false
    @State private var requestedCategory: Category?
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(allCategories.sorted(by: {
                    ($0.expenses?.count ?? 0) > ($1.expenses?.count ?? 0)
                })) { category in
                    DisclosureGroup {
                        if let expenses = category.expenses, !expenses.isEmpty {
                            ForEach(expenses) { expense in
                                ExpenseCardView(expense: expense, displayTag: false)
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No Expenses", systemImage:"tray.fill")
                            }
                        }
                    } label: {
                        Text(category.categoryName)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            deleteRequest.toggle()
                            requestedCategory = category
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
                .navigationTitle("Categories")
                .overlay {
                    if allCategories.isEmpty {
                        ContentUnavailableView {
                            Label("No Categories", systemImage:"tray.fill")
                        }
                    }
                }
                
                .presentationDetents([.height(180)])
                .presentationCornerRadius(20)
                .interactiveDismissDisabled()
            }
            .alert("If you delete a category, all the associated expenses will be deleted too!",
                   isPresented: $deleteRequest) {
                Button(role: .destructive) {
                    if let requestedCategory = requestedCategory {
                        context.delete(requestedCategory)
                        self.requestedCategory = nil
                    }
                } label: {
                    Text("Delete")
                }
                Button(role: .cancel) {
                    requestedCategory = nil
                } label: {
                    Text("Cancel")
                }
            }
        }                
        .toolbar {
            ToolbarItem(placement:.topBarTrailing) {
                Button {
                    addCategory.toggle()
                } label: {
                    Image(systemName:"plus.circle.fill").font(.title3)
                }
            }
        }
        .sheet(isPresented: $addCategory) {
            categoryName = ""
        } content: {
            NavigationStack {
                List {
                    Section("Title") {
                        TextField("Category Name", text: $categoryName)
                    }
                }
                .navigationTitle("Category Name")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            addCategory = false
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            let category = Category(categoryName: categoryName)
                            context.insert(category)
                            categoryName = ""
                            addCategory = false
                        }
                        .disabled(categoryName.isEmpty)
                    }
                }
            }
        }
    }
}
