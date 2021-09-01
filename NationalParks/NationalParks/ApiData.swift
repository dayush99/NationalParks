//
//  ApiData.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/15/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation
import SwiftUI

// Global array of Recipe structs
var foundParksList = [NationalPark]()
var foundPark = NationalPark(fullName: "", states: "", websiteUrl: "", latitude: 0.0, longitude: 0.0, description: "", images: [ParkPhoto]())
let appKey = "A8nNg8IjahHvsPA0RieHCpm7Qb8SHmukE4YrjXmv"
fileprivate var previousQuery = ""

/*
 -----------------------------------------------------
 MARK: - Get Data from API for the Given Query
 -----------------------------------------------------
 */
public func getDataFromApi(apiQueryUrl: String) {
    
    // Avoid executing this function if already done for the same apiQueryUrl
    if apiQueryUrl == previousQuery {
        return
    } else {
        previousQuery = apiQueryUrl
    }
    
    // Clear out previous content in the global array
    foundParksList = [NationalPark]()
    
    
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
    
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: apiQueryUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        return
    }
    
    /*
     *******************************
     *   HTTP GET Request Set Up   *
     *******************************
     */
    
    let headers = [
        "x-api-key": "\(appKey)",
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "developer.nps.gov"
    ]
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    /*
     *********************************************************************
     *  Setting Up a URL Session to Fetch the JSON File from the API     *
     *  in an Asynchronous Manner and Processing the Received JSON File  *
     *********************************************************************
     */
    
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
         URLSession is established and the JSON file from the API is set to be fetched
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
        
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
        
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
             Foundation framework’s JSONSerialization class is used to convert JSON data
             into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                                options: JSONSerialization.ReadingOptions.mutableContainers)
            
            //------------------------------------------
            // Obtain Top Level JSON Object (Dictionary)
            //------------------------------------------
            var topLevelDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                topLevelDictionary = jsonObject
            } else {
                semaphore.signal()
                // foundRecipesList will be empty
                return
            }
            
            //------------------------------------
            // Obtain Array of "hits" JSON Objects
            //------------------------------------
            var arrayOfHitsJsonObjects = Array<Any>()
            
            if let jsonArray = topLevelDictionary["data"] as? [Any] {
                arrayOfHitsJsonObjects = jsonArray
                //                print(arrayOfHitsJsonObjects)
            } else {
                semaphore.signal()
                // foundRecipesList will be empty
                return
            }
            
            print(arrayOfHitsJsonObjects.count)
            for index in 0..<arrayOfHitsJsonObjects.count {
                
                //----------------
                // Initializations
                //----------------
                var fullName = "", states = "", url = "", latitude = 0.0, longitute = 0.0, description = "", images = [ParkPhoto]()
                
                
                var parkDictionary = Dictionary<String, Any>()
                
                if let dictionary = arrayOfHitsJsonObjects[index] as? [String: Any] {
                    
                    //-------------------
                    // Obtain Info
                    //-------------------
                    parkDictionary = dictionary
                    
                    if let _fullName = parkDictionary["fullName"] as? String {
                        fullName = _fullName
                        //                        print(fullName)
                    } else {
                        semaphore.signal()
                        return
                    }
                    
                    if let _states = parkDictionary["states"] as? String {
                        states = _states
                        //                        print(_states)
                    } else {
                        semaphore.signal()
                        return
                    }
                    
                    if let _url = parkDictionary["url"] as? String {
                        url = _url
                        //                        print(_url)
                    } else {
                        semaphore.signal()
                        return
                    }
                    
                    if let _description = parkDictionary["description"] as? String {
                        description = _description
                        //                        print(_description)
                    } else {
                        semaphore.signal()
                        return
                    }
                    
                    if let _latLong = parkDictionary["latLong"] as? String {
                        //                        print(_latLong)
                        // extract doubles "lat:33.66758356, long:-93.59641868"
                        
                        if !_latLong.isEmpty {
                            let ar1 = _latLong.components(separatedBy: ":")
                            let ar2 = ar1[1].components(separatedBy: ",")
                            
                            latitude = Double(ar2[0]) ?? 0
                            longitute = Double(ar1[2]) ?? 0
                        }
                    }
                    
                    if let _images = parkDictionary["images"] as? [Dictionary<String, Any>] {
                        
                        for index in 0..<_images.count {
                            
                            var caption = "", url = ""
                            
                            if let _imageCaption = _images[index]["caption"] as? String {
                                caption = _imageCaption
                            }
                            if let _imageUrl = _images[index]["url"] as? String {
                                url = _imageUrl
                            }
                            
                            let newImage = ParkPhoto(url: url, caption: caption)
                            images.append(newImage)
                        }
                        
                    }
                    
                    
                    let newPark = NationalPark(fullName: fullName, states: states, websiteUrl: url, latitude: latitude, longitude: longitute, description: description, images: images)
                    
                    foundParksList.append(newPark)
                    
                    
                } else {
                    semaphore.signal()
                    // foundRecipesList will be empty
                    return
                }
                
                
            }   // End of the for loop
            
        } catch {
            semaphore.signal()
            return
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
    
    _ = semaphore.wait(timeout: .now() + 60)
    
}


/*
 -----------------------------------------------------
 MARK: - Search for specific park
 -----------------------------------------------------
 */
