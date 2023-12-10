//
//  EventCardView.swift
//  Event_App
//
//  Created by iosdev on 13.11.2023.
//

import SwiftUI

struct EventCardView: View {
    @State private var events: [Event] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    var body: some View {
            VStack {
                if events.isEmpty {
                    Text(NSLocalizedString("loadingMessage", comment: "Loading message"))
                } else if let errorMessage = errorMessage {
                    // The %@ will be replaced with the actual error message
                    Text(String(format: NSLocalizedString("errorMessage", comment: "Error message"), errorMessage))
                } else {
                    List(events) { event in
                        NavigationLink(destination: DetailView(event: event)){
                            VStack(alignment: .leading) {
                                ZStack {
                                    // Background with darker shades of blue
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6), Color.blue]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .edgesIgnoringSafeArea(.all)
                                    CardView(event: event)
                                        .padding()
                                }
                            }
                        }
                    }
                }
            }
        .onAppear {
            isLoading = true
            fetchEventData { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let fetchedEvents):
                        self.events = removeDuplicateEvents(events: fetchedEvents)
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
struct CardView: View {
    var event: Event
    var body: some View {
        VStack(alignment: .center) {
                Text(event.name.nameInLanguage())
                .padding(.leading, 15)
                    .font(.headline)
                    .shadow(radius: 30)
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
                                .cornerRadius(15)
                                .shadow(radius: 30)
                        case .failure:
                            Text(NSLocalizedString("imageNotAvailable", comment: "Image not available"))
                        @unknown default:
                            EmptyView() // Fallback to an empty view for any unknown case
                        }
                        
                    }
                    .frame(width: 500, height: 200)
                    .padding(.leading, 15)
                }
        }
    }
    struct EventCardView_Previews: PreviewProvider {
        static var previews: some View {
            EventCardView()
        }
    }
}
