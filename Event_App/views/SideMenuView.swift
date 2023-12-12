//
//  SideMenuView.swift
//  Event_App
//
//  Created by iosdev on 14.11.2023.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack {
            Divider()
                .frame(width: 200, height: 2)
                .background(Color.white)
                .padding(.horizontal, 16)
            
            VStack {
                //Settings
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.gray)
                        .offset(x: -18)
                        .shadow(color: .black, radius: 4, x: 2, y: 6)
                    Text(NSLocalizedString("settings", comment: "Settings menu item"))
                        .foregroundColor(.black)
                        .font(.title)
                        .offset(x: -1)
                }
            }
            
            Divider()
                .frame(width: 200, height: 2)
                .background(Color.white)
                .padding(.horizontal, 16)
            
            VStack {
                //Categories
                NavigationLink(destination: CategoriesView()) {
                    Image(systemName: "folder.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.brown)
                        .offset(x: -16)
                        .shadow(color: .black, radius: 4, x: 2, y: 6)
                    Text(NSLocalizedString("categories", comment: "Categories menu item"))
                        .foregroundColor(.black)
                        .font(.title)
                }
            }
            
            Divider()
                .frame(width: 200, height: 2)
                .background(Color.white)
                .padding(.horizontal, 16)
            
            Spacer()
            
            VStack {
                //Info
                NavigationLink(destination: InfoView()) {
                    Text(NSLocalizedString("infoAboutUs", comment: "Categories menu item"))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(15)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
}
struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
