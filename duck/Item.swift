//
//  Item.swift
//  duck
//
//  Created by troyfung on 6/3/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
