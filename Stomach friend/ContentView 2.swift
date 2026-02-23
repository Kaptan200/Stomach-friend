//
//  ContentView.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//

import SwiftUI
struct phpnames: Identifiable{
    var id = UUID()
    var name:String
    var category:String
    var isliked:Bool
}
struct profilepageView: View {
   
   var body: some View {
      NavigationStack{
         
          ZStack{
              LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3),  .pink.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                  .edgesIgnoringSafeArea(.all)
              VStack (alignment: .leading){
                
                 topview()
                 bottomview2()
                  HStack{
                      Text("My  Favorites")
                          .font(Font.title.bold())
                  }
                   myfavorite()
                  logut(auth: AuthViewModel())
                              
              }.padding(10)
            .background(Color(.systemPink).opacity(0.10))
          }
      }.toolbar(.hidden)
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
                HStack{
                    Text("Kaptan")
                        .font(.title)
                        .bold()
                    Spacer()
                    NavigationLink{
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                            .bold()
                            .foregroundStyle(Color.primary)
                    }
                }
                Text("kaptanbamaniya@gmail.com")
                    .font(.title2)
             }
        }
    }
}
struct bottomview2:View {
    var body: some View {
        ZStack{
           
            VStack(spacing:-1){
                NavigationLink{
                    favoriteview()
                }label: {
                    HStack{
                        Image(systemName: "bookmark.fill")
                            .font(.title)
                            .foregroundColor(.red)
                        Text("Managed favorites")
                            .bold()
                        Spacer()
                        Image(systemName: "chevron.right")
                         
                    }.foregroundStyle(Color.primary)
                    .padding()
                    .background(Color(.systemGray).opacity(0.3))
                    .cornerRadius(10)
                }
                NavigationLink{
                    PopularRestaurant()
                }label: {
                    HStack{
                        Image(systemName: "map.fill")
                            .font(.title)
                            .foregroundColor(.red)
                        Text("Visited restaurants")
                            .bold()
                        Spacer()
                        Image(systemName: "chevron.right")
                         
                     }.foregroundStyle(Color.primary)
                    .padding()
                    .background(Color(.systemGray).opacity(0.3))
                    .cornerRadius(10)
                }
                NavigationLink{
                    reviewpage()
                }label: {
                    HStack{
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                        Text("Write a review")
                            .bold()
                        Spacer()
                        Image(systemName: "chevron.right")
                         
                     }.foregroundStyle(Color.primary)
                    .padding()
                    .background(Color(.systemGray).opacity(0.3))
                    .cornerRadius(10)
                }
            }
        }
    }
}
struct myfavorite: View {
    @State private var card2:[phpnames] = []
    init(){
        _card2 = State(initialValue: new2card())
    }
    var column10 = [
        GridItem(.flexible(minimum: 50, maximum: .infinity),spacing: 10),
        GridItem(.flexible(minimum: 50, maximum: .infinity),spacing: 10),]
    var body: some View {
    
       
        ScrollView{
            LazyVGrid(columns: column10, spacing: 20){
                ForEach(card2.indices, id: \.self) { img in
                    
                    VStack(spacing: -10){
                        ZStack{
                            Image(card2[img].name)
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
                                            card2[img].isliked.toggle()
                                   
                                        }label: {
                                            Image(systemName: card2[img].isliked ? "heart.fill" :"heart")
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
    }
func new2card() -> [phpnames]{
    var cards2: [phpnames] = []
    for i in movielist{
        cards2.append(phpnames(name:  "\(i)", category: "restaurantlist", isliked: false))
    }
    return cards2
}

struct logut: View {
    @ObservedObject var auth: AuthViewModel
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                auth.logout()
            }){
                NavigationLink{
                    ContentView5()
                }label:{
                    Text("Logout \(Image(systemName: "rectangle.portrait.and.arrow.right"))")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(.systemPink))
                        .shadow(radius: 10)
                }
            }
            Spacer()
        }
        }
    }

#Preview {
    profilepageView()
}
