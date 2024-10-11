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
    
    func fetchData() {
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
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let sportsResponce = try JSONDecoder().decode(SportsResponse.self, from: data)
                    self.sport = sportsResponce
                    print("\(sportsResponce.sports)")
                }
            } catch {
                print("Ошибка парсинга JSON: \(error)")
            }
        }
        task.resume()
    }
}
