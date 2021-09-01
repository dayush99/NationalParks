//
//  NationalPark.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/14/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI
import Foundation
 
struct NationalPark: Hashable {
    
    var fullName: String
    var states: String
    var websiteUrl: String
    var latitude: Double
    var longitude: Double
    var description: String
    var images: [ParkPhoto]
}
