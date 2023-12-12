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
                
                Text(NSLocalizedString("aboutUsTitle", comment: "Title for About Us page"))
                    .font(Font.custom("Modak", size: 35, relativeTo: .title))
                    .foregroundColor(.black)
                    .offset(y: -250)
                
                Text(NSLocalizedString("aboutUsDescription", comment: "Description for About Us page"))
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

