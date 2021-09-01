//
//  PhotoImageFromBinaryData.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/12/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation
import SwiftUI

 

/*

*************************************************

|   Return Photo Image from Given Binary Data   |

*************************************************

*/

public func photoImageFromBinaryData(binaryData: Data?) -> Image {

 

    // Create a UIImage object from binaryData

    let uiImage = UIImage(data: binaryData!)

  

    // Unwrap uiImage to see if it has a value

    if let imageObtained = uiImage {

      

        // Image is successfully obtained
        return Image(uiImage: imageObtained)

      

    } else {

        return Image("AlbumCoverDefaultImage")

    }


}
