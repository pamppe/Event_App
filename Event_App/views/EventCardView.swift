//
//  EventCardView.swift
//  Event_App
//
//  Created by iosdev on 13.11.2023.
//

import SwiftUI

struct EventCardView: View {
    @State private var events: [Event] = []

    var body: some View {
        VStack {
             if events.isEmpty {
                 Text("Loading...")
             } else {
                 List(events) { event in
                     CardView(event: event)
                         .padding()
                 }
             }
         }
         .onAppear {
             fetchEventData { result in
                 switch result {
                 case .success(let events):
                     self.events = events
                 case .failure(let error):
                     print("Error fetching event data: \(error)")
                 }
             }
             fetchEventImages(forEvents: events) { result in
                 switch result {
                 case .success(let eventsWithImages):
                     self.events = eventsWithImages
                 case .failure(let error):
                     print("Error fetching event images: \(error)")
                 }
             }
         }
     }
    
    func fetchEventImages(forEvents events: [Event], completion: @escaping (Result<[Event], Error>) -> Void) {
           // DispatchGroup to wait for all image fetch requests to complete
           let dispatchGroup = DispatchGroup()

           var eventsWithImages = events

           for index in 0..<events.count {
               dispatchGroup.enter()

               let event = events[index]

               fetchEventImage(forEvent: event) { result in
                   switch result {
                   case .success(let imageData):
                       eventsWithImages[index].imageData = imageData
                   case .failure(let error):
                       print("Error fetching image for event \(event.id): \(error)")
                   }

                   dispatchGroup.leave()
               }
           }
           dispatchGroup.notify(queue: .main) {
               completion(.success(eventsWithImages))
           }
       }
   }

struct CardView: View {
    var event: Event

    var body: some View {
        VStack {
            // Check if event has image data
            if let imageData = event.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
            }

            Text(event.name.nameInAnyLanguage())
                .font(.headline)
                .padding()

            Spacer()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView()
    }
}
