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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            List {
                
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6), Color.blue]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                    //Display event name
                    VStack(alignment: .leading){
                        Text("\(event.name.nameInLanguage())")
                    }
                }
                .border(.black)
                
                //Display image
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
                                        .cornerRadius(15)
                                        .shadow(radius: 20)
                                case .failure:
                                    Text(NSLocalizedString("imageNotAvailable", comment: "Image not available"))
                                @unknown default:
                                    EmptyView() // Fallback to an empty view for any unknown case
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)                                }
                    }
                }
                
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6), Color.blue]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                    // Display description
                    VStack(alignment: .center){
                        Text(NSLocalizedString("description", comment: "Description"))
                        Text("\(event.sanitizedDescription())")
                            .padding(EdgeInsets(top: 8, leading: 5, bottom: 8, trailing: 5))
                    }
                }
                .border(.black)
                
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6), Color.blue]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)
                    // Display link to Event
                    VStack(alignment: .center){
                        Text(NSLocalizedString("linkToEventPage", comment: "Link to event page"))
                        Text("\(event.info_url?.nameInLanguage() ?? NSLocalizedString("noLinkAvailable", comment: "No link available"))")
                            .foregroundColor(.red)
                            .onTapGesture {
                                if let urlString = event.info_url?.values.first, let url = URL(string: urlString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .padding(EdgeInsets(top: 8, leading: 5, bottom: 8, trailing: 5))
                    }
                }
                .border(.black)
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
                images: [],
                super_event: nil
            )
            return DetailCardView(event: sampleEvent)
        }
    }
}

