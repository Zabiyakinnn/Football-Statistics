//
//  SportsResponse.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 11.10.2024.
//

import Foundation

struct SportsResponse: Codable {
    let lastUpdateId: Int
    let requestedUpdateId: Int
    let sports: [Sport]
    let ttl: Int
}

struct Sport: Codable {
    let name: String
    let nameForURL: String
    let liveGames: Int
    let totalGames: Int
}
