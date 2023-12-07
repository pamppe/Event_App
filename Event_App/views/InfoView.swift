/// INFOVIEW

//
//  InfoView.swift
//  Event_App
//
//  Created by iosdev on 20.11.2023.
//

import SwiftUI

struct InfoView: View {
    @State private var showMenu: Bool = false
    var body: some View {
        NavigationView {
            ZStack{
                Color.white
                    .edgesIgnoringSafeArea(.all)
                Text("Tietoa meistä")
                    .font(Font.custom("Modak", size: 35, relativeTo: .title))
                    .foregroundColor(.black)
                    .offset(y: -250)
                Text(" Heap on neljän tieto- ja viestinätekniikan   insinööriopiskelijan vuonna 2023 suunnittelema ja koodaama mobiilisovellus, jonka käyttötarkoituksena on toimia helppona ja nopeana tapana tutustua Helsingin tapahtumatarjontaan.")
                    .frame(width: 360)
                    .lineLimit(30)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .offset(y: -80)
            }
        }
    }
}
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

