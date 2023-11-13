//
//  Api.swift
//  Event_App
//
//  Created by iosdev on 11/11/23.
//

import Foundation

func fetchEventData(completion: @escaping (Result<[Event], Error>) -> Void) {
    let urlString = "https://api.hel.fi/linkedevents/v1/event/"
    guard let url = URL(string: urlString) else { return }

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
            let response = try JSONDecoder().decode(EventResponse.self, from: data)
            print("Data received: \(response.data)")
            completion(.success(response.data))
        } catch {
            print("Error decoding data: \(error)")
            if let decodingError = error as? DecodingError {
                print(decodingError)
            }
            completion(.failure(error))
        }
    }
    task.resume()
}

struct EventResponse: Codable {
    let data: [Event]
}

struct Event: Identifiable, Codable {
    let id: String
    let name: LocalizedString
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
typealias LocalizedString = [String: String]

// Helper function to get the first available translation
extension LocalizedString {
    func nameInAnyLanguage() -> String {
        return self.values.first ?? "Unnamed Event"
    }
}

