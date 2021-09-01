//
//  SearchResultDetails.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/19/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchResultDetails: View {
    
    @State var nationalPark: NationalPark
    
    var body: some View {
        
        Form {
            Group {
                
            Section(header: Text("National Park Full Name")) {
                Text(nationalPark.fullName)
            }
            Section(header: Text("States")) {
                Text(nationalPark.states)
            }
            Section(header: Text("National Park Description")) {
                Text(nationalPark.description)
            }
            Section(header: Text("National Park Service Webpage")) {
                NavigationLink(destination: WebView(url: nationalPark.websiteUrl))
                {
                    HStack {
                        Image(systemName: "globe")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                        Text("See National Park Service Webpage")
                        
                    } // HStack ends
                }
            }
            if !nationalPark.latitude.isNaN {
                Section(header: Text("Show National Park Location on Map")) {
                    NavigationLink(destination: mapView) {
                        Image(systemName: "map.fill")
                    }
                }
            }
            if !nationalPark.images.isEmpty {
                Section(header: Text("National Park Photos")) {
                    List (nationalPark.images, id: \.self) { aImage in
                        VStack {
                        getImageFromUrl(url: aImage.url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(aImage.caption)
                        }
                    }
                    
                }
            }
        } // End of Group
            
        }  // End of Form
            .navigationBarTitle(Text("National Park Details"), displayMode: .inline)
            .font(.system(size: 14))
                .font(.headline)
    }   // End of body
        
    var mapView: some View {
        return AnyView (
            MapView(
                mapType: MKMapType.standard, latitude: nationalPark.latitude, longitude: nationalPark.longitude, delta: 1000.0, deltaUnit: "meters", annotationTitle: nationalPark.fullName, annotationSubtitle:nationalPark.states
            )
        )
    }
}
