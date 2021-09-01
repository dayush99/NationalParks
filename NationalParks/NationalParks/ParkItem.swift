//
//  ParkItem.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/16/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI
import CoreData
 

struct ParkItem: View {

    // ❎ Input parameter: CoreData Song Entity instance reference

   let nationalPark: ParkVisit


    // ❎ CoreData FetchRequest returning all Song entities in the database

    @FetchRequest(fetchRequest: ParkVisit.allParksFetchRequest()) var allParks: FetchedResults<ParkVisit>
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
    var body: some View {
        HStack {
            
            photoImageFromBinaryData(binaryData: nationalPark.photo!.nationalParkPhoto!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0, height: 60.0)
           
            VStack(alignment: .leading) {
                
                /*
                ?? is called nil coalescing operator.
                IF song.artistName is not nil THEN
                    unwrap it and return its value
                ELSE return ""
                */
                Text(nationalPark.fullName ?? "")
               PublicationDateAndTime(stringDate: nationalPark.dateVisited!)
                Text(nationalPark.rating ?? "")
            }
        }            .font(.system(size: 14))
    }
    
     struct PublicationDateAndTime: View {
           // Input Parameter in format of "2020-01-18T12:26:..."
           var stringDate: String

           var body: some View {
               let dateFormatter = DateFormatter()
                
               // Set the date format to yyyy-MM-dd
               dateFormatter.dateFormat = "yyyy-MM-dd"
               dateFormatter.locale = Locale(identifier: "en_US")
                
               // Convert date String from "yyyy-MM-dd" to Date struct
               let dateStruct = dateFormatter.date(from: stringDate)
               // Create a new instance of DateFormatter
               let newDateFormatter = DateFormatter()
                
               newDateFormatter.locale = Locale(identifier: "en_US")
               newDateFormatter.dateStyle = .long      // Thursday, November 7, 2019
               newDateFormatter.timeStyle = .none
                
               // Obtain newly formatted Date String as "Thursday, November 7, 2019"
               let dateWithNewFormat = newDateFormatter.string(from: dateStruct!)
          
               return Text(dateWithNewFormat)
           }
       }
}
