//
//  popular restaurant.swift
//  Stomach friend
//
//  Created by applelab03 on 2/11/26.
//

import SwiftUI
struct PopularRestaurant: View {
    var column10 = [
        GridItem(.flexible(minimum: 50, maximum: .infinity),spacing: 10),
        GridItem(.flexible(minimum: 50, maximum: .infinity),spacing: 10),]
    var body: some View {
NavigationStack{
    ZStack{
        LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3),  .pink.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
        VStack(alignment:.leading){
            HStack{
                NavigationLink{
                    ContentView()
                }label: {
                    Image(systemName: "chevron.left")
                         .foregroundStyle(Color.black)
                         .bold()
                }
              Spacer()
                Text("Popular Restaurants")
                    .font(Font.title.bold())
                Spacer()
            }.padding(10)
            ScrollView{
                LazyVGrid(columns: column10, spacing: 20){
                    ForEach(restaurantimg.indices, id: \.self) { img in
                        
                        VStack(spacing: -10){
                            ZStack{
                                Image("\(restaurantimg[img])")
                                .resizable()
                                .frame(minHeight: 50)
                                .frame(maxHeight: 150)
                                .aspectRatio(1/1, contentMode: .fill)
                                .clipped()
                              
                            }
                            
                            ZStack{
                                Rectangle()
                                    .frame(height: 80)
                                    .foregroundStyle(Color.white)
                                   
                            
                                VStack(alignment: .leading){
                                    Text("\(restaurantlist[img]) ")
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 18, weight: .bold))
                                   
                                    HStack(spacing: 1){
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.yellow)
                                            .font(.footnote)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.yellow)
                                            .font(.footnote)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.yellow)
                                            .font(.footnote)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.yellow)
                                            .font(.footnote)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.gray)
                                            .font(.footnote)
                                    }
                                   
                                    
                                    Text("4.5M Reviews")
                              
                                }
                                .padding(EdgeInsets(top: 0, leading: -60, bottom: 0, trailing: 0))
                                
                            }
                        }
                        .cornerRadius(20)
                            }
                           }
                            
            }
        }.padding(10)
    }
   
}.toolbar(.hidden)
    }
}
#Preview {
    PopularRestaurant()
}
