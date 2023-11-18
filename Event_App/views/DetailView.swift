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
        NavigationView {
            DetailView(event: Event(id: "1", name: ["fi": "Sample Event"], description: ["fi": "Sample Description"], location: ["fi": "Sample Location"], images: []))
        }
    }
}
