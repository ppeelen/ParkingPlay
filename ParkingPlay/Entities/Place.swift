//
//  Place.swift
//  ParkingPlay
//
//  Created by Paul Peelen on 2022-04-05.
//

import SwiftUI
import CoreLocation

struct Place: Identifiable, Codable {
    let id: UUID
    let location: CLLocationCoordinate2D
    let color: Color

    init(id: UUID = UUID(), lat: Double, long: Double, color: Color = .pink) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
        self.color = color
    }
}
