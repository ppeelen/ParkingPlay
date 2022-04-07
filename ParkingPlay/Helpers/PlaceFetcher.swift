//
//  PlaceFetcher.swift
//  ParkingPlay
//
//  Created by Paul Peelen on 2022-04-07.
//

import Foundation

enum PinFetcherErrors: Error {
    case fileNotFound
    case invalidData
}

class PlaceFetcher {
    func fetchPins() async throws -> [Place] {
        let timeToWait = Double.random(in: 1..<3)
        
        debugPrint("Waiting for \(timeToWait) seconds to simulate network request...")
        try await Task.sleep(seconds: timeToWait)

        debugPrint("Returning")
        return try getFromFile()
    }

    private func getFromFile() throws -> [Place] {
        guard
            let path = Bundle.main.path(forResource: "Pins", ofType: "json"),
            let data = FileManager.default.contents(atPath: path)
        else {
            throw PinFetcherErrors.fileNotFound
        }

        return try JSONDecoder().decode([Place].self, from: data)
    }
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
