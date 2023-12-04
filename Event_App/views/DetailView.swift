//
//  DetailView.swift
//  Event_App
//
//  Created by iosdev on 13.11.2023.
//

import SwiftUI

struct DetailView: View {
    var event: Event
    //@State private var fetchedPosition: Position? // Declare fetchedPosition as a state variable
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    DetailCardView(event: event)
                        .navigationBarTitle("Event Details", displayMode: .inline)
                }
            }
        }
    }
    //    var body: some View {
    //        VStack {
    //            if let Position = fetchedPosition {
    //                DetailCardView(event: event)
    //            } else {
    //                Text("Loading...")
    //                    .onAppear {
    //                        fetchPosition(locationID: "tprek:28473") { result in
    //                            switch result {
    //                            case .success(let position):
    //                                self.fetchedPosition = position
    //                            case .failure(let error):
    //                                print("Error: \(error)")
    //                            }
    //                        }
    //                    }
    //            }
    //        }
}

//    func fetchPosition(locationID: String, completion: @escaping (Result<Position, Error>) -> Void) {
//        let urlString = "https://api.hel.fi/linkedevents/v1/place/\(event.id)"
//
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error fetching position data: \(error)")
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                print("No data received for position")
//                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//
//                // Use conditional decoding based on the type of the root object
//                if let positionArray = try? decoder.decode([Position].self, from: data) {
//                    // Handle the case where the response is an array of positions
//                    guard let firstPosition = positionArray.first else {
//                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty position array"])
//                    }
//                    completion(.success(firstPosition))
//                } else if let position = try? decoder.decode(Position.self, from: data) {
//                    // Handle the case where the response is a single position
//                    completion(.success(position))
//                } else {
//                    // If neither array nor single object decoding succeeds, throw an error
//                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to decode position"])
//                }
//            } catch {
//                print("Error decoding position data: \(error)")
//                completion(.failure(error))
//            }
//        }
//
//        task.resume()
//    }





struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEvent = Event(
            id: "1",
            name: ["fi": "Sample Event"],
            description: ["fi": "Sample Description"],
            info_url: ["fi": "Sample Link"],
            images: []//,
            //location: EventLocation(position: Position(coordinates: [12.34, 56.78, 40.30, 12.39], type: "String"))
        )
        
        return DetailView(event: sampleEvent)
    }
}

