import SwiftUI
import UserNotifications
import Combine

// MARK: - SAMPLE DATA
struct RestaurantData {
    static let images = ["food1", "food2", "food3", "food4"]
    static let names = ["Dominos", "KFC", "Pizza Hut", "Burger King"]
}

// MARK: - MODEL
struct Reservation: Identifiable, Codable {
    var id = UUID()
    let restaurantName: String
    let date: Date
}

// MARK: - RESERVATION MANAGER
class ReservationManager: ObservableObject {
    
    @Published var reservations: [Reservation] = []
    
    init() {
        load()
    }
    
    func addReservation(_ reservation: Reservation) {
        reservations.append(reservation)
        save()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(reservations) {
            UserDefaults.standard.set(data, forKey: "reservations")
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: "reservations"),
           let decoded = try? JSONDecoder().decode([Reservation].self, from: data) {
            reservations = decoded
        }
    }
}

// MARK: - NOTIFICATION MANAGER
class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            print("Permission:", granted)
        }
    }
    
    func scheduleNotification(for reservation: Reservation) {
        
        let content = UNMutableNotificationContent()
        content.title = "Table Reservation 🍽️"
        content.body = "Reminder for \(reservation.restaurantName)"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reservation.date
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - RESERVATION SCREEN
struct ReservationView: View {
    
    let restaurantName: String
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var manager = ReservationManager()
    
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Reserve Table at \(restaurantName)")
                .font(.title2)
                .bold()
            
            DatePicker("Select Date & Time", selection: $selectedDate)
                .padding()
            
            Button("Confirm Reservation") {
                
                let reservation = Reservation(
                    restaurantName: restaurantName,
                    date: selectedDate
                )
                
                manager.addReservation(reservation)
                NotificationManager.shared.scheduleNotification(for: reservation)
                
                dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .onAppear {
            NotificationManager.shared.requestPermission()
        }
    }
}

// MARK: - RESERVATION LIST
struct ReservationListView: View {
    
    @StateObject var manager = ReservationManager()
    
    var body: some View {
        List(manager.reservations) { res in
            VStack(alignment: .leading) {
                Text(res.restaurantName)
                    .font(.headline)
                
                Text(res.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
            }
        }
        .navigationTitle("My Reservations")
    }
}

// MARK: - POPULAR RESTAURANTS
struct PopularRestaurant: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                // 🌈 BACKGROUND
                LinearGradient(
                    colors: [.blue.opacity(0.3), .pink.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    
                    // HEADER
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .bold()
                        }
                        Spacer()
                        
                        Text("Popular Restaurants")
                            .font(.title2.bold())
                        
                        Spacer()
                        
                        NavigationLink("My Bookings") {
                            ReservationListView()
                        }
                    }
                    .padding()
                    
                    // GRID
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            
                            ForEach(restaurantimg.indices, id: \.self) { index in
                                
                                NavigationLink {
                                    ReservationView(
                                        restaurantName: restaurantlist[index]
                                    )
                                } label: {
                                    
                                    VStack(spacing: 0) {
                                        
                                        Image(restaurantimg[index])
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fill)
                                            .frame(height: 120)
                                            .clipped()
                                        
                                        VStack(alignment: .leading) {
                                            Text(restaurantlist[index])
                                                .font(.headline)
                                            
                                            HStack(spacing: 2) {
                                                ForEach(0..<4) { _ in
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(.yellow)
                                                        .font(.footnote)
                                                }
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.gray)
                                                    .font(.footnote)
                                            }
                                            
                                            Text("4.5 Reviews")
                                                .font(.caption)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white)
                                    }
                                    .cornerRadius(15)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
        }.toolbar(.hidden)
    }
}


#Preview{
    PopularRestaurant()
}
