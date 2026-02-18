//
//  ContentView.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//

import SwiftUI
var movielist = ["food1", "food2","food3", "food4", "food5"]
var catogarylist = ["Roti sabzi", "Fast food","Dosa", "Veg plate","paneer tikka"]
var restaurantlist = [" North indian", " Burger Hub"," South Indian", "Tau di chaat", "Non veg food"]
var restaurantimg = ["rest1", "rest2","rest4", "rest3", "rest4"]
struct Cardnames3: Identifiable{
    var id = UUID()
    var name:String
    var category:String
    var isliked:Bool
}
struct ContentView: View {
  
   var body: some View {
       NavigationStack{
          
           TabView{
               
               ZStack{
                   LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3),  .pink.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                       .edgesIgnoringSafeArea(.all)
                   VStack(alignment: .leading, spacing: 16){
                      
                       ScrollView{
                           
                           topheaderview()
                             bottomview()
                            scrollview( )
                       }
                   }.padding(10)
               }
              
               .tabItem {
                    Image(systemName: "house")
                        .foregroundStyle(.red)
                    Text("Explore")
                }
               VStack{
                   favoriteview()
               }.tabItem {
                   Image(systemName: "heart")
                    Text("favorites")
               }
               VStack{
                   profilepageView()
               }.tabItem {
                   Image(systemName: "person.fill")
                    Text("profile")
               }
           }
       }.toolbar(.hidden)
    }
}
struct topheaderview: View {
    var body: some View {
        HStack{
            VStack(alignment: .leading){
             Text("Hi, Kaptan")
                   .font(.title3)
             Text("find the best food around you")
                    .font(Font.caption.bold())
                 .foregroundStyle(Color.gray)
           }
            Spacer()
            Image(systemName: "magnifyingglass")
                 .font(.title3)
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
  
    }
}
struct bottomview: View {
    @State private var card3:[Cardnames3] = []
    init(){
        _card3 = State(initialValue: newcard3())
    }
    var column10 = [
        GridItem(.flexible(minimum: 50, maximum: .infinity),spacing: 10),
        GridItem(.flexible(minimum: 50, maximum: .infinity),spacing: 10),]
    var body: some View {
        LazyVGrid(columns: column10, spacing: 20){
            ForEach(card3.indices, id: \.self) { img in
                
                VStack(spacing: -10){
                    ZStack{
                        Image(card3[img].name)
                        .resizable()
                        .frame(minHeight: 50)
                        .frame(maxHeight: 250)
                        .aspectRatio(1/1, contentMode: .fill)
                        .clipped()
                        VStack{
                            HStack{
                                Spacer()
                                ZStack{
                                    Rectangle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color.white)
                                    .cornerRadius(9)
                                    Button{
                                        card3[img].isliked.toggle()
                               
                                    }label: {
                                        Image(systemName: card3[img].isliked ? "heart.fill" :"heart")
                                            .foregroundStyle(Color.red)
                                          
                                    }
                                }
                                
                            }
                            .padding(.trailing, 20)
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                    
                    ZStack(alignment: .leading){
                        Rectangle()
                            .frame(height: 60)
                            .foregroundStyle(Color.white)
                    
                            Text("\(catogarylist[img])")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 15, weight: .bold))
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                }
                .cornerRadius(20)
                    }
                   }
    }
}
struct scrollview: View {
   
    var body: some View {
        HStack{
            Text("Popular Restaurants")
                .font(Font.title.bold())
            Spacer()
            NavigationLink{
                
                    PopularRestaurant()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.gray)
            }
        }
        ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                     ForEach(restaurantimg.indices, id: \.self) { img in
                         VStack(spacing: -10){
                             ZStack{
                                 Image("\( restaurantimg[img])")
                                 .resizable()
                                 .frame(minHeight: 50)
                                 .frame(maxHeight: 150)
                                 .frame(width: 200)
                                 .aspectRatio(1/1, contentMode: .fill)
                                 .clipped()
                             }
                             
                             ZStack(alignment: .leading){
                                 Rectangle()
                                     .frame(height: 80)
                                     .foregroundStyle(Color.black)
                                     .opacity(0.1)
                             
                                 VStack{
                                     Text("\(restaurantlist[img])")
                                     .foregroundStyle(Color.black)
                                     .font(.system(size: 15, weight: .bold))
                                     .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                 HStack{
                                     Image(systemName: "star.fill")
                                         .foregroundColor(Color.yellow)
                                     Image(systemName: "star.fill")
                                         .foregroundColor(Color.yellow)
                                     Image(systemName: "star.fill")
                                         .foregroundColor(Color.yellow)
                                     Image(systemName: "star.fill")
                                         .foregroundColor(Color.yellow)
                                 }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                                 
                                 Text("4.5M Reviews")
                                 .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                                 }.padding(EdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0))
                             }
                         }
                         .cornerRadius(20)
                     }
             }
        }
    }
}
func newcard3() -> [Cardnames3]{
    var cards: [Cardnames3] = []
    for i in movielist{
        cards.append(Cardnames3(name:  "\(i)", category: "restaurantlist", isliked: false))
    }
    return cards
}
#Preview {
    ContentView()
}
