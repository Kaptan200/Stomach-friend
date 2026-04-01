//
//  favorite.swift
//  Stomach friend
//
//  Created by applelab03 on 2/10/26.
//

import SwiftUI

struct Cardnames: Identifiable {
    var id = UUID()
    var name: String
    var category: String
    var isliked: Bool
}

struct favoriteview: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favoritesStore: FavoritesStore

    var column10 = [
        GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 10),
        GridItem(.flexible(minimum: 50, maximum: .infinity), spacing: 10)
    ]

    /// Only the items the user has hearted
    var likedItems: [Int] {
        movielist.indices.filter { favoritesStore.isLiked(movielist[$0]) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .pink.opacity(0.6)]),
                    startPoint: .top, endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left").bold()
                        }
                        .foregroundStyle(Color.primary)
                        Spacer()
                        Text("Favorites")
                            .font(Font.title.bold())
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "heart.fill").foregroundStyle(Color.red)
                    }

                    Spacer()

                    if likedItems.isEmpty {
                        // Empty state
                        VStack(spacing: 12) {
                            Spacer()
                            Image(systemName: "heart.slash")
                                .font(.system(size: 60))
                                .foregroundStyle(Color.gray.opacity(0.5))
                            Text("No favorites yet")
                                .font(.title2.bold())
                                .foregroundStyle(Color.gray)
                            Text("Tap ❤️ on any dish to save it here")
                                .font(.subheadline)
                                .foregroundStyle(Color.gray.opacity(0.8))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: column10, spacing: 20) {
                                ForEach(likedItems, id: \.self) { img in
                                    let itemName = movielist[img]

                                    VStack(spacing: -10) {
                                        ZStack {
                                            Image(itemName)
                                                .resizable()
                                                .frame(minHeight: 50)
                                                .frame(maxHeight: 250)
                                                .aspectRatio(1/1, contentMode: .fill)
                                                .clipped()

                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    ZStack {
                                                        Rectangle()
                                                            .frame(width: 30, height: 30)
                                                            .foregroundStyle(Color.white)
                                                            .cornerRadius(9)

                                                        // ❤️ Un-heart from favorites
                                                        Button {
                                                            favoritesStore.toggle(itemName)
                                                        } label: {
                                                            Image(systemName: "heart.fill")
                                                                .foregroundStyle(Color.red)
                                                        }
                                                    }
                                                }
                                                .padding(.trailing, 20)
                                                Spacer()
                                            }
                                            .padding(.top, 20)
                                        }

                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .frame(height: 60)
                                                .foregroundStyle(Color.white)
                                            VStack(alignment: .leading) {
                                                Text(catogarylist[img])
                                                    .foregroundStyle(Color.black)
                                                    .font(.system(size: 18, weight: .bold))

                                                HStack(spacing: 1) {
                                                    ForEach(0..<4) { _ in
                                                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.footnote)
                                                    }
                                                    Image(systemName: "star.fill").foregroundColor(.gray).font(.footnote)
                                                }
                                                Text("$120")
                                            }
                                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                                        }
                                    }
                                    .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemPink).opacity(0.10))
            }
        }.toolbar(.hidden)
    }
}

#Preview {
    favoriteview()
        .environmentObject(FavoritesStore())
}

