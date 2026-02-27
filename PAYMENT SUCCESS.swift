//
//  PAYMENT SUCCESS.swift
//  Stomach friend
//
//  Created by applelab03 on 2/26/26.
//
import SwiftUI

struct PaymentSuccessView: View {
    
    var amount: Double
    var transactionID: String
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Spacer()
                
                // MARK: Success Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .foregroundColor(.green)
                }
                
                // MARK: Title
                Text("Payment Successful")
                    .font(.title)
                    .bold()
                
                // MARK: Amount
                Text("₹ \(String(format: "%.2f", amount))")
                    .font(.title2)
                    .foregroundColor(.green)
                    .bold()
                
                // MARK: Transaction ID
                VStack(spacing: 5) {
                    Text("Transaction ID")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Text(transactionID)
                        .font(.headline)
                }
                
                Spacer()
                
                // MARK: Button
                NavigationLink {
                    
                }label: {
                    Text("Back to Home")
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    PaymentSuccessView(
        amount: 2163.42,
        transactionID: "TXN123456789"
    )
}
