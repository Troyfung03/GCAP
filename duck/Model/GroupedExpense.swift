//
//  GroupedExpense.swift
//  duck
//
//  Created by troyfung on 19/3/2024.
//

import SwiftUI

struct GroupedExpenses: Identifiable{
    var id: UUID = .init()
    var date: Date
    var expenses: [Expense]
}

