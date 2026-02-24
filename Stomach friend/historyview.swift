//
//  historyview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct OrderHistoryView: View {
    
    let historyItems = [
        "Order #1234 - Delivered",
        "Order #5678 - Cancelled",
        "Order #9101 - Delivered"
    ]
    
    var body: some View {
        List(historyItems, id: \.self) { item in
            Text(item)
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    OrderHistoryView()
}

