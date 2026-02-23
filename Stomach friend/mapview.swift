//
//  mapview.swift
//  Stomach friend
//
//  Created by applelab03 on 2/22/26.
//
import SwiftUI
import MapKit


struct MapView: View {
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                Map(position: $cameraPosition) {
                    // No MapContent for now; plain map view
                }
                .ignoresSafeArea()
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: .constant(""))
                    Spacer()
                    Image(systemName: "paperplane.fill")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding()
            }
        }
        .navigationTitle("")
//        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    MapView()
}

