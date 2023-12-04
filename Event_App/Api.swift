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
        
        // Print the raw JSON response for debugging
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: try JSONSerialization.jsonObject(with: data), options: .prettyPrinted)
//            let jsonString = String(data: jsonData, encoding: .utf8)
//            print("Raw JSON Response: \(jsonString ?? "Unable to convert to JSON string")")
//        } catch {
//            print("Error converting JSON data to string: \(error)")
//        }
        
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
//--------Position----------------
//func fetchEventData(completion: @escaping (Result<[Event], Error>) -> Void) {
//    let urlString = "https://api.hel.fi/linkedevents/v1/event/"
//    guard let url = URL(string: urlString) else { return }
//    
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        if let error = error {
//            print("Error fetching data: \(error)")
//            completion(.failure(error))
//            return
//        }
//        guard let data = data else {
//            print("No data received")
//            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
//            return
//        }
//        do {
//            // Print the JSON data before decoding
//            let jsonString = String(data: data, encoding: .utf8)
//            print("JSON String: \(jsonString ?? "Invalid JSON")")
//
//            let response = try JSONDecoder().decode(EventResponse.self, from: data)
//            print("Number of events fetched: \(response.data.count)")
//
//        } catch {
//            print("Error decoding data: \(error)")
//            if let decodingError = error as? DecodingError {
//                print(decodingError)
//            }
//            completion(.failure(error))
//        }
//    }
//    task.resume()
//}
//func fetchLocation(eventID: String, completion: @escaping (Result<Place, Error>) -> Void) {
//    // Implement your logic to fetch the location based on the eventID
//    // ...
//
//    // For the sake of example, let's create a dummy Place
//    let dummyPlace = Place(position:Position(coordinates: [0, 0], type: "dummy"))
//
//    // Call the completion handler with the result
//    completion(.success(dummyPlace))
//}
//struct Place: Codable, Equatable{
//    let position: Position
//
//    enum CodingKeys: String, CodingKey{
//        case position
//    }
//}
//struct Position: Codable, Equatable{
//    let coordinates: [Double]
//    let type: String
//
//    enum CodingKeys: String, CodingKey{
//        case coordinates
//        case type
//    }
//}
//struct EventLocation: Codable {
//    let position: Position
//
//    enum CodingKeys: String, CodingKey {
//        case position
//    }
//}
//struct Position: Codable {
//    let coordinates: [Double]
//    let type: String
//
//    enum CodingKeys: String, CodingKey {
//        case coordinates
//        case type
//    }
//}

//------Position end---------------
struct EventImage: Codable {
    let url: String
}

struct Event: Identifiable, Codable {
    let id: String
    let name: LocalizedString
    let description: LocalizedString
    let info_url: LocalizedString?
    let images: [EventImage]
    //let location: EventLocation
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case info_url
        case images
        //case location
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        if let firstLanguage = description.keys.first, let descriptionText = description[firstLanguage] {
            try container.encode([firstLanguage: descriptionText], forKey: .description)
        }
        try container.encode(info_url, forKey: .info_url)
        
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

typealias LocalizedString = [String: String]

// Helper function to get the first available translation
extension LocalizedString {
    func nameInLanguage() -> String {
        return self["fi"] ?? "Unnamed Event"
    }
}


