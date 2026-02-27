//
//  favoriteview2.swift
//  Stomach friend
//
//  Created by applelab03 on 2/27/26.
//
import SwiftUI
import SwiftUI

struct favoriteview2: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var phone = ""
    @State private var seats = ""
    @State private var selectedDate = Date()
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                
                // Restaurant Image
                Image("rest1")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()
                
                // Title
                Text("North Indian")
                    .font(.title)
                    .bold()
                
                // Description
                Text("Peaceful Environment, Fresh Food, Indian, spanish, Italian food available")
                    .foregroundColor(.gray)
                
                // Reservation Heading
                Text("Reservation Details")
                    .font(.title3)
                    .bold()
                    .padding(.top, 10)
                
                // Name Field
                TextField("Enter Your Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.08))
                    .cornerRadius(10)
                
                // Phone Field
                TextField("Enter Your Phone Number", text: $phone)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray.opacity(0.08))
                    .cornerRadius(10)
                
                // Seats + Date + Time Row
                HStack(spacing: 10) {
                    
                    TextField("Number of seats", text: $seats)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.08))
                        .cornerRadius(10)
                    
//                    Text(formattedDate)
//                        .padding(.horizontal)
//                        .padding(.vertical, 8)
//                        .background(Color.gray.opacity(0.15))
//                        .cornerRadius(20)
//
//                    Text(formattedTime)
//                        .padding(.horizontal)
//                        .padding(.vertical, 8)
//                        .background(Color.gray.opacity(0.15))
//                        .cornerRadius(20)
                }
                
                // Hidden DatePicker (tap to change)
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .labelsHidden()
                
                Spacer(minLength: 40)
                
                // Done Button
                Button(action: {
                    print("Reservation Confirmed")
                }) {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.3))
                        .foregroundColor(.blue)
                        .cornerRadius(25)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    
    }
}

#Preview {
    NavigationStack {
        favoriteview2()
    }
}

