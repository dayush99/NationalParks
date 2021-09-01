//
//  ContentView.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/12/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
    
       var body: some View {
    
           TabView {
               Home()
                   .tabItem {
                       Image(systemName: "house.fill")
                       Text("Home")
                   }
               ParksVisited()
                   .tabItem {
                       Image(systemName: "heart.fill")
                       Text("Parks Visited")
                   }
               SearchByName()
                   .tabItem {
                       Image(systemName: "magnifyingglass")
                       Text("Search By Name")
                   }
               SearchByState()
                   .tabItem {
                       Image(systemName: "magnifyingglass")
                       Text("Search By State")
                   }
           }   // End of TabView
           .font(.headline)
           .imageScale(.medium)
           .font(Font.title.weight(.regular))
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
