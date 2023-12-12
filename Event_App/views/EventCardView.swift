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
            // Check if events is empty
            if events.isEmpty {
                Text(NSLocalizedString("loadingMessage", comment: "Loading message"))
            } else if let errorMessage = errorMessage {
                // The %@ will be replaced with the actual error message
                Text(String(format: NSLocalizedString("errorMessage", comment: "Error message"), errorMessage))
            } else {
                //Display a list of events
                List(events) { event in
                    //Clicking an event directs to the detail view
                    NavigationLink(destination: DetailView(event: event)){
                        VStack(alignment: .leading) {
                            //Theme
                            ZStack {
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
            //Get events
            fetchEventData { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let fetchedEvents):
                        //Remove duplicates
                        self.events = removeDuplicateEvents(events: fetchedEvents)
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}
// Card view for events
struct CardView: View {
    var event: Event
    var body: some View {
        VStack(alignment: .center) {
            //Events name
            Text(event.name.nameInLanguage())
                .font(.headline)
                .shadow(radius: 30)
                .padding(EdgeInsets(top: 20, leading: 30, bottom: 5, trailing: 20))
                .lineLimit(2)
                .frame(width: 200)
            
            //Image for event
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
                        //if no image available
                        Text(NSLocalizedString("imageNotAvailable", comment: "Image not available"))
                    @unknown default:
                        EmptyView() // Fallback to an empty view for any unknown case
                    }
                }
                .frame(width: 300, height: 250)
            }
            Spacer()
        }
        .frame(height: 250)
        .padding(.bottom, 20)
    }
    struct EventCardView_Previews: PreviewProvider {
        static var previews: some View {
            EventCardView()
        }
    }
}
