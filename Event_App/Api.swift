//
//  Api.swift
//  Event_App
//
//  Created by iosdev on 11/11/23.
//

import Foundation

func fetchAPIResponse<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
    let baseURL = "https://api.hel.fi/linkedevents/v1/"
    guard let url = URL(string: baseURL + endpoint) else { return }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching data: \(error)")
            completion(.failure(error))
            return
        }
        guard let data = data else {
            print("No data received")
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            print("Data received: \(result)")
            completion(.success(result))
        } catch {
            print("Error decoding data: \(error)")
            completion(.failure(error))
        }
    }
    task.resume()
}

struct EventResponse: Codable {
    let events: [Event]
}

struct Event: Identifiable, Codable {
    let id: UUID
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

