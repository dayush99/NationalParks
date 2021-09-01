//
//  SearchResultPark.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/18/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI
 
struct SearchResultItem: View {
    
    // Input Parameter
    let park: NationalPark
   
    var body: some View {
        HStack {
            if !park.images.isEmpty {
                getImageFromUrl(url: park.images[0].url)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0, height: 60.0)
            } else {
                Image("ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0, height: 60.0)
            }
            
            VStack(alignment: .leading) {
                Text(park.fullName)
                   
                Text(park.states)
            }
            .font(.system(size: 14))
        } // End of HStack
    }
}
