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
                Text("Description: \(event.description.nameInLanguage())")
                Text("Location: \(event.location.nameInLanguage())")

                // Display other details based on your Event model properties
            }
        }
    }
}

struct DetailCardView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCardView(event: Event(id: "1", name: ["fi": "Sample Event"], description: ["fi": "Sample Description"], location: ["fi": "Sample Location"], images: []))
    }
}
