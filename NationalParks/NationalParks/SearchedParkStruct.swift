//
//  SearchedParkStruct.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/13/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation

struct SearchedParkStruct: Hashable, Identifiable {
    
    
    
    var id: UUID
    var fullName: String
    var states: String
    var websiteUrl: String
    var latitude: String
    var longitude: String
    var description: String
    var photoUrl: [String]
    var photoCaption: [String]
}
