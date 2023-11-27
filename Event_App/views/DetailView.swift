//
//  DetailView.swift
//  Event_App
//
//  Created by iosdev on 13.11.2023.
//

import SwiftUI

struct DetailView: View {
    @State private var fetchedPlace: Place?
    var event: Event

    var body: some View {
        VStack {
            if let place = fetchedPlace {
                DetailCardView(event: event, place: place)
            } else {
                Text("Loading...")
                    .onAppear {
                        fetchLocation(placeID: event.id) { result in
                            switch result {
                            case .success(let place):
                                self.fetchedPlace = place
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                    }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
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
