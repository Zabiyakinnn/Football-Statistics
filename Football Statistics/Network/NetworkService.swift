//
//  NetworkService.swift
//  Football Statistics
//
//  Created by Дмитрий Забиякин on 11.10.2024.
//

import UIKit

public final class NetworkService {
    
    static let shared = NetworkService()
    private var sport: SportsResponse?
    
    let urlString = "https://allscores.p.rapidapi.com/api/allscores/sports?timezone=America%2FChicago&langId=1&withCount=true"
    let rapidApiHost = "allscores.p.rapidapi.com"
    let rapidApiKey = "facd15fd6bmsha8735dafb377a4fp187c1fjsna639ae34d6b6"
    
    func fetchData(completion: @escaping (SportsResponse) -> Void) {
//        проверка URL
        guard let url = URL(string: urlString) else {
            print("Неверный URL")
            return
        }
//        Создаем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue(rapidApiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(rapidApiHost, forHTTPHeaderField: "x-rapidapi-host")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Ошибка при выполнении запроса \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Ошибка HTTP")
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
//            Парсим JSON данные
            do {
                let sportsResponce = try JSONDecoder().decode(SportsResponse.self, from: data)
                completion(sportsResponce)
                print(sportsResponce)
            } catch {
                print("Ошибка парсинга JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue(rapidApiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(rapidApiHost, forHTTPHeaderField: "x-rapidapi-host")
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print("Ошибка загрузки изображения \(error)")
            }
            guard let data = data else {
                print("Нет данных для изображения")
                completion(nil)
                return
            }
            if let dataString = String(data: data, encoding: .utf8) {
                print("Ответ от сервера \(dataString)")
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
    
    func fetchMatches(for sportId: Int, endDate: String, completion: @escaping (MatchesResponce?) -> Void) {
        let matchesURLString = "https://allscores.p.rapidapi.com/api/allscores/games-scores?withTop=true&timezone=America%2FChicago&sport=\(sportId)&endDate=\(endDate)"
        
        guard let url = URL(string: matchesURLString) else {
            print("Неверный URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue(rapidApiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue(rapidApiHost, forHTTPHeaderField: "x-rapidapi-host")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Ошибка при выполнении запроса \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Ошибка HTTP")
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
//            Парсим JSON данные
            do {
                let matchesResponce = try JSONDecoder().decode(MatchesResponce.self, from: data)
                completion(matchesResponce)
                print(matchesResponce)
            } catch {
                print("Ошибка парсинга JSON: \(error)")
            }
        }
        task.resume()
    }
}
