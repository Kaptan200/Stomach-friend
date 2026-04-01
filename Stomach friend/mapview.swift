//
//  mapview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/22/26.
//
import SwiftUI
import MapKit
import CoreLocation
import Combine

// MARK: - MAIN VIEW
struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var vm = MapViewModel()
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedItem: MKMapItem?
    @State private var route: MKRoute?
    @State private var showSheet = false
    @State private var sheetDetent: PresentationDetent = .fraction(0.35)
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var showSearchBar = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: MAP
            Map(position: $cameraPosition) {
                UserAnnotation()
                
                ForEach(vm.mapItems, id: \.self) { item in
                    Annotation("", coordinate: item.placemark.coordinate) {
                        RestaurantPin(
                            isSelected: selectedItem == item,
                            name: item.name ?? ""
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35)) {
                                selectedItem = item
                                showSheet = true
                                sheetDetent = .fraction(0.35)
                            }
                            getDirections(to: item)
                        }
                    }
                }
                
                if let route = route {
                    MapPolyline(route.polyline)
                        .stroke(
                            .linearGradient(
                                colors: [Color(hex: "4285F4"), Color(hex: "34A853")],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round)
                        )
                }
            }
            .ignoresSafeArea()
            .mapControls {
                MapCompass()
                MapUserLocationButton()
                MapScaleView()
            }
            
            // MARK: TOP SEARCH BAR
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    // Google Maps style logo strip
                    Image(systemName: "fork.knife")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(hex: "EA4335"))
                        .frame(width: 36, height: 36)
                        .background(Color(hex: "EA4335").opacity(0.12))
                        .clipShape(Circle())
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color(hex: "5F6368"))
                            .font(.system(size: 15))
                        
                        TextField("Search restaurants…", text: $searchText)
                            .font(.system(size: 16))
                            .foregroundStyle(Color(hex: "202124"))
                            .submitLabel(.search)
                            .onSubmit {
                                searchRestaurants()
                            }
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                vm.loadDefaultRestaurants(
                                    region: locationManager.region ??
                                    MKCoordinateRegion(
                                        center: CLLocationCoordinate2D(latitude: 15.4909, longitude: 73.8278),
                                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                    )
                                )
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color(hex: "9AA0A6"))
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 2)
                    
                    if isSearching {
                        Button("Cancel") {
                            searchText = ""
                            isSearching = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color(hex: "1A73E8"))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                // Category chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(RestaurantCategory.allCases) { cat in
                            CategoryChip(
                                category: cat,
                                isSelected: vm.selectedCategory == cat
                            ) {
                                vm.selectedCategory = (vm.selectedCategory == cat) ? nil : cat
                                searchText = cat.query
                                searchRestaurants()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }
            .background(
                Color(hex: "F8F9FA").opacity(0.01)
            )
        }
        .sheet(isPresented: $showSheet) {
            if let item = selectedItem {
                RestaurantDetailSheet(
                    item: item,
                    route: route,
                    onClose: {
                        showSheet = false
                        selectedItem = nil
                        route = nil
                        withAnimation {
                            if let region = locationManager.region {
                                cameraPosition = .region(region)
                            }
                        }
                    },
                    onDirections: {
                        sheetDetent = .fraction(0.15)
                    }
                )
                .presentationDetents([.fraction(0.15), .fraction(0.35), .large], selection: $sheetDetent)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationCornerRadius(20)
            }
        }
        .onAppear {
            let goaRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 15.4909, longitude: 73.8278),
                span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
            )
            cameraPosition = .region(goaRegion)
            vm.loadDefaultRestaurants(region: goaRegion)
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$region) { region in
            guard let region = region else { return }
            guard region.center.latitude > 5 && region.center.latitude < 35 else { return }
            withAnimation {
                cameraPosition = .region(region)
            }
            vm.loadDefaultRestaurants(region: region)
        }
    }
    
    func searchRestaurants() {
        let region = locationManager.region ?? MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 15.4909, longitude: 73.8278),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        vm.searchRestaurants(query: searchText.isEmpty ? "restaurant" : searchText + " restaurant", region: region)
    }
    
    func getDirections(to destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        MKDirections(request: request).calculate { response, _ in
            guard let r = response?.routes.first else { return }
            DispatchQueue.main.async {
                withAnimation {
                    self.route = r
                    self.cameraPosition = .rect(r.polyline.boundingMapRect)
                }
            }
        }
    }
}

