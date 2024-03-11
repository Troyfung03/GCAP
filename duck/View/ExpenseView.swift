//
//  ExpenseView.swift
//  duck
//
//  Created by troyfung on 7/3/2024.
//

import SwiftUI

struct ExpenseView: View {
    // Grouped Expenses Properties
    var body: some View {
        NavigationStack{
            List{
            }
            .navigationTitle("Expenses")
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
