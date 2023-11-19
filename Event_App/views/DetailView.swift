//
//  DetailView.swift
//  Event_App
//
//  Created by iosdev on 13.11.2023.
//

import SwiftUI

struct DetailView: View {
    var event: Event

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
}

struct DetailView_Previews: PreviewProvider {
        static var previews: some View {
            let samplePosition = GeoPosition(coordinates: [12.34, 56.78], type: "Point")

            let sampleLocation = Place(
                street_address: ["fi": "Sample Street Address"],
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

            return DetailCardView(event: sampleEvent)
        }
    }

