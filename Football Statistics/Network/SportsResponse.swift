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

//виды спорта
struct Sport: Codable {
    let id: Int
    let name: String
    let nameForURL: String
    let liveGames: Int
    let totalGames: Int
    var imageSystemName: String?
}

struct MatchesResponce: Codable {
    let countries: [Country]
    let competitions: [Competition]
}

//страны
struct Country: Codable {
    let id: Int
    let name: String
    let totalGames: Int?
    let liveGames: Int?
    let nameForURL: String
}

//соревнования
struct Competition: Codable {
    let id: Int
    let countryId: Int
    let sportId: Int
    let name: String
    let totalGames: Int?
    let liveGames: Int?
    var imageURL: URL? {
        return URL(string: "https://allscores.p.rapidapi.com/api/allscores/img/large/competitor/\(id)/version/1")
    }
}
