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
                        .navigationBarTitle(NSLocalizedString("eventDetails", comment:"Navigation bar tittle for event details"),displayMode: .inline)
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
            super_event: nil
        )
        return DetailView(event: sampleEvent)
    }
}

