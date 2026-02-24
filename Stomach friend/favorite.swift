//
//  favorite.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//
import SwiftUI
struct Cardnames: Identifiable{
    var id = UUID()
    var name:String
    var category:String
    var isliked:Bool
}
struct favoriteview: View {
    @Environment(\.dismiss) private var dismiss
    @State private var card:[Cardnames] = []
    init(){
        _card = State(initialValue: newcard())
    }
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
                     
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .bold()
                         }
                         .foregroundStyle(Color.primary)
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
                      
                 
                    ScrollView{
                        LazyVGrid(columns: column10, spacing: 20){
                            ForEach(card.indices, id: \.self) { img in
                                
                                VStack(spacing: -10){
                                    ZStack{
                                        Image(card[img].name)
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
                                                        card[img].isliked.toggle()
                                               
                                                    }label: {
                                                        Image(systemName: card[img].isliked ? "heart.fill" :"heart")
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
                }.padding(10)
                .background(Color(.systemPink).opacity(0.10))
            }
        }.toolbar(.hidden)
    }
    func newcard() -> [Cardnames]{
        var cards: [Cardnames] = []
        for i in movielist{
            cards.append(Cardnames(name:  "\(i)", category: "restaurantlist", isliked: false))
        }
        return cards
    }
}

#Preview {
    favoriteview()
}
