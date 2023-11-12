import SwiftUI

struct ContentView2: View {
    @State private var events: [Event] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    Text("Loading...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
                    ForEach(events) { event in
                        VStack(alignment: .leading) {
                            Text(event.name)
                            // Add other UI elements for each event
                        }
                    }
                }
            }
            .onAppear {
                            isLoading = true
                            fetchAPIResponse(endpoint: "event/") { (result: Result<EventResponse, Error>) in
                                DispatchQueue.main.async {
                                    isLoading = false
                                    switch result {
                                    case .success(let response):
                                        print("Events fetched: \(response.events)")
                                        self.events = response.events
                                    case .failure(let error):
                                        print("Error fetching events: \(error.localizedDescription)")
                                        self.errorMessage = error.localizedDescription
                                    }
                    }
                }
            }
            .navigationBarTitle("Events")
        }
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
