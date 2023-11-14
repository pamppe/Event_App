//
//  Api.swift
//  Event_App
//
//  Created by iosdev on 11/11/23.
//

import Foundation

func fetchEventData(completion: @escaping (Result<[Event], Error>) -> Void) {
    let urlString = "https://api.hel.fi/linkedevents/v1/event/"
    guard let url = URL(string: urlString) else {
        return completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error fetching event data: \(error)")
            completion(.failure(error))
            return
        }
        guard let data = data else {
            print("No event data received")
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        do {
            let response = try JSONDecoder().decode(EventResponse.self, from: data)
            print("Event data received: \(response.data)")
            completion(.success(response.data))
        } catch {
            print("Error decoding event data: \(error)")
            if let decodingError = error as? DecodingError {
                print(decodingError)
            }
            completion(.failure(error))
        }
    }
    task.resume()
}

func fetchEventImage(forEvent event: Event, completion: @escaping (Result<Data, Error>) -> Void) {
    let imageURLString = "https://api.hel.fi/linkedevents/v1/image/"

    guard let imageURL = URL(string: imageURLString) else {
        return completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
    }
    let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
        if let error = error {
            print("Error fetching image data: \(error)")
            completion(.failure(error))
            return
        }
        guard let data = data else {
            print("No image data received")
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        completion(.success(data))
    }
    task.resume()
}

struct EventResponse: Codable {
    let data: [Event]
}

struct Event: Identifiable, Codable {
    let id: String
    let name: LocalizedString
    let imageURL: String?
    var imageData: Data?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
    }
}

typealias LocalizedString = [String: String]

// Helper function to get the first available translation
extension LocalizedString {
    func nameInAnyLanguage() -> String {
        return self.values.first ?? "Unnamed Event"
    }
}
