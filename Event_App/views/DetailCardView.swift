//
//  DetailCardView.swift
//  Event_App
//
//  Created by iosdev on 18.11.2023.
//

import SwiftUI

struct DetailCardView: View {
    var event: Event
    var body: some View {
        VStack {
            List {
                ForEach(event.images, id: \.url) { image in
                    if let imageUrl = event.images.first?.url,
                       let encodedUrlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                       let url = URL(string: encodedUrlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure:
                                Text("Image not available") // Display a text view in case of failure
                            @unknown default:
                                EmptyView() // Fallback to an empty view for any unknown case
                            }
                        }
                        .frame(height: 200)
                    }
                }
                Text("Event Name: \(event.name.nameInLanguage())")
                Text("Event ID: \(event.id)")
                Text("Description: \(event.sanitizedDescription())")
                Text("Link to Event \(event.info_url?.nameInLanguage() ?? "N/A")")                
                // Display location information
//                Section(header: Text("Location")) {
//                    if event.id == event.id {
//                        VStack(alignment: .leading) {
//                            Text("Event ID: \(event.id)")
//                            Text("Coordinates: \(event.location.position.coordinates.map { "\($0)" }.joined(separator: ", "))")
//                            Text("Location Type: \(event.location.position.type)")
//                        }
//                    } else {
//                        Text("No location information available")
//                    }
//                }
            }
        }
    }
}

struct DetailCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEvent = Event(
            id: "1",
            name: ["fi": "Sample Event"],
            description: ["fi": "Sample Description"],
            info_url: ["fi": "Sample Link"],
            images: []//,
            //location: EventLocation(position: Position(coordinates: [12.34, 56.78, 40.30, 12.39], type: "String"))
        )

        return DetailCardView(event: sampleEvent)
    }
}
