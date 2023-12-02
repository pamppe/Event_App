//
//  DetailView.swift
//  Event_App
//
//  Created by iosdev on 13.11.2023.
//

import SwiftUI

struct DetailView: View {
    var event: Event
    @State private var fetchedPlace: Place?
    
    var body: some View {
        VStack {
            if fetchedPlace != nil {
                DetailCardView(event: event)
            }
            else {
                Text("Loading...")
                    .onAppear {
                        fetchLocation(eventID: event.id) { result in
                            switch result {
                            case .success(let place):
                                self.fetchedPlace = place
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                        DetailCardView(event: event)
                    }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEvent = Event(
            id: "1",
            name: ["fi": "Sample Event"],
            description: ["fi": "Sample Description"],
            info_url: ["fi": "Sample Link"],
            images: [],
            location: Place(position: Position(coordinates: [12.34, 56.78, 40.30, 12.39], type: "String"))
        )
        
        return DetailView(event: sampleEvent)
    }
}
