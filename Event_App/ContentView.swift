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
          VStack {
                NavigationLink(destination: ContentView2()) {
                    Text("Events")
                }
                .navigationBarTitle("Main page", displayMode: .inline)
                Spacer()
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
