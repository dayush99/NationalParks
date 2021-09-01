//
//  ParkVisit.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/14/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation
import CoreData
 

/*
 🔴 Set Current Product Module:
    In xcdatamodeld editor, select Song, show Data Model Inspector, and
    select Current Product Module from Module menu.
 🔴 Turn off Auto Code Generation:
    In xcdatamodeld editor, select Song, show Data Model Inspector, and
    select Manual/None from Codegen menu.
*/
 
// ❎ CoreData Song entity public class
public class ParkVisit: NSManagedObject, Identifiable {
 
    @NSManaged public var dateVisited: String?
    @NSManaged public var fullName: String?
    @NSManaged public var rating: String?
    @NSManaged public var speechToTextNotes: String?
    @NSManaged public var states: String?
    @NSManaged public var audio: Audio?
    @NSManaged public var photo: Photo?
}
 
extension ParkVisit {
    /*
     ❎ CoreData FetchRequest in ContentView calls this function
        to get all of the Song entities in the database
     */
    static func allParksFetchRequest() -> NSFetchRequest<ParkVisit> {
       
        let request: NSFetchRequest<ParkVisit> = ParkVisit.fetchRequest() as! NSFetchRequest<ParkVisit>
        /*
         List the songs in alphabetical order with respect to artistName;
         If artistName is the same, then sort with respect to songName.
         */
        request.sortDescriptors = [NSSortDescriptor(key: "fullName", ascending: true)]
       
        return request
    }
}
