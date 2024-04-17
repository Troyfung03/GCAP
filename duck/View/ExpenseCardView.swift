//
//  ExpenseCardView.swift
//  duck
//
//  Created by troyfung on 17/4/2024.
//

import SwiftUI

struct ExpenseCardView: View {
    @Bindable var expense: Expense
    var body: some View {  
    HStack{
        VStack(alignment: .leading){
            Text(expense.title)
            Text(expense.subt)
            .font(.caption)
            .foregroundStyle(.gray)
        }
        .lineLimit(1)
        Spacer(minLength: 5)

        Text(expense.currencyString)
        .font(.title3.bold())
    }
     }
}
