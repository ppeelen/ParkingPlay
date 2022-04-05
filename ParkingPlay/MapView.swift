//
//  MapView.swift
//  ParkingPlay
//
//  Created by Paul Peelen on 2022-04-05.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    let places: [Place]

    // Startup with a nice view in an Stockholm area
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.34855106680632,
                                                                                  longitude: 18.11139511272728),
                                                   latitudinalMeters: 1750,
                                                   longitudinalMeters: 1750)

    var body: some View {
        Map(coordinateRegion: $region,
            showsUserLocation: true, // Not asked for permission yet, so won't show ¯\_(ツ)_/¯
            annotationItems: places)
        { place in
            MapMarker(coordinate: place.location, tint: place.color)
        }
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let places = [
            Place(lat: 59.34855106680632, long: 18.11139511272728, color: .red),
            Place(lat: 59.348113487029046, long: 18.112897149803945, color: .green),
            Place(lat: 59.34776888898539, long: 18.11162041828878, color: .gray),
            Place(lat: 59.34629200059241, long: 18.11033295795274, color: .yellow),
            Place(lat: 59.345367545169815, long: 18.10209321177299, color: .pink),
            Place(lat: 59.340861792929395, long: 18.113586787920603, color: .blue)
        ]
        MapView(places: places)
    }
}