//
//  favorite.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//
import SwiftUI
struct favoriteview: View {
    @State var isliked:Bool = false
    var column10 = [
    GridItem(.flexible(minimum: 50, maximum: 250),spacing: 10),
    GridItem(.flexible(minimum: 50, maximum: 250),spacing: 10),]
    var body: some View {
       
        NavigationStack{
            VStack(alignment:.leading){
                HStack{
                 
                    NavigationLink(destination: ContentView()){
                        Image(systemName: "chevron.left")
                            .bold()
                     }.foregroundStyle(Color.primary)
                         Spacer()
                        Text("Favorites")
                            .font(Font.title.bold())
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundStyle(Color.red)
                   
                }
                Spacer()
                Spacer()
                    Text("My  Favorites")
                        .font(Font.title.bold())
             
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
                                        Button{
                                            isliked.toggle()
                                   
                                        }label: {
                                            Image(systemName: isliked ? "heart" :"heart.fill")
                                                .foregroundStyle(Color.red)
                                              
                                        }
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
                                        .font(.system(size: 13, weight: .bold))
                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                }
                            }
                            .cornerRadius(20)
                                }
                               }
                                
                }
            }.padding(10)
            .background(Color(.systemPink).opacity(0.10))
        }.toolbar(.hidden)
    }
}

#Preview {
    favoriteview()
}
