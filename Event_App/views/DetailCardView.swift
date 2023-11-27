//
//  DetailCardView.swift
//  Event_App
//
//  Created by iosdev on 18.11.2023.
//

import SwiftUI

struct DetailCardView: View {
    var event: Event
    var place: Place
    
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
               
                if let streetAddress = place.streetAddress?["fi"], !streetAddress.isEmpty {
                    Text("Street Address: \(streetAddress)")
                } else {
                    Text("Street Address not available")
                }
                Text("Latitude: \(place.position?.coordinates[1] ?? 0.0)")
                Text("Longitude: \(place.position?.coordinates[0] ?? 0.0)")
                
                
            }
        }
    }
}

struct DetailCardView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePosition = GeoPosition(coordinates: [12.34, 56.78], type: "Point")

        let sampleLocation = Place(
            streetAddress: ["fi": "Sample Street Address"],
            position: samplePosition
            // Add other location properties as needed
        )

        let sampleEvent = Event(
            id: "1",
            name: ["fi": "Sample Event"],
            description: ["fi": "Sample Description"],
            location: sampleLocation,
            images: []
        )

        return DetailView(event: sampleEvent)
    }
}


