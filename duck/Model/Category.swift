//
//  Expense.swift
//  duck
//
//  Created by troyfung on 6/3/2024.
//

import SwiftUI
import SwiftData

@Model
class Category{
    var categoryName: String
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    init(categoryName: String, expenses: [Expense]? = nil) {
        self.categoryName = categoryName
        self.expenses = expenses
    }
}