//import SwiftUI
//import MapKit
//import CoreLocation
//
//// MARK: - MODEL
//struct Cardnames: Identifiable {
//    var id = UUID()
//    var name: String
//    var category: String
//    var isliked: Bool
//}
//
//// MARK: - FAVORITE VIEW MODEL
//class FavoriteViewModel: ObservableObject {
//    @Published var cards: [Cardnames] = []
//
//    init() {
//        loadCards()
//    }
//
//    func loadCards() {
//        let sample = ["food1", "food2", "food3", "food4", "food5"]
//        
//        cards = sample.map {
//            Cardnames(name: $0, category: "Restaurant", isliked: false)
//        }
//    }
//
//    func toggleFavorite(id: UUID) {
//        if let index = cards.firstIndex(where: { $0.id == id }) {
//            cards[index].isliked.toggle()
//        }
//    }
//
//    var likedCards: [Cardnames] {
//        cards.filter { $0.isliked }
//    }
//}
//
//// MARK: - LOCATION MANAGER
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    
//    @Published var location: CLLocation?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        location = locations.first
//    }
//}
//
//// MARK: - RESTAURANT VIEW MODEL
//class RestaurantViewModel: ObservableObject {
//    @Published var restaurants: [MKMapItem] = []
//
//    func fetchNearby(location: CLLocation) {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = "restaurant"
//        request.region = MKCoordinateRegion(
//            center: location.coordinate,
//            latitudinalMeters: 2000,
//            longitudinalMeters: 2000
//        )
//
//        MKLocalSearch(request: request).start { response, _ in
//            DispatchQueue.main.async {
//                self.restaurants = response?.mapItems ?? []
//            }
//        }
//    }
//}
//
//// MARK: - MAIN VIEW
//struct ContentView: View {
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                
//                NavigationLink("All Restaurants 🍽️") {
//                    AllRestaurantsView()
//                }
//                
//                NavigationLink("Favorites ❤️") {
//                    FavoritesScreen()
//                }
//                
//                NavigationLink("Nearby Restaurants 📍") {
//                    NearbyRestaurantsView()
//                }
//            }
//            .navigationTitle("Food App")
//        }
//    }
//}
//
//// MARK: - ALL RESTAURANTS VIEW
//struct AllRestaurantsView: View {
//    
//    @EnvironmentObject var vm: FavoriteViewModel
//    
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: columns, spacing: 20) {
//                
//                ForEach(vm.cards) { item in
//                    
//                    VStack {
//                        ZStack(alignment: .topTrailing) {
//                            
//                            Image(item.name) // add images in Assets
//                                .resizable()
//                                .frame(height: 150)
//                                .clipped()
//                            
//                            Button {
//                                vm.toggleFavorite(id: item.id)
//                            } label: {
//                                Image(systemName: item.isliked ? "heart.fill" : "heart")
//                                    .foregroundColor(.red)
//                                    .padding(8)
//                                    .background(Color.white)
//                                    .clipShape(Circle())
//                            }
//                            .padding(8)
//                        }
//                        
//                        VStack(alignment: .leading) {
//                            Text(item.name)
//                                .font(.headline)
//                            
//                            Text(item.category)
//                                .font(.caption)
//                        }
//                        .padding()
//                        .background(Color.white)
//                    }
//                    .cornerRadius(12)
//                    .shadow(radius: 3)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Restaurants")
//    }
//}
//
//// MARK: - FAVORITES VIEW
//struct FavoritesScreen: View {
//    
//    @EnvironmentObject var vm: FavoriteViewModel
//    
//    var body: some View {
//        List(vm.likedCards) { item in
//            Text(item.name)
//        }
//        .navigationTitle("Favorites ❤️")
//    }
//}
//
//// MARK: - NEARBY VIEW
//struct NearbyRestaurantsView: View {
//    
//    @StateObject var locationManager = LocationManager()
//    @StateObject var vm = RestaurantViewModel()
//    
//    var body: some View {
//        List(vm.restaurants, id: \.self) { place in
//            
//            VStack(alignment: .leading) {
//                Text(place.name ?? "Unknown")
//                    .font(.headline)
//                
//                Text(place.placemark.title ?? "")
//                    .font(.caption)
//            }
//        }
//        .navigationTitle("Nearby 📍")
//        .onChange(of: locationManager.location) { loc in
//            if let loc = loc {
//                vm.fetchNearby(location: loc)
//            }
//        }
//    }
//}
//
//// MARK: - APP ENTRY
//@main
//struct FoodApp: App {
//    
//    @StateObject var vm = FavoriteViewModel()
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environmentObject(vm)
//        }
//    }
//}