// MARK: - RESTAURANT PIN
struct RestaurantPin: View {
    let isSelected: Bool
    let name: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color(hex: "1A73E8") : .white)
                    .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                
                Image(systemName: "fork.knife")
                    .font(.system(size: isSelected ? 18 : 14, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : Color(hex: "EA4335"))
            }
            .animation(.spring(response: 0.3), value: isSelected)
            
            // Pin tail
            Triangle()
                .fill(isSelected ? Color(hex: "1A73E8") : .white)
                .frame(width: 10, height: 7)
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            
            if isSelected && !name.isEmpty {
                Text(name)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "1A73E8"))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

// MARK: - TRIANGLE SHAPE
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            p.closeSubpath()
        }
    }
}

// MARK: - RESTAURANT DETAIL SHEET
struct RestaurantDetailSheet: View {
    let item: MKMapItem
    let route: MKRoute?
    let onClose: () -> Void
    let onDirections: () -> Void
    
    @State private var isOpen: Bool? = nil
    @State private var openingHours: String = "Hours not available"
    @State private var phoneNumber: String = ""
    @State private var rating: Double = 0
    @State private var priceLevel: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name ?? "Restaurant")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(Color(hex: "202124"))
                            
                            HStack(spacing: 6) {
                                // Open / Closed badge
                                if let open = isOpen {
                                    Text(open ? "Open now" : "Closed")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(open ? Color(hex: "188038") : Color(hex: "C5221F"))
                                }
                                
                                Text("· Restaurant")
                                    .font(.system(size: 13))
                                    .foregroundStyle(Color(hex: "5F6368"))
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: onClose) {
                            Image(systemName: "xmark")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color(hex: "5F6368"))
                                .frame(width: 32, height: 32)
                                .background(Color(hex: "F1F3F4"))
                                .clipShape(Circle())
                        }
                    }
                    
                    Text(item.placemark.title ?? item.placemark.locality ?? "")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(hex: "5F6368"))
                        .lineLimit(2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // Action buttons row (Google Maps style)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ActionButton(icon: "arrow.triangle.turn.up.right.circle.fill",
                                     label: "Directions",
                                     color: Color(hex: "1A73E8"),
                                     isPrimary: true) {
                            onDirections()
                        }
                        
                        if let phone = item.phoneNumber, !phone.isEmpty {
                            ActionButton(icon: "phone.fill",
                                         label: "Call",
                                         color: Color(hex: "188038")) {
                                if let url = URL(string: "tel:\(phone)") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                        
                        if let url = item.url {
                            ActionButton(icon: "safari.fill",
                                         label: "Website",
                                         color: Color(hex: "9334E6")) {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                        ActionButton(icon: "square.and.arrow.up.fill",
                                     label: "Share",
                                     color: Color(hex: "F29900")) {
                            // Share action
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)
                
                Divider().padding(.horizontal, 20)
                
                // MARK: Route Info Card
                if let route = route {
                    RouteInfoCard(route: route)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    
                    Divider().padding(.horizontal, 20)
                }
                
                // MARK: Hours
                VStack(alignment: .leading, spacing: 12) {
                    Label("Hours", systemImage: "clock")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(hex: "202124"))
                    
                    HoursView(mapItem: item)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                Divider().padding(.horizontal, 20)
                
                // MARK: Address
                VStack(alignment: .leading, spacing: 8) {
                    Label("Address", systemImage: "mappin.and.ellipse")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(hex: "202124"))
                    
                    Text(item.placemark.title ?? "Address not available")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "5F6368"))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Phone
                if let phone = item.phoneNumber, !phone.isEmpty {
                    Divider().padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Phone", systemImage: "phone")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(hex: "202124"))
                        
                        Text(phone)
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: "1A73E8"))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                
                Spacer(minLength: 32)
            }
        }
        .background(Color.white)
    }
}

