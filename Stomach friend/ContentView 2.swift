//
//  ContentView.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//

import SwiftUI

struct profilepageView: View {
   
   var body: some View {
      NavigationStack{
         
          VStack (alignment: .leading){
            
             topview()
             bottomview2()
               myfavorite()
                          
          }.padding(10)
        .background(Color(.systemPink).opacity(0.10))
       }
    }
}
struct topview:View {
    var body: some View {
        HStack{
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 10)
            VStack(alignment: .leading){
                Text("Kaptan")
                    .font(.title)
                    .bold()
                Text("kaptanbamaniya@gmail.com")
                    .font(.title2)
             }
        }
    }
}
struct bottomview2:View {
    var body: some View {
        ZStack{
           
            VStack{
                ZStack{
                    Rectangle()
                        .frame(width: 360, height: 50)
                        .foregroundColor(.gray)
                        .opacity(0.1)
                        .cornerRadius(10)
                    HStack{
                        NavigationLink{
                            favoriteview()
                        }label: {
                            Image(systemName: "bookmark.fill")
                                .font(.title)
                                .foregroundColor(.red)
                                
                            Text("Manage Favorites")
                                .bold()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 100))
                            Text("12")
                                .font(.title3)
                            Image(systemName: "chevron.right")
                        }.foregroundStyle(Color.primary)
                    }
                }
                ZStack{
                    Rectangle()
                        .frame(width: 360, height: 50)
                        .foregroundColor(.gray)
                        .opacity(0.1)
                        .cornerRadius(10)
                    HStack{
                       
                      
                        NavigationLink{
                            PopularRestaurant()
                        } label: {
                            Image(systemName: "map.fill")
                                .font(.title)
                                .foregroundColor(.red)
                                
                            Text("Visited Restaurants")
                                .bold()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 90))
                            Text("14")
                                .font(.title3)
                            Image(systemName: "chevron.right")
                        }.foregroundStyle(Color.primary)
                    }
                 
                }.padding(EdgeInsets(top: -13, leading: 0, bottom: 0, trailing: 0))
                ZStack{
                    Rectangle()
                        .frame(width: 360, height: 50)
                        .foregroundColor(.gray)
                        .opacity(0.1)
                        .cornerRadius(10)
                    HStack{
                       
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                            
                        Text("Write a Review")
                            .bold()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 130))
                        Text("14")
                            .font(.title3)
                        Image(systemName: "chevron.right")
                    }
                 
                }.padding(EdgeInsets(top: -13, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}
struct myfavorite: View {
    var column10 = [
        GridItem(.flexible(minimum: 50, maximum: 250),spacing: 10),
        GridItem(.flexible(minimum: 50, maximum: 250),spacing: 10),]
    var body: some View {
        HStack{
            Text("My  Favorites")
                .font(Font.title.bold())
        }
       ScrollView{
           LazyVGrid(columns: column10, spacing: 20){
               ForEach(movielist.indices, id: \.self) { img in
                   
                   VStack(spacing: -10){
                       ZStack{
                           Image("\(movielist[img])")
                           .resizable()
                           .frame(minHeight: 50)
                           .frame(maxHeight: 150)
                           .aspectRatio(1/1.5, contentMode: .fill)
                           .clipped()
                           ZStack{
                               Rectangle()
                               .frame(width: 30, height: 30)
                               .foregroundStyle(Color.white)
                               .cornerRadius(9)
                               Image(systemName: "heart.fill")
                                   .font(.system(size: 20))
                                   .foregroundStyle(Color.red)
                           }
                               .padding(EdgeInsets(top: -60, leading: 140, bottom: 0, trailing: 0))
                       }
                       
                       ZStack(alignment: .leading){
                           Rectangle()
                               .frame(height: 80)
                               .foregroundStyle(Color.black)
                               .opacity(0.1)
                       
                               Text("\(restaurantlist[img])")
                               .foregroundStyle(Color.black)
                               .font(.system(size: 14, weight: .bold))
                               .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                       }
                   }
                   .cornerRadius(20)
                   }
               }
           }
        }
    }

#Preview {
    profilepageView()
}
