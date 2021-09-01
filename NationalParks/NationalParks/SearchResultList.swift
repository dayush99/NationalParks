//
//  SearchResultList.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/17/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI
 
struct SearchResultsList: View {
   
    var body: some View {
                
            
        List {
            // Each struct in foundParksList has its own unique ID used by ForEach
            ForEach(foundParksList, id: \.self) { aPark in
                NavigationLink(destination: SearchResultDetails(nationalPark: aPark)) {
                    SearchResultItem(park: aPark)
                }
            }
        } // End of List
        
    }
}
 
 
struct SearchResultsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsList()
    }
}