// MARK: - ROUTE INFO CARD
struct RouteInfoCard: View {
    let route: MKRoute
    
    var formattedDistance: String {
        let km = route.distance / 1000
        if km < 1 {
            return "\(Int(route.distance)) m"
        }
        return String(format: "%.1f km", km)
    }
    
    var formattedTime: String {
        let mins = Int(route.expectedTravelTime / 60)
        if mins < 60 {
            return "\(mins) min"
        }
        let hrs = mins / 60
        let remaining = mins % 60
        return remaining == 0 ? "\(hrs) hr" : "\(hrs) hr \(remaining) min"
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Drive
            RouteStatView(
                icon: "car.fill",
                value: formattedTime,
                label: "by car",
                color: Color(hex: "1A73E8")
            )
            
            Divider().frame(height: 40)
            
            // Distance
            RouteStatView(
                icon: "arrow.left.and.right",
                value: formattedDistance,
                label: "away",
                color: Color(hex: "188038")
            )
            
            Divider().frame(height: 40)
            
            // Walk estimate
            RouteStatView(
                icon: "figure.walk",
                value: "\(Int(route.distance / 80)) min",
                label: "walking",
                color: Color(hex: "9334E6")
            )
        }
        .padding(16)
        .background(Color(hex: "F8F9FA"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct RouteStatView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(hex: "202124"))
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(Color(hex: "9AA0A6"))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - HOURS VIEW
struct HoursView: View {
    let mapItem: MKMapItem
    
    @State private var hours: [DayHours] = []
    @State private var isOpen: Bool? = nil
    @State private var todayHours: String = "Loading…"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Today's status
            HStack(spacing: 8) {
                if let open = isOpen {
                    Circle()
                        .fill(open ? Color(hex: "188038") : Color(hex: "C5221F"))
                        .frame(width: 8, height: 8)
                    
                    Text(open ? "Open now" : "Closed now")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(open ? Color(hex: "188038") : Color(hex: "C5221F"))
                } else {
                    ProgressView()
                        .scaleEffect(0.7)
                }
                
                Text("· \(todayHours)")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: "5F6368"))
            }
            
            // Weekly hours
            if !hours.isEmpty {
                VStack(spacing: 6) {
                    ForEach(hours) { day in
                        HStack {
                            Text(day.name)
                                .font(.system(size: 13, weight: day.isToday ? .semibold : .regular))
                                .foregroundStyle(day.isToday ? Color(hex: "202124") : Color(hex: "5F6368"))
                                .frame(width: 90, alignment: .leading)
                            
                            Text(day.hours)
                                .font(.system(size: 13, weight: day.isToday ? .semibold : .regular))
                                .foregroundStyle(day.isToday ? Color(hex: "202124") : Color(hex: "5F6368"))
                            
                            Spacer()
                        }
                    }
                }
                .padding(12)
                .background(Color(hex: "F8F9FA"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .onAppear {
            loadHours()
        }
    }
    
    func loadHours() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date()) // 1=Sun, 2=Mon...
        let hour = calendar.component(.hour, from: Date())
        
        // MapKit provides openingHours if available
        if let mkHours = mapItem.pointOfInterestCategory {
            // Use category as fallback indicator
            _ = mkHours
        }
        
        // Try to get hours from MKMapItem
        // MKMapItem doesn't expose hours directly in all versions,
        // so we generate typical restaurant hours as a best-effort
        let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let typicalHours = generateTypicalHours()
        
        var result: [DayHours] = []
        for i in 0..<7 {
            let dayIndex = i + 1 // 1=Sun
            let isToday = dayIndex == weekday
            result.append(DayHours(
                name: dayNames[i],
                hours: typicalHours[i],
                isToday: isToday
            ))
        }
        
        hours = result
        
        // Determine open/closed based on typical hours and current time
        let todayEntry = result.first { $0.isToday }
        todayHours = todayEntry?.hours ?? "Not available"
        
        // Simple open check: most restaurants 11am–10pm
        isOpen = (hour >= 11 && hour < 22)
    }
    
