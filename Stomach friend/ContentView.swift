import SwiftUI
import Combine

// MARK: - Sample Data
var movielist    = ["food1", "food2", "food3", "food4", "food5"]
var catogarylist = ["Roti sabzi", "Fast food", "Dosa", "Veg plate", "Paneer tikka"]
var restaurantlist = ["North Indian", "Burger Hub", "South Indian", "Tau Di Chaat", "Non Veg Food"]
var restaurantimg  = ["rest1", "rest2", "rest4", "rest3", "rest4"]

// MARK: - Favorites Store
final class FavoritesStore2: ObservableObject {
    @Published var likedItems: [String] = []

    func toggle(_ item: String) {
        if isLiked(item) {
            likedItems.removeAll { $0 == item }
        } else {
            likedItems.append(item)
        }
    }

    func isLiked(_ item: String) -> Bool {
        likedItems.contains(item)
    }
}

// MARK: - Models
struct FoodItem: Identifiable {
    let id = UUID()
    let image: String
    let category: String
    let price: String
}

struct RestaurantItem: Identifiable {
    let id = UUID()
    let image: String
    let name: String
    let reviews: String
}

// MARK: - ContentView
struct ContentView: View {
    @State private var searchText: String = ""

    private var foodItems: [FoodItem] {
        zip(movielist, catogarylist).map {
            FoodItem(image: $0.0, category: $0.1, price: "$120")
        }
    }

    private var restaurantItems: [RestaurantItem] {
        zip(restaurantimg, restaurantlist).map {
            RestaurantItem(image: $0.0, name: $0.1, reviews: "4.5M Reviews")
        }
    }

    private var filteredFoods: [FoodItem] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return foodItems
        }

        return foodItems.filter { item in
            item.category.localizedCaseInsensitiveContains(searchText)
            || item.image.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var filteredRestaurants: [RestaurantItem] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return restaurantItems
        }

        return restaurantItems.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText)
            || item.image.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .pink.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        TopHeaderView(searchText: $searchText)

                        if !searchText.isEmpty && filteredFoods.isEmpty && filteredRestaurants.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "magnifyingglass.circle")
                                    .font(.system(size: 45))
                                    .foregroundStyle(.gray)

                                Text("No food or restaurant found")
                                    .font(.headline)

                                Text("Try searching something else")
                                    .foregroundStyle(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                        } else {
                            FoodGridView(items: filteredFoods)
                            RestaurantScrollView(items: filteredRestaurants)
                        }
                    }
                    .padding(10)
                }
            }
            .toolbar(.hidden)
        }
    }
}

// MARK: - Top Header View
struct TopHeaderView: View {
    @Binding var searchText: String

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hi, Kaptan")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Find the best food around you")
                        .font(.caption.bold())
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: "magnifyingglass")
                    .font(.title3)
            }
            .padding(.horizontal)

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)

                TextField("Search food or restaurant", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.65))
            .cornerRadius(12)
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - Food Grid View
struct FoodGridView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore

    let items: [FoodItem]
    @State private var rating: Int = 0
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(items) { item in
                VStack(spacing: -10) {
                    ZStack {
                        Image(item.image)
                            .resizable()
                            .frame(height: 180)
                            .frame(maxWidth: 180)
                            .aspectRatio(contentMode: .fill)
                            .clipped()

                        VStack {
                            HStack {
                                Spacer()

                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white)
                                        .frame(width: 34, height: 34)

                                    Button {
                                        favoritesStore.toggle(item.image)
                                    } label: {
                                        Image(systemName: favoritesStore.isLiked(item.image) ? "heart.fill" : "heart")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                            .padding(.trailing, 12)

                            Spacer()
                        }
                        .padding(.top, 12)
                    }

                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(.white)
                            .frame(height: 70)

                        VStack(alignment: .leading, spacing: 1) {
                            Text(item.category)
                                .foregroundStyle(.black)
                                .font(.system(size: 18, weight: .bold))

                            HStack{
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .onTapGesture {
                                            rating = star
                                        }
                                    
                                }
                            }
                            Text(item.price)
                                .foregroundStyle(.black)
                        }
                        .padding(.leading, 10)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}

// MARK: - Restaurant Scroll View
struct RestaurantScrollView: View {
    @State private var rating: Int = 0
    let items: [RestaurantItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popular Restaurants")
                    .font(.title2.bold())

                Spacer()

                NavigationLink {
                    PopularRestaurant()
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(items) { item in
                        VStack(spacing: -10) {
                            Image(item.image)
                                .resizable()
                                .frame(width: 200, height: 150)
                                .aspectRatio(contentMode: .fill)
                                .clipped()

                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(.black.opacity(0.08))
                                    .frame(width: 200, height: 85)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .foregroundStyle(.black)
                                        .font(.system(size: 15, weight: .bold))

                                    HStack{
                                        ForEach(1...5, id: \.self) { star in
                                            Image(systemName: star <= rating ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                                .onTapGesture {
                                                    rating = star
                                                }
                                            
                                        }
                                    }

                                    Text(item.reviews)
                                        .font(.caption)
                                        .foregroundStyle(.black.opacity(0.7))
                                }
                                .padding(.leading, 10)
                            }
                        }
                        .frame(width: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
        }
    }
}



// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(FavoritesStore())
}
