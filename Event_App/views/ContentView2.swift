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
                        Text(event.name.nameInAnyLanguage())
                    }
                }
            }
            .onAppear {
                isLoading = true
                  fetchEventData { result in
                      DispatchQueue.main.async {
                          isLoading = false
                          switch result {
                          case .success(let events):
                              self.events = events
                          case .failure(let error):
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