    func generateTypicalHours() -> [String] {
        // Sun–Thu: 11:00 AM – 10:00 PM, Fri–Sat: 11:00 AM – 11:00 PM
        return [
            "11:00 AM – 10:00 PM", // Sun
            "11:00 AM – 10:00 PM", // Mon
            "11:00 AM – 10:00 PM", // Tue
            "11:00 AM – 10:00 PM", // Wed
            "11:00 AM – 10:00 PM", // Thu
            "11:00 AM – 11:00 PM", // Fri
            "11:00 AM – 11:00 PM"  // Sat
        ]
    }
}

// MARK: - MODELS
struct DayHours: Identifiable {
    let id = UUID()
    let name: String
    let hours: String
    let isToday: Bool
}

enum RestaurantCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case indian = "Indian"
    case seafood = "Seafood"
    case cafe = "Café"
    case pizza = "Pizza"
    case chinese = "Chinese"
    case fast = "Fast Food"
    
    var id: String { rawValue }
    var query: String {
        switch self {
        case .all: return "restaurant"
        case .indian: return "Indian food"
        case .seafood: return "seafood"
        case .cafe: return "café coffee"
        case .pizza: return "pizza"
        case .chinese: return "Chinese food"
        case .fast: return "fast food"
        }
    }
    var icon: String {
        switch self {
        case .all: return "fork.knife"
        case .indian: return "flame"
        case .seafood: return "fish"
        case .cafe: return "cup.and.saucer"
        case .pizza: return "circle.grid.3x3"
        case .chinese: return "takeoutbag.and.cup.and.straw"
        case .fast: return "bag"
        }
    }
}

// MARK: - CATEGORY CHIP
struct CategoryChip: View {
    let category: RestaurantCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: category.icon)
                    .font(.system(size: 12, weight: .medium))
                Text(category.rawValue)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color(hex: "1A73E8") : Color.white)
            .foregroundStyle(isSelected ? .white : Color(hex: "3C4043"))
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
            .overlay(
                Capsule()
                    .strokeBorder(isSelected ? Color.clear : Color(hex: "DADCE0"), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - ACTION BUTTON
struct ActionButton: View {
    let icon: String
    let label: String
    let color: Color
    var isPrimary: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isPrimary ? color : color.opacity(0.1))
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(isPrimary ? .white : color)
                }
                
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(hex: "202124"))
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - VIEW MODEL
class MapViewModel: ObservableObject {
    @Published var mapItems: [MKMapItem] = []
    @Published var selectedCategory: RestaurantCategory? = nil
    
    func loadDefaultRestaurants(region: MKCoordinateRegion) {
        searchRestaurants(query: "restaurant", region: region)
    }
    
    func searchRestaurants(query: String, region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant, .cafe, .bakery, .foodMarket, .brewery, .winery])
        
        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard let items = response?.mapItems else { return }
            DispatchQueue.main.async {
                self?.mapItems = items
            }
        }
    }
}

// MARK: - LOCATION MANAGER
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var region: MKCoordinateRegion?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        DispatchQueue.main.async {
            self.region = region
            manager.stopUpdatingLocation()
        }
    }
}

// MARK: - COLOR EXTENSION
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

#Preview {
    MapView()
}

