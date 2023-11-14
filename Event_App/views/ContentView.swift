import SwiftUI


struct ContentView: View {
    
    @State var searchText = ""
    @State private var showMenu: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Text("Hellurei")
                
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
        
            .searchable(text: $searchText)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
