//
//  Audio.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/13/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation
import CoreData

public class Audio: NSManagedObject, Identifiable {
 
    @NSManaged public var voiceRecording: Data?
    @NSManaged public var parkVisit: ParkVisit?
}
