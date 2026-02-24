//
//  review page.swift
//  Stomach friend
//
//  Created by applelab03 on 2/18/26.
//
import SwiftUI
struct review: Identifiable{
    let id = UUID()
    let name: String
    let rating: Int
    let comment: String
}
struct reviewpage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var reviews: [review] = []
    var body: some View {
    NavigationStack{
        VStack{
            VStack(alignment: .leading,spacing: 12){
                HStack(spacing: 130){
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .bold()
                     }
                     .foregroundStyle(Color.primary)
                  
                    Text("Reviews")
                        .font(.title)
                        .bold()
                    
                }
                Text("write a review")
                    .font(.title2)
                    .bold()
                TextField("NAME", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack{
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                rating = star
                            }
                        
                    }
                }
               TextField("WRITE YOUR REVIEW HERE", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("submit"){
                    let newReview = review(name: name, rating: rating, comment: comment)
                    reviews.append(newReview)
                }.frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            
            }.padding(10)
            List(reviews){review in
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        Text(review.name)
                            .font(.headline)
                        HStack{
                            ForEach(1...5, id: \.self) { star in
                                if star <= review.rating {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(Color(.yellow))
                                } else {
                                    Image(systemName: "star")
                                }
                            }
                        }
                    }
                    Text(review.comment)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 5)
            }
        }
    }.toolbar(.hidden)
        }
    }

#Preview {
    reviewpage()
}
