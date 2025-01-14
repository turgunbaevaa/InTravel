//
//  Destinations.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 14/1/25.
//

import Foundation

struct Destination: Codable {
    let image: String
    let name: String
    let price: String
    let description: String
    let locationIcon: String
    let locationName: String

    // Custom keys to map Firestore fields to struct properties
    enum CodingKeys: String, CodingKey {
        case image
        case name
        case price
        case description
        case locationIcon = "location_icon"
        case locationName = "location_name"
    }
}
