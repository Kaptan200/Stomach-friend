import SwiftUI
import Combine

// MARK: - Sample Data
var movielist = ["food1", "food2", "food3", "food4", "food5"]
var catogarylist = ["Roti sabzi", "Fast food", "Dosa", "Veg plate", "Paneer tikka"]
var restaurantlist = ["North Indian", "Burger Hub", "South Indian", "Tau Di Chaat", "Non Veg Food"]
var restaurantimg = ["rest1", "rest2", "rest4", "rest3", "rest4"]

// MARK: - Models
struct FoodItem: Identifiable, Hashable {
    let id = UUID()
    let image: String
    let category: String
    let price: Double
}

struct RestaurantItem: Identifiable {
    let id = UUID()
    let image: String
    let name: String
    let reviews: String
}

struct CartItem: Identifiable {
    let id = UUID()
    let food: FoodItem
    var quantity: Int
}

// MARK: - Cart Store
final class CartStore: ObservableObject {
    @Published var items: [CartItem] = []

    func addToCart(_ food: FoodItem) {
        if let index = items.firstIndex(where: { $0.food.category == food.category }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(food: food, quantity: 1))
        }
    }

    func increaseQuantity(for item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity += 1
    }

    func decreaseQuantity(for item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }

        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }

    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }

    func clearCart() {
        items.removeAll()
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + ($1.food.price * Double($1.quantity)) }
    }
}
struct PlacedOrder: Identifiable {
    let id = UUID()
    let items: [CartItem]
    let totalAmount: Double
    let orderDate: Date
}

final class OrderStore: ObservableObject {
    @Published var orders: [PlacedOrder] = []

    func placeOrder(from cartItems: [CartItem], total: Double) {
        let newOrder = PlacedOrder(
            items: cartItems,
            totalAmount: total,
            orderDate: Date()
        )
        orders.insert(newOrder, at: 0)
    }
}
// MARK: - ContentView
struct ContentView: View {
    @State private var searchText: String = ""

    private var foodItems: [FoodItem] {
        zip(movielist, catogarylist).enumerated().map { index, pair in
            let prices: [Double] = [120, 150, 100, 180, 220]
            return FoodItem(
                image: pair.0,
                category: pair.1,
                price: prices[index]
            )
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
            item.category.localizedCaseInsensitiveContains(searchText) ||
            item.image.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var filteredRestaurants: [RestaurantItem] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return restaurantItems
        }

        return restaurantItems.filter { item in
            item.name.localizedCaseInsensitiveContains(searchText) ||
            item.image.localizedCaseInsensitiveContains(searchText)
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
    @EnvironmentObject var cartStore: CartStore

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

                NavigationLink {
                    CartView()
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart.fill")
                            .font(.title2)
                            .foregroundStyle(.black)

                        if cartStore.totalItems > 0 {
                            Text("\(cartStore.totalItems)")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .frame(width: 18, height: 18)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
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
    @EnvironmentObject var cartStore: CartStore
    let items: [FoodItem]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(items) { item in
                FoodCardView(item: item)
            }
        }
    }
}

// MARK: - Food Card View
struct FoodCardView: View {
    let item: FoodItem

    @EnvironmentObject var cartStore: CartStore
    @State private var rating: Int = 4
    @State private var showAddedMessage = false

    var body: some View {
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
                          Button {
                                cartStore.addToCart(item)
                                showAddedMessage = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    showAddedMessage = false
                                }
                            } label: {
                                Image(systemName: "bag.fill")
                                    .frame(width:30, height: 0)
                                    .padding()
                                    .background(Color.orange.opacity(0.8))
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .buttonStyle(.plain)
                        
                          

                      
                    }
                    .padding(.horizontal, 12)

                    Spacer()
                }
                .padding(.top, 12)
            }

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.white)
                    .frame(height: 88)

                VStack(alignment: .leading, spacing: 1) {
                    Text(item.category)
                        .foregroundStyle(.black)
                        .font(.system(size: 18, weight: .bold))
                    
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundStyle(.yellow)
                                .onTapGesture {
                                    rating = star
                                }
                        }
                    }
                    HStack{
                    Text("₹\(Int(item.price))")
                        .foregroundStyle(.black)
                        .font(.subheadline.bold())
                        Spacer()
                  
                }

                }
                .padding(.leading, 10)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Restaurant Scroll View
struct RestaurantScrollView: View {
    let items: [RestaurantItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popular Restaurants")
                    .font(.title2.bold())
                Spacer()
                NavigationLink{
                    PopularRestaurant()
                }label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                        .padding(.trailing, 16)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(items) { item in
                        RestaurantCardView(item: item)
                    }
                }
            }
        }
    }
}

struct RestaurantCardView: View {
    let item: RestaurantItem
    @State private var rating: Int = 4

    var body: some View {
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

                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundStyle(.yellow)
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

// MARK: - Cart View
struct CartView: View {
    @EnvironmentObject var cartStore: CartStore
        @EnvironmentObject var orderStore: OrderStore
        @State private var showSuccess = false

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Order Summary")
                        .font(.title2.bold())

                    ForEach(cartStore.items) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.food.category)
                                    .font(.headline)

                                Text("Qty: \(item.quantity)")
                                    .foregroundStyle(.gray)
                            }

                            Spacer()

                            Text("₹\(Int(item.food.price * Double(item.quantity)))")
                                .bold()
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    VStack(spacing: 12) {
                        HStack {
                            Text("Delivery Fee")
                            Spacer()
                            Text("₹40")
                        }

                        HStack {
                            Text("Food Total")
                            Spacer()
                            Text("₹\(Int(cartStore.totalPrice))")
                        }

                        Divider()

                        HStack {
                            Text("Grand Total")
                                .font(.headline)
                            Spacer()
                            Text("₹\(Int(cartStore.totalPrice + 40))")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    Button {
                        let finalTotal = cartStore.totalPrice + 40
                        orderStore.placeOrder(from: cartStore.items, total: finalTotal)
                        showSuccess = true
                        cartStore.clearCart()
                    } label: {
                        Text("Confirm Order")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Order")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Order placed successfully", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Your food order has been confirmed.")
            }
        }
}

// MARK: - Order View
struct OrderView: View {
    @EnvironmentObject var cartStore: CartStore
    @State private var showSuccess = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Order Summary")
                    .font(.title2.bold())

                ForEach(cartStore.items) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.food.category)
                                .font(.headline)

                            Text("Qty: \(item.quantity)")
                                .foregroundStyle(.gray)
                        }

                        Spacer()

                        Text("₹\(Int(item.food.price * Double(item.quantity)))")
                            .bold()
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                VStack(spacing: 12) {
                    HStack {
                        Text("Delivery Fee")
                        Spacer()
                        Text("₹40")
                    }

                    HStack {
                        Text("Food Total")
                        Spacer()
                        Text("₹\(Int(cartStore.totalPrice))")
                    }

                    Divider()

                    HStack {
                        Text("Grand Total")
                            .font(.headline)
                        Spacer()
                        Text("₹\(Int(cartStore.totalPrice + 40))")
                            .font(.headline)
                    }
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                Button {
                    showSuccess = true
                    cartStore.clearCart()
                } label: {
                    Text("Confirm Order")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Order")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Order placed successfully", isPresented: $showSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your food order has been confirmed.")
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(CartStore())
        .environmentObject(OrderStore())
}
