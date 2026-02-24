//
//  visitedview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/23/26.
//
import SwiftUI

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let cuisine: String
    let location: String
    let rating: Double
    let lastVisited: String
    let imageName: String
}

struct VisitedRestaurantsView: View {
    @Environment(\.dismiss) private var dismiss
    let restaurants = [
        Restaurant(name: "Bella Italiano",
                   cuisine: "Italian",
                   location: "Downtown",
                   rating: 4.5,
                   lastVisited: "2 days ago",
                   imageName: "rest1"),
        
        Restaurant(name: "Sushi Haven",
                   cuisine: "Japanese",
                   location: "Midtown",
                   rating: 4.0,
                   lastVisited: "1 week ago",
                   imageName: "rest2"),
        
        Restaurant(name: "Grill House",
                   cuisine: "Steakhouse",
                   location: "Uptown",
                   rating: 4.2,
                   lastVisited: "3 weeks ago",
                   imageName: "rest3"),
        
        Restaurant(name: "Cafe Delight",
                   cuisine: "Cafe",
                   location: "Riverside",
                   rating: 4.0,
                   lastVisited: "1 month ago",
                   imageName: "rest4")
    ]
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3),  .pink.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                
                    HStack{
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .bold()
                         }
                         .foregroundStyle(Color.primary)
                        Spacer()
                        Text("Visited Restaurants")
                            .font(.title)
                            .bold()
                        
                     Spacer()
                    }
                    .padding()
                    
                   
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(restaurants) { restaurant in
                                RestaurantCard(restaurant: restaurant)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
       
            }
        }.toolbar(.hidden)
    }
}

struct RestaurantCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Image
            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 100)
                .cornerRadius(12)
                .clipped()
            
           
            VStack(alignment: .leading, spacing: 6) {
                
                Text(restaurant.name)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(restaurant.rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                    }
                    
                    Text(String(format: "%.1f", restaurant.rating))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text("\(restaurant.cuisine) • \(restaurant.location)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Visited \(restaurant.lastVisited)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    VisitedRestaurantsView()
}
