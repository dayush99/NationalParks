//
//  Photo.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/13/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation
import CoreData

public class Photo: NSManagedObject, Identifiable {
    
    @NSManaged public var nationalParkPhoto: Data?
    @NSManaged public var dateTime: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var parkVisit: ParkVisit?
}