public func searchForPark(parkFullName: String) {
    
    
    // Remove spaces, if any, at the beginning and at the end of the entered search query string
    let searchQueryTrimmed = parkFullName.trimmingCharacters(in: .whitespacesAndNewlines)
    
    // Replace all occurrences of space within the search query with +
    let query = searchQueryTrimmed.replacingOccurrences(of: " ", with: "+")
    
    // Compose the Edamam API Query URL string
    // Global constants edamamAppID and edamamAppKey are given in EdamamApiData.swift file
    let apiQueryUrl = "https://developer.nps.gov/api/v1/parks?q=\(query)&fields=images"
    
    
    
    // Avoid executing this function if already done for the same apiQueryUrl
    if apiQueryUrl == previousQuery {
        return
    } else {
        previousQuery = apiQueryUrl
    }
    
    // Clear out previous content in the global array
    foundPark = NationalPark(fullName: "", states: "", websiteUrl: "", latitude: 0.0, longitude: 0.0, description: "", images: [ParkPhoto]())
    
    
    /*
     *********************************************
     *   Obtaining API Search Query URL Struct   *
     *********************************************
     */
    
    var apiQueryUrlStruct: URL?
    
    if let urlStruct = URL(string: apiQueryUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        return
    }
    
    /*
     *******************************
     *   HTTP GET Request Set Up   *
     *******************************
     */
    
    let headers = [
        "x-api-key": "\(appKey)",
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "developer.nps.gov"
    ]
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    /*
     *********************************************************************
     *  Setting Up a URL Session to Fetch the JSON File from the API     *
     *  in an Asynchronous Manner and Processing the Received JSON File  *
     *********************************************************************
     */
    
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
         URLSession is established and the JSON file from the API is set to be fetched
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
        
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
        
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
             Foundation framework’s JSONSerialization class is used to convert JSON data
             into Swift data types such as Dictionary, Array, String, Number, or Bool.
             */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                                options: JSONSerialization.ReadingOptions.mutableContainers)
            
            //------------------------------------------
            // Obtain Top Level JSON Object (Dictionary)
            //------------------------------------------
            var topLevelDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                topLevelDictionary = jsonObject
            } else {
                semaphore.signal()
                // foundRecipesList will be empty
                return
            }
            
            //------------------------------------
            // Obtain Array of "hits" JSON Objects
            //------------------------------------
            var arrayOfHitsJsonObjects = Array<Any>()
            
            if let jsonArray = topLevelDictionary["data"] as? [Any] {
                arrayOfHitsJsonObjects = jsonArray
                //                print(arrayOfHitsJsonObjects)
            } else {
                semaphore.signal()
                // foundRecipesList will be empty
                return
            }
            
            print(arrayOfHitsJsonObjects.count)
            for index in 0..<arrayOfHitsJsonObjects.count {
                
                
                
                //----------------
                // Initializations
                //----------------
                var fullName = "", states = "", url = "", latitude = 0.0, longitute = 0.0, description = "", images = [ParkPhoto]()
                
                
                var parkDictionary = Dictionary<String, Any>()
                
                if let dictionary = arrayOfHitsJsonObjects[index] as? [String: Any] {
                    
                    //-------------------
                    // Obtain Info
                    //-------------------
                    parkDictionary = dictionary
                    
                    if let _fullName = parkDictionary["fullName"] as? String {
                        fullName = _fullName
                        
                        if parkFullName == _fullName {
                            print("FOUND!")
                            
                            if let _states = parkDictionary["states"] as? String {
                                states = _states
                                //                        print(_states)
                            } else {
                                semaphore.signal()
                                return
                            }
                            
                            if let _url = parkDictionary["url"] as? String {
                                url = _url
                                //                        print(_url)
                            } else {
                                semaphore.signal()
                                return
                            }
                            
                            if let _description = parkDictionary["description"] as? String {
                                description = _description
                                //                        print(_description)
                            } else {
                                semaphore.signal()
                                return
                            }
                            
                            if let _latLong = parkDictionary["latLong"] as? String {
                                //                        print(_latLong)
                                // extract doubles "lat:33.66758356, long:-93.59641868"
                                
                                if !_latLong.isEmpty {
                                    let ar1 = _latLong.components(separatedBy: ":")
                                    let ar2 = ar1[1].components(separatedBy: ",")
                                    
                                    latitude = Double(ar2[0]) ?? 0
                                    longitute = Double(ar1[2]) ?? 0
                                }
                            }
                            
                            if let _images = parkDictionary["images"] as? [Dictionary<String, Any>] {
                                
                                for index in 0..<_images.count {
                                    
                                    var caption = "", url = ""
                                    
                                    if let _imageCaption = _images[index]["caption"] as? String {
                                        caption = _imageCaption
                                    }
                                    if let _imageUrl = _images[index]["url"] as? String {
                                        url = _imageUrl
                                    }
                                    
                                    let newImage = ParkPhoto(url: url, caption: caption)
                                    images.append(newImage)
                                }
                                
                            }
                            
                            let newPark = NationalPark(fullName: fullName, states: states, websiteUrl: url, latitude: latitude, longitude: longitute, description: description, images: images)
                            
                            foundPark = newPark
                        }
                        
                    } else {
                        semaphore.signal()
                        return
                    }
                    
                    
                    
                } else {
                    semaphore.signal()
                    // foundRecipesList will be empty
                    return
                }
                
                
            }   // End of the for loop
            
        } catch {
            semaphore.signal()
            return
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
    
    _ = semaphore.wait(timeout: .now() + 60)
    
}
