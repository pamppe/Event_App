//
//  SideMenuView.swift
//  Event_App
//
//  Created by iosdev on 14.11.2023.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack{
            Text("jotain")
                .font(.title)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(15)
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
