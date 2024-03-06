//
//  Expense.swift
//  duck
//
//  Created by troyfung on 6/3/2024.
//

import SwiftUI
import SwiftData

@Model
class Expense{
    
    var title: String
    var subt: String
    var amount: Double
    var date: Date
    var category: Category?
    
    init(title: String, subt: String, amount: Double, date: Date, category: Category? = nil) {
        self.title = title
        self.subt = subt
        self.amount = amount
        self.date = date
        self.category = category
    }
}
