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
    @State var places: [Place]? = nil

    private let fetcher = PlaceFetcher()

    init(places: [Place]? = nil) {
        self.places = places
    }

    // Startup with a nice view in an Stockholm area
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.34855106680632,
                                                                                  longitude: 18.11139511272728),
                                                   latitudinalMeters: 1750,
                                                   longitudinalMeters: 1750)

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: true, // Not asked for permission yet, so won't show
                annotationItems: places ?? [])
            { place in
                MapMarker(coordinate: place.location, tint: place.color)
            }
            .ignoresSafeArea()
            if places == nil {
                VStack {
                    ProgressView()
                        .aspectRatio(1, contentMode: .fill)
                    Text("Loading pins")
                        .font(.caption2)
                        .padding(.top, 10)
                }
                .padding(40)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
                .ignoresSafeArea()
            }
        }.onAppear() {
            if places == nil {
                Task.init {
                    do {
                        self.places = try await fetcher.fetchPins()
                    } catch {
                        debugPrint("Could not fetch the pins. Error: \(error)")
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let places = [
            Place(lat: 59.34855106680632, long: 18.11139511272728, color: .red, name: "One", subtitle: "One", summary: "Summary"),
            Place(lat: 59.348113487029046, long: 18.112897149803945, color: .green, name: "Two", subtitle: "Two", summary: "Summary")
        ]

        Group {
            MapView(places: places)
                .previewDisplayName("With pins")
            MapView(places: nil)
                .previewDisplayName("Loading state")
        }
    }
}
