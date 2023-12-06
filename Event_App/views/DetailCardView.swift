//
//  DetailCardView.swift
//  Event_App
//
//  Created by iosdev on 18.11.2023.
//

import SwiftUI
import UIKit

struct DetailCardView: View {
    var event: Event
    //var place: Place
    @State private var place: Place? // Use @State to handle asynchronous updates
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) { // Center-align content vertically with spacing
            List {
                VStack(alignment: .center){
                    Text("\(event.name.nameInLanguage())")
                }
                VStack(alignment: .center){
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
                }
                VStack(alignment: .center){
                    Text("Description")
                    Text("\(event.sanitizedDescription())")
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
                // Display link to Event
                VStack(alignment: .center){
                    Text("Link to event page")
                    Text("\(event.info_url?.nameInLanguage() ?? "N/A")")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if let urlString = event.info_url?.values.first, let url = URL(string: urlString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
                // Display street address information
                Section(header: Text("Location")) {
                    VStack(alignment: .leading) {
                        Text("Street Address:")
                        Text("\(place?.street_address?.nameInLanguage() ?? "N/A")")
                    }
                }
            }
            .onAppear {
                // Fetch location data when the view appears
                fetchEventLocation { result in
                    switch result {
                    case .success(let places):
                        if let place = places.first {
                            // Access the street address
                            let streetAddress = place.street_address?.nameInLanguage()
                            print("Street Address (fi): \(String(describing: streetAddress))")
                        }
                    case .failure(let error):
                        // Handle the error
                        print("Error fetching location: \(error)")
                    }
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
                images: []
            )
            _ = Place(
                //id: "1",
                street_address: ["fi": "Sample address"]
            )
            return DetailCardView(event: sampleEvent)
        }
    }
}

