//
//  Api.swift
//  Event_App
//
//  Created by iosdev on 11/11/23.
//

import Foundation

func fetchEventData(completion: @escaping (Result<[Event], Error>) -> Void) {
    var urlString = "https://api.hel.fi/linkedevents/v1/event/"
    guard URL(string: urlString) != nil else { return }
    
    // Change HTTP to HTTPS
    if let url = URL(string: urlString), url.scheme == "http" {
        urlString = urlString.replacingOccurrences(of: "http://", with: "https://")
    }
    
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
            
        } catch {
            print("Error decoding data: \(error)")
            completion(.failure(error))
        }
        
                do {
                    let response = try JSONDecoder().decode(EventResponse.self, from: data)
                    print("Number of events fetched: \(response.data.count)")
                    print(response.data)
                    /* let response = try JSONDecoder().decode(EventResponse.self, from: data)*/
                    //print("Data received: \(response.data)")
        
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


func fetchLocation(placeID: String, completion: @escaping (Result<Place, Error>) -> Void) {
    let urlString = "https://api.hel.fi/linkedevents/v1/place/\(placeID)"
    
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        return
    }
    
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
            let place = try JSONDecoder().decode(Place.self, from: data)
            completion(.success(place))
        } catch {
            print("Error decoding data: \(error)")
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
    let description: LocalizedString
    let location: Place
    let images: [EventImage]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case location
        case images
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)

        if let firstLanguage = description.keys.first, let descriptionText = description[firstLanguage] {
            try container.encode([firstLanguage: descriptionText], forKey: .description)
        }
        try container.encode(location, forKey: .location)

    }
    // Helper function to sanitize HTML content
    func sanitizedDescription() -> String {
        guard let htmlString = description["fi"] else {
            return "No description available"
        }
        
        do {
            if let data = htmlString.data(using: .utf8) {
                let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
                return attributedString.string
            } else {
                return "Error converting HTML to plain text"
            }
        } catch {
            print("Error converting HTML to plain text: \(error)")
            return "Error loading description"
        }
    }
}


struct Place: Codable {
    let streetAddress: LocalizedString?
    let position: GeoPosition?
    
    enum CodingKeys: String, CodingKey {
        case streetAddress
        case position
    }

    init(streetAddress: LocalizedString?, position: GeoPosition?) {
        self.streetAddress = streetAddress
        self.position = position
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(position, forKey: .position)
    }
}

struct GeoPosition: Codable {
    let coordinates: [Double]
    let type: String
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

