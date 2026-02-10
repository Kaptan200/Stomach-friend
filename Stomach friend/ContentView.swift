//
//  ContentView.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//

import SwiftUI
var movielist = ["food1", "food2","food3", "food4"]
var catogarylist = ["Roti sabzi", "Fast food","Dosa", "Veg plate"]
struct ContentView: View {
   var body: some View {
       TabView{
           VStack(alignment: .leading, spacing: 16){
                   topheaderview()
                     bottomview()
                    scrollview()
            }.tabItem {
                Image(systemName: "house")
                    .foregroundStyle(.red)
                Text("Explore")
            }
           VStack{
               ContentView()
           }.tabItem {
               Image(systemName: "heart")
                Text("favorites")
           }
           VStack{
               ContentView()
           }.tabItem {
               Image(systemName: "person.fill")
                Text("search")
           }
       }
    }
}
struct topheaderview: View {
    var body: some View {
        HStack{
            VStack(alignment: .leading){
             Text(" HI, DEAR")
                   .font(.title2)
             Text("find the best food around you")
                 .foregroundStyle(Color.gray)
           }
            Spacer()
            Image(systemName: "magnifyingglass")
                 .font(.title2)
        }
        .padding(.horizontal)
   HStack{
       Image(systemName: "magnifyingglass")
           .foregroundStyle(Color.gray)
       Text("search for dishes or restaurants...")
           .foregroundStyle(Color.gray)
       Spacer()
       Image(systemName: "mic.fill")
        .foregroundStyle(Color.gray)
    }
   .padding()
   .background(Color(.systemBlue).opacity(0.10))
   .cornerRadius(120)
   .padding(.horizontal)
    }
}
struct bottomview: View {
    var column10 = [
        GridItem(.flexible(minimum: 50, maximum: 250),spacing: 10),
        GridItem(.flexible(minimum: 50, maximum: 250),spacing: 10),]
    var body: some View {
        LazyVGrid(columns: column10, spacing: 20){
            ForEach(movielist.indices, id: \.self) { img in
                  
                          ZStack(alignment: .topTrailing){
                            VStack(alignment: .leading){
                                Image("\(movielist[img])")
                                    .resizable()
                                     .frame(minHeight: 50)
                                    .frame(maxHeight: 150)
                                    .aspectRatio(1/1.5, contentMode: .fill)
                                    .clipped()
                                    .cornerRadius(20)
                                Text("\(catogarylist[img])")
                                    .foregroundStyle(Color.white)
                                    .padding(EdgeInsets(top: -30, leading: 8, bottom: 8, trailing: 0))
                            }
                              Image(systemName: "heart.fill")
                                  .foregroundStyle(Color.red)
                                  .padding(8)
                         }
                       }
                   }
                    .padding(.horizontal)
    }
}
struct scrollview: View {
    var body: some View {
        HStack{
            Text("Popular Restaurants")
                .font(Font.title.bold())
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.gray)
        }.padding(10)
        ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                     ForEach(movielist.indices, id: \.self) { img in
                        Image("\(movielist[img])")
                             .resizable()
                              .frame(minHeight: 50)
                             .frame(maxHeight: 250)
                             .aspectRatio(1/1.5, contentMode: .fill)
                             .clipped()
                             .cornerRadius(20)
                         Text("\(catogarylist[img])")
                             .foregroundStyle(Color.white)
                             .padding(EdgeInsets(top: 200, leading: -150, bottom: 0, trailing: 0))
                   }
                 .padding(1)
             }
        }.padding(10)
    }
}
#Preview {
    ContentView()
}
