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
                print("Number of events fetched: \(response.data.count)")
            
           /* let response = try JSONDecoder().decode(EventResponse.self, from: data)*/
            print("Data received: \(response.data)")
            
           /* let eventsWithLanguageName = response.data.filter { $0.name["fi"] != nil}
            print("Events with Finnish name: \(eventsWithLanguageName.count)")

            let uniqueEvents = removeDuplicateEvents(events: eventsWithLanguageName)
            print("Unique events: \(uniqueEvents.count)")
            
            completion(.success(uniqueEvents))*/
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

func removeDuplicateEvents(events: [Event]) -> [Event] {
    var uniqueEvents = [Event]()
    var seenFinnishNames = Set<String>()

    for event in events {
            // Check if the event has a Finnish name
            if let finnishName = event.name["fi"] {
                // Add the event if its Finnish name hasn't been seen before
                if !seenFinnishNames.contains(finnishName) {
                    uniqueEvents.append(event)
                    seenFinnishNames.insert(finnishName)
            }
        }
    }
    return uniqueEvents
}

struct EventResponse: Codable {
    let data: [Event]
}

struct Event: Identifiable, Codable {
    let id: String
    let name: LocalizedString
    let images: [EventImage]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
    }
}

struct EventImage: Codable {
    let url: String
}

typealias LocalizedString = [String: String]

// Helper function to get the first available translation
extension LocalizedString {
    func nameInLanguage() -> String {
        return self["fi"] ?? "Unnamed Event"
    }
}

