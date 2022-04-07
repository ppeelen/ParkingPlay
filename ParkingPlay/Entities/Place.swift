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
    let name: String
    let subtitle: String
    let summary: String

    init(id: UUID = UUID(), lat: Double, long: Double, color: Color = .pink, name: String, subtitle: String, summary: String) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
        self.color = color
        self.name = name
        self.subtitle = subtitle
        self.summary = summary
    }
}
