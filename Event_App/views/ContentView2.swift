/// KOODI HEAP-LOGOLLA

import SwiftUI

struct ContentView2: View {
    private var listOfEvents: [Event] = []
    @State private var showMenu: Bool = false

    var body: some View {
        Text("HEAP")
            .padding(150)
            .background(.blue, ignoresSafeAreaEdges: .all)
            .frame(width: 500, height: 50)
            .font(Font.custom("Modak", size: 60, relativeTo: .title))
            .foregroundColor(.white)
            .shadow(color: .black, radius: 4, x: 2, y: 6)
        NavigationView {
            ZStack{
                VStack(alignment: .leading){
                    EventCardView()
                        .navigationBarTitle(NSLocalizedString("popularNow", comment: "Navigation bar title for popular events"))
                }
                GeometryReader { _ in
                    HStack {
                        Spacer()
                        SideMenuView()
                            .offset(x: showMenu ? 0 : UIScreen.main.bounds.width)
                            .animation(.easeInOut(duration: 0.4), value: showMenu)
                    }
                }
                .background(Color.black.opacity(showMenu ? 0.5 : 0))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button{
                    self.showMenu.toggle()
                } label: {
                    if showMenu {
                        Image(systemName: "xmark")
                            .font(Font.custom("Custom", size: 17, relativeTo: .title))
                            .foregroundColor(.black)
                    } else {
                        Image(systemName: "text.justify")
                            .font(Font.custom("Custom", size: 17, relativeTo: .title))
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
