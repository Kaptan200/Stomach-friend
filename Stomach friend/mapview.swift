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

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    // ✅ Default Goa Location
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 15.4909, longitude: 73.8278),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    @State private var searchText = ""
    @State private var mapItems: [MKMapItem] = []
    @State private var selectedItem: MKMapItem?
    @State private var route: MKRoute?
    
    var body: some View {
        ZStack {
            
            // MARK: - MAP
            Map(position: $cameraPosition) {
                
                UserAnnotation()
                
                // 📍 Markers
                ForEach(mapItems, id: \.self) { item in
                    Annotation(item.name ?? "Place",
                               coordinate: item.placemark.coordinate) {
                        
                        Button {
                            selectedItem = item
                            getDirections(to: item)
                        } label: {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                // 🚗 Route
                if let route = route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            .ignoresSafeArea()
            
            // MARK: - SEARCH BAR
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("Search (pizza, cafe...)", text: $searchText)
                        .onSubmit { searchPlaces() }
                    
                    Spacer()
                    
                    Button {
                        searchPlaces()
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding()
                
                Spacer()
            }
            
            // MARK: - BOTTOM SHEET
            if let item = selectedItem {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        
                        Text(item.name ?? "Restaurant")
                            .font(.headline)
                        
                        Text(item.placemark.title ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if let route = route {
                            Text("Distance: \(route.distance / 1000, specifier: "%.2f") km")
                            Text("ETA: \(route.expectedTravelTime / 60, specifier: "%.0f") min")
                        }
                        
                        Button("Close") {
                            selectedItem = nil
                            route = nil
                        }
                        .padding(.top)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding()
                }
            }
        }
        .onAppear {
            // 🔥 Load Goa restaurants by default
            let goaRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 15.4909, longitude: 73.8278),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            
            cameraPosition = .region(goaRegion)
            searchNearbyRestaurants(region: goaRegion)
            
            // Optional: enable live location
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$region) { region in
            guard let region = region else { return }
            cameraPosition = .region(region)
            searchNearbyRestaurants(region: region)
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
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05,
                                   longitudeDelta: 0.05)
        )
        
        DispatchQueue.main.async {
            self.region = region
            manager.stopUpdatingLocation()
        }
    }
}

// MARK: - FUNCTIONS
extension MapView {
    
    // 📍 Goa + Nearby Restaurants
    func searchNearbyRestaurants(region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        request.region = region
        
        MKLocalSearch(request: request).start { response, _ in
            guard let items = response?.mapItems else { return }
            
            DispatchQueue.main.async {
                self.mapItems = items
            }
        }
    }
    
    // 🔎 Search (Goa focused)
    func searchPlaces() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        request.region = locationManager.region ?? MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 15.4909, longitude: 73.8278),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        MKLocalSearch(request: request).start { response, _ in
            guard let items = response?.mapItems else { return }
            
            DispatchQueue.main.async {
                self.mapItems = items
                self.route = nil
            }
        }
    }
    
    // 🚗 Route
    func getDirections(to destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        MKDirections(request: request).calculate { response, _ in
            guard let route = response?.routes.first else { return }
            
            DispatchQueue.main.async {
                self.route = route
                self.cameraPosition = .rect(route.polyline.boundingMapRect)
            }
        }
    }
}
#Preview {
    MapView()
}

