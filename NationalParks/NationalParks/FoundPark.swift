//
//  FoundPark.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/14/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import MapKit


import Foundation
import SwiftUI
import CoreData
import MapKit
import AVFoundation



struct FoundPark: View {
    // ❎ Input parameter: CoreData Song Entity instance reference
    let park: SearchedParkStruct
    
    var body: some View {
        Form {
            
            Group {
                
            Section(header: Text("National Park Full Name")) {
                Text(park.fullName)
            }
            Section(header: Text("States")) {
                Text(park.states)
                
            }
            Section(header: Text("National Park Description")) {
                Text(park.description)
            }
            Section(header: Text("National Park Service Webpage")) {
                NavigationLink(destination: WebView(url: park.websiteUrl)
                ) {
                    HStack {
                        Image(systemName: "globe").imageScale(.medium)
                        .font(Font.title.weight(.regular))
                        Text("See National Park Service Webpage")
                    }
                    
                }
                
            }
            Section(header: Text("Show National Park Location on Map")) {
                NavigationLink(destination: photoLocationOnMap) {
                    Image(systemName: "map.fill")
                }
            }
            Section(header: Text("National Park Photos")) {
                //var i = 0;
                ForEach(0 ..< park.photoUrl.count) { index in
                    self.getImageFromUrl(url: self.park.photoUrl[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text(verbatim: self.park.photoCaption[index])
                    
                }
                
            }
        }// End of Group
        }// End of Form
        .navigationBarTitle(Text("National Park Details"), displayMode: .inline)
        .font(.system(size: 14))
            .font(.headline)
            
    }// End of body
    
    var photoLocationOnMap: some View {
        let photoLatitude = (park.latitude as NSString).doubleValue
        let photoLongitude = (park.longitude as NSString).doubleValue
        
        return AnyView(MapView(mapType: MKMapType.standard, latitude: photoLatitude, longitude: photoLongitude, delta: 15.0, deltaUnit: "degrees", annotationTitle: park.fullName, annotationSubtitle: ""))
                .navigationBarTitle(Text(verbatim: park.fullName), displayMode: .inline)
                .edgesIgnoringSafeArea(.all)
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
    
    /*
    **************************
    MARK: - Get Image from URL
    **************************
    This public function fetches image data from the given URL in an asynchronous manner
    under a URLSession, converts it to UIImage, and then returns it as SwiftUI Image.
    */
    func getImageFromUrl(url: String) -> Image {
       
        // ImageUnavailable is provided in Assets.xcassets
        var imageObtainedFromUrl = Image("ImageUnavailable")
     
        let headers = [
            "accept": "image/jpg, image/jpeg, image/png",
            "cache-control": "cache",
            "connection": "keep-alive",
        ]
     
        // Convert given URL string into URL struct
        guard let imageUrl = URL(string: url) else {
            return Image("ImageUnavailable")
        }
     
        let request = NSMutableURLRequest(url: imageUrl,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
     
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
     
        /*
         Create a semaphore to control getting and processing API data.
         signal() -> Int    Signals (increments) a semaphore.
         wait()             Waits for, or decrements, a semaphore.
         */
        let semaphore = DispatchSemaphore(value: 0)
     
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            /*
            URLSession is established and the image file from the URL is set to be fetched
            in an asynchronous manner. After the file is fetched, data, response, error
            are returned as the input parameter values of this Completion Handler Closure.
            */
     
            // Process input parameter 'error'
            guard error == nil else {
                semaphore.signal()
                return
            }
     
            // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                semaphore.signal()
                return
            }
     
            // Unwrap Optional 'data' to see if it has a value
            guard let imageDataFromUrl = data else {
                semaphore.signal()
                return
            }
     
            // Convert fetched imageDataFromUrl into UIImage object
            let uiImage = UIImage(data: imageDataFromUrl)
     
            // Unwrap Optional uiImage to see if it has a value
            if let imageObtained = uiImage {
                // UIImage is successfully obtained. Convert it to SwiftUI Image.
                imageObtainedFromUrl = Image(uiImage: imageObtained)
            }
     
            semaphore.signal()
        }).resume()
     
        /*
         The URLSession task above is set up. It begins in a suspended state.
         The resume() method starts processing the task in an execution thread.
     
         The semaphore.wait blocks the execution thread and starts waiting.
         Upon completion of the task, the Completion Handler code is executed.
         The waiting ends when .signal() fires or timeout period of 10 seconds expires.
        */
     
        _ = semaphore.wait(timeout: .now() + 10)
     
        return imageObtainedFromUrl
    }
    
}
