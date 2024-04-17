//
//  ExpenseCardView.swift
//  duck
//
//  Created by troyfung on 17/4/2024.
//

import SwiftUI

struct ExpenseCardView: View {
    @Bindable var expense: Expense
    var displayTag : Bool = true
    var body: some View {  
        HStack{
            VStack(alignment: .leading){
                Text(expense.title)
                Text(expense.subt)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            if let categoryName = expense.category?.categoryName, displayTag{
                Text(categoryName)
                    .font(.caption2)
                    .foregroundStyle(.white)
                    .padding(.horizontal,10)
                    .padding(.vertical,4)
                    .background(.red.gradient, in: .capsule)
            }}
        .lineLimit(1)
        Spacer(minLength: 5)

        Text(expense.currencyString)
        .font(.title3.bold())
    }
     }

