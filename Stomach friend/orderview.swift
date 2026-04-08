//
//  orderview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var orderStore: OrderStore

    var body: some View {
        Group {
            if orderStore.orders.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bag")
                        .font(.system(size: 50))
                        .foregroundStyle(.gray)

                    Text("No orders yet")
                        .font(.title3.bold())

                    Text("Your confirmed orders will appear here")
                        .foregroundStyle(.gray)
                }
            } else {
                List {
                    ForEach(orderStore.orders) { order in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Total: ₹\(Int(order.totalAmount))")
                                .font(.headline)

                            Text(order.orderDate.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.gray)

                            ForEach(order.items) { item in
                                HStack {
                                    Text(item.food.category)
                                    Spacer()
                                    Text("x\(item.quantity)")
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("My Orders")
    }
}
#Preview {
   
    OrdersView()
        .environmentObject(OrderStore())
}

