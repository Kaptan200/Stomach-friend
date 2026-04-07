import SwiftUI
import Combine
import UserNotifications

// MARK: - SAMPLE DATA
//let restaurantimg = ["food1", "food2", "food3", "food4"]
//let restaurantlist = ["Dominos", "KFC", "Pizza Hut", "Burger King"]

// MARK: - SEAT MODEL
struct Seat: Identifiable, Codable {
    let id: Int
    var isBooked: Bool
}

// MARK: - RESERVATION MODEL
struct Reservation: Identifiable, Codable {
    var id = UUID()
    
    let restaurantName: String
    let customerName: String
    let phoneNumber: String
    
    let startTime: Date
    let endTime: Date
    
    let selectedSeats: [Int]
}

// MARK: - RESERVATION MANAGER
class ReservationManager: ObservableObject {
    
    @Published var reservations: [Reservation] = []
    
    init() {
        load()
        removeExpiredReservations()
        
        // Auto cleanup every minute
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.removeExpiredReservations()
        }
    }
    
    func addReservation(_ reservation: Reservation) {
        reservations.append(reservation)
        save()
    }
    
    func removeExpiredReservations() {
        let now = Date()
        reservations.removeAll { $0.endTime < now }
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

// MARK: - SEAT MANAGER (LIVE)
class SeatManager: ObservableObject {
    
    @Published var seats: [Seat] = []
    
    init() {
        generateSeats()
    }
    
    func generateSeats() {
        seats = (1...20).map { Seat(id: $0, isBooked: false) }
    }
    
    func bookSeats(_ selected: [Int]) {
        for index in seats.indices {
            if selected.contains(seats[index].id) {
                seats[index].isBooked = true
            }
        }
    }
}

// MARK: - NOTIFICATION
class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    func scheduleNotification(for reservation: Reservation) {
        
        let content = UNMutableNotificationContent()
        content.title = "Table Reservation 🍽️"
        content.body = "Reminder for \(reservation.restaurantName)"
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reservation.startTime
        )
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - SEAT UI
struct SeatSelectionView: View {
    
    @ObservedObject var seatManager: SeatManager
    @Binding var selectedSeats: Set<Int>
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Select Seats 🪑")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 15) {
                
                ForEach(seatManager.seats) { seat in
                    
                    let isSelected = selectedSeats.contains(seat.id)
                    
                    Text("\(seat.id)")
                        .frame(width: 50, height: 50)
                        .background(
                            seat.isBooked ? Color.red :
                            isSelected ? Color.blue :
                            Color.green
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .onTapGesture {
                            if !seat.isBooked {
                                if isSelected {
                                    selectedSeats.remove(seat.id)
                                } else {
                                    selectedSeats.insert(seat.id)
                                }
                            }
                        }
                }
            }
        }
    }
}

// MARK: - RESERVATION SCREEN
struct ReservationView: View {
    
    let restaurantName: String
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var manager = ReservationManager()
    @StateObject var seatManager = SeatManager()
    
    @State private var name = ""
    @State private var phone = ""
    
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    
    @State private var selectedSeats: Set<Int> = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("Reserve at \(restaurantName)")
                    .font(.title2.bold())
                
                TextField("Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                TextField("Phone", text: $phone)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                DatePicker("Start Time", selection: $startTime)
                DatePicker("End Time", selection: $endTime)
                
                SeatSelectionView(
                    seatManager: seatManager,
                    selectedSeats: $selectedSeats
                )
                
                Button("Confirm Reservation") {
                    
                    guard !selectedSeats.isEmpty else { return }
                    
                    let reservation = Reservation(
                        restaurantName: restaurantName,
                        customerName: name,
                        phoneNumber: phone,
                        startTime: startTime,
                        endTime: endTime,
                        selectedSeats: Array(selectedSeats)
                    )
                    
                    manager.addReservation(reservation)
                    seatManager.bookSeats(Array(selectedSeats))
                    
                    NotificationManager.shared.scheduleNotification(for: reservation)
                    
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
        }
    }
}

// MARK: - LIST VIEW
struct ReservationListView: View {
    
    @StateObject var manager = ReservationManager()
    
    var body: some View {
        List(manager.reservations) { res in
            VStack(alignment: .leading) {
                
                Text(res.restaurantName)
                    .font(.headline)
                
                Text("👤 \(res.customerName)")
                Text("📞 \(res.phoneNumber)")
                
                Text("Start: \(res.startTime.formatted(date: .abbreviated, time: .shortened))")
                Text("End: \(res.endTime.formatted(date: .abbreviated, time: .shortened))")
                
                Text("Seats: \(res.selectedSeats.map { String($0) }.joined(separator: ", "))")
                    .font(.caption)
            }
        }
        .navigationTitle("My Reservations")
        .onAppear {
            manager.removeExpiredReservations()
        }
    }
}

// MARK: - MAIN SCREEN
struct PopularRestaurant: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.3), .pink.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    
                    HStack {
                        Spacer()
                        Text("Restaurants")
                            .font(.title2.bold())
                        Spacer()
                        
                        NavigationLink("Bookings") {
                            ReservationListView()
                        }
                    }
                    .padding()
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            
                            ForEach(restaurantimg.indices, id: \.self) { i in
                                
                                NavigationLink {
                                    ReservationView(
                                        restaurantName: restaurantlist[i]
                                    )
                                } label: {
                                    
                                    VStack {
                                        Image(restaurantimg[i])
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fill)
                                            .frame(height: 120)
                                            .clipped()
                                        VStack {
                                            Text(restaurantlist[i])
                                                .foregroundStyle(Color.black)
                                                .font(.system(size: 17, weight: .bold))
                                                .padding(EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: 0))
                                            HStack {
                                                ForEach(0..<4) { _ in
                                                    Image(systemName: "star.fill").foregroundColor(.yellow)
                                                }
                                            }
//                                            .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                                            Text("4.5M Reviews")
//                                                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                                        }.padding(EdgeInsets(top: 0, leading: -55, bottom: 0, trailing: 0))
                                    }
                                    .background(Color.white)
                                    .cornerRadius(12)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

// MARK: - PREVIEW
#Preview {
    PopularRestaurant()
}
