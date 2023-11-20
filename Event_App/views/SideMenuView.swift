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
            VStack{
                NavigationLink(destination: ContentView2()){
                    Text("Etusivu")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            Divider()
                .frame(width: 200, height: 2)
                .background(Color.white)
                .padding(.horizontal, 16)
            VStack{
                NavigationLink(destination: SettingsView()){
                    Text("Asetukset")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            Divider()
                .frame(width: 200, height: 2)
                .background(Color.white)
                .padding(.horizontal, 16)
            VStack{
                NavigationLink(destination:CategoriesView()){
                    Text("Kategoriat")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            Spacer()
            VStack{
                NavigationLink(destination:CategoriesView()){
                    Text("Tietoa meistä")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(15)
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    struct SideMenuView_Previews: PreviewProvider {
        static var previews: some View {
            SideMenuView()
        }
    }
}
