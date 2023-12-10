/// CONTENTVIEW / ALOITUSRUUTU

//
//  ContentView.swift
//  Event_App
//
//  Created by iosdev on 11/9/23.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background with darker shades of blue
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.6), Color.blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("HEAP")
                        .font(Font.custom("Modak", size: 100, relativeTo: .title))
                        .foregroundColor(.white)
                        .offset(y: -20)
                        .shadow(color: .black, radius: 4, x: 2, y: 6)

                    Text(NSLocalizedString("helsinkiEventsApp", comment: "App main title"))
                        .foregroundColor(.white)
                        .offset(y: -162)

                    NavigationLink(destination: ContentView2()) {
                        Text(NSLocalizedString("clickHere", comment: "Main button text"))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
