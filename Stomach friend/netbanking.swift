//
//  netbanking.swift
//  Stomach friend
//
//  Created by applelab03 on 2/25/26.
//
import SwiftUI

struct NetBankingPaymentView: View {
    
    @State private var selectedBank: String = ""
    @State private var selectedOtherBank: String = "Select Bank"
    
    let banks = [
        "State Bank of India",
        "ICICI Bank",
        "HDFC Bank",
        "Kotak Bank",
        "Axis Bank"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: Header
            Text("Payment Information")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.black)
            
            // MARK: Net Banking Title
            HStack {
                Text("Net Banking")
                    .font(.title3)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal)
            
            // MARK: Bank Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                
                ForEach(banks, id: \.self) { bank in
                    BankCardView(
                        bankName: bank,
                        isSelected: selectedBank == bank
                    ) {
                        selectedBank = bank
                    }
                }
            }
            .padding(.horizontal)
            
            // MARK: Other Banks Dropdown
            VStack(alignment: .leading, spacing: 8) {
                Text("All Other Banks")
                    .font(.subheadline)
                
                Picker("Select Bank", selection: $selectedOtherBank) {
                    Text("Select Bank").tag("Select Bank")
                    Text("Yes Bank").tag("Yes Bank")
                    Text("Punjab National Bank").tag("PNB")
                    Text("Canara Bank").tag("Canara Bank")
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.5))
                )
            }
            .padding(.horizontal)
            
            // MARK: Note
            Text("Note: We will redirect you to the bank you have chosen above. Once the bank verifies your net banking credentials, we will proceed with your payment.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // MARK: Amount
            HStack {
                Text("INR 2163.42")
                    .font(.title2)
                    .foregroundColor(.orange)
                    .bold()
                
                Text("(Total Amount Payable)")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // MARK: Buttons
            HStack(spacing: 20) {
                
                Button(action: {
                    print("Make Payment tapped")
                }) {
                    Text("Make Payment")
                        .foregroundColor(.white)
                        .frame(width: 150, height: 45)
                        .background(Color.black)
                        .cornerRadius(6)
                }
                
                Button(action: {
                    print("Cancel tapped")
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .frame(width: 100, height: 45)
                        .background(Color.black)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.systemGray6))
    }
}

struct BankCardView: View {
    
    var bankName: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(.gray)
                
                Text(bankName)
                    .font(.caption)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .frame(height: 60)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4))
            )
            .cornerRadius(8)
        }
    }
}

#Preview {
    NetBankingPaymentView()
}
