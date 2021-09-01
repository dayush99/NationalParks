//
//  ParkStruct.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/13/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation

struct ParkStruct: Codable {
    
    var photoAndAudioFilename: String
    var fullName: String
    var states: String
    var dateVisited: String
    var photoDateTime: String
    var photoLatitude: Double
    var photoLongitude: Double
    var speechToTextNotes: String
    var rating: String
}
