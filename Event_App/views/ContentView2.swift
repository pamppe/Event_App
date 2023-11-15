import SwiftUI


struct ContentView2: View {
    private var listOfEvents: [Event] = []
    @State var searchText = ""
    @State private var showMenu: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    EventCardView()
                        .navigationBarTitle("Main page", displayMode: .inline)
                }
                GeometryReader { _ in
                    HStack {
                        Spacer()
                        SideMenuView()
                            .offset(x: showMenu ? 0 : UIScreen.main.bounds.width)
                    }
                }
                .background(Color.black.opacity(showMenu ? 0.5 : 0))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button{
                    self.showMenu.toggle()
                }label: {
                    if showMenu {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.blue)
                    }else {
                        Image(systemName: "text.justify")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    
    //    var events: [Event] {
    //        let lcEvents = listOfEvents.map { $0.nameInLanguage().lowercased() }
    //
    //        return searchText.isEmpty ? listOfEvents : listOfEvents.filter {
    //            $0.nameInLanguage().lowercased().contains(searchText.lowercased())
    //        }
    //    }
    
    
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
