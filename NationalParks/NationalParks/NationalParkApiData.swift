//
//  NationalParkApiData.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/15/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation
import SwiftUI

var currPark = SearchedParkStruct(id: UUID(), fullName: "", states: "", websiteUrl: "", latitude: "0.0", longitude: "0.0", description: "", photoUrl: [String](), photoCaption: [String]())
var listOfParks = [SearchedParkStruct]()


public func getParkDataFromApi(search: String) {
    currPark = SearchedParkStruct(id: UUID(), fullName: "", states: "", websiteUrl: "", latitude: "", longitude: "", description: "", photoUrl: [String](), photoCaption: [String]()) //to reset at each call
    
    //let key = "dEOhu7XoMziFwfZIiMV3TDSQaPPgqFqBVMu1DX8S"
    let trimmed = search.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
    let apiUrl = "https://developer.nps.gov/api/v1/parks?q=\(trimmed)&fields=images"
    
    
    
    var apiQueryUrlStruct: URL?
    if let urlStruct = URL(string: apiUrl) {
        
        apiQueryUrlStruct = urlStruct
        
    } else {
        
        print("URL Struct problem")
        return
        
    }
    let headers = [
        "x-api-key": "A8nNg8IjahHvsPA0RieHCpm7Qb8SHmukE4YrjXmv",
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "developer.nps.gov"
    ]
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
    let semaphore = DispatchSemaphore(value: 0)
    //   _ = semaphore.wait(timeout: .now() + 60)
    
    request.httpMethod = "GET"
    
    request.allHTTPHeaderFields = headers
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
         print("IWANNAFINISHTHISASSIGNMENTSOICANSTARTANOTHER....ASSIGNMENT")
         
         URLSession is established and the JSON file from the API is set to be fetched
         
         in an asynchronous manner. After the file is fetched, data, response, error
         
         are returned as the input parameter values of this Completion Handler Closure.
         
         */
        
        
        // Process input parameter 'error'
        
        guard error == nil else {
            print ("URL Session Error: \(error!)")
            
            semaphore.signal()
            
            return
            
        }
        
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            
            print("The API server did not return a valid response!")
            
            semaphore.signal()
            
            
            return
            
        }
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                                                                
                                                                options: JSONSerialization.ReadingOptions.mutableContainers)
            
            /*
             
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
             
             Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
             
             where Dictionary Key type is String and Value type is Any (instance of any type)
             
             */
            
            var jsonDataDictionary = Dictionary<String, Any>()
            
            if let jsonArray = jsonResponse as? [String: Any] {
                
                jsonDataDictionary = jsonArray
                
            } else {
                semaphore.signal()
                return
            }
            
            if let jsonArr = jsonDataDictionary["data"] as? [Any] {
                print("MADE IT HERE")
                for i in (0...jsonArr.count - 1){
                    
                    if let firstJsonObj = jsonArr[i] as? [String: Any] {
                        if let fullName = firstJsonObj["fullName"] as? String {
                            if(fullName == search)
                            {
                                currPark.fullName = fullName
                            }
                            else {
                                continue
                            }
                            
                        } else {
                            semaphore.signal()
                            return
                        }
                        
                        if let states = firstJsonObj["states"] as? String {
                            currPark.states = states
                        }
                        else {
                            semaphore.signal()
                            return
                        }
                        if let description = firstJsonObj["description"] as? String {
                            currPark.description = description
                        } else {
                            semaphore.signal()
                            return
                        }
                        if let url = firstJsonObj["url"] as? String {
                            currPark.websiteUrl = url
                        }
                        else {
                            semaphore.signal()
                            return
                        }
                        if let latlong = firstJsonObj["latLong"]  as? String  {
                            let parts = latlong.components(separatedBy: ", ")
                            
                            currPark.latitude = parts[0].components(separatedBy: ":")[1]
                            currPark.longitude = parts[1].components(separatedBy: ":")[1]
                            
                        }
                        else {
                            semaphore.signal()
                            return
                        }
                        
                        if let imagesArr = firstJsonObj["images"] as? [Any] {
                            print(imagesArr.count)
                            for j in (0...imagesArr.count - 1)
                            {
                                print(j)
                                if let imageParse = imagesArr[j] as? [String: Any]  {
                                    if let caption = imageParse["caption"] as? String {
                                        currPark.photoCaption.append(caption)
                                    }
                                    else {
                                        semaphore.signal()
                                        return
                                    }
                                    if let photoUrl = imageParse["url"] as? String {
                                        currPark.photoUrl.append(photoUrl)
                                    }
                                    else {
                                        semaphore.signal()
                                        return
                                    }
                                    
                                }
                                else {
                                    semaphore.signal()
                                    return
                                }
                            }
                        }
                        else {
                            semaphore.signal()
                            return
                        }
                        
                    } else {
                        
                        semaphore.signal()
                        
                        return
                        
                    }
                }
                
            }
            
            
            
        } catch {
            semaphore.signal()
            return
        }
        semaphore.signal()
    }).resume()
    
    
    
    _ = semaphore.wait(timeout: .now() + 60)
    
    
    
}
public func getStateDataFromApi(search: String) {
    
    currPark = SearchedParkStruct(id: UUID(), fullName: "", states: "", websiteUrl: "", latitude: "", longitude: "", description: "", photoUrl: [String](), photoCaption: [String]()) //to reset at each call
    let trimmed = search.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
    let apiUrl = "https://developer.nps.gov/api/v1/parks?stateCode=\(trimmed)&fields=images"
    var apiQueryUrlStruct: URL?
    if let urlStruct = URL(string: apiUrl) {
        apiQueryUrlStruct = urlStruct
        
    } else {
        print("URL Struct problem")
        return
        
    }
    let headers = [
        "x-api-key": "A8nNg8IjahHvsPA0RieHCpm7Qb8SHmukE4YrjXmv",
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "developer.nps.gov"
        
    ]
    
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
    cachePolicy: .useProtocolCachePolicy,
    timeoutInterval: 60.0)
    
    let semaphore = DispatchSemaphore(value: 0)
    
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in guard error == nil else {
        print ("URL Session Error: \(error!)")
        
        
        
        semaphore.signal()
        return
        
        }
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("The API server did not return a valid response!")
            semaphore.signal()
            return
        }
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            
            semaphore.signal()
            
            return
            
        }
        
        do {
            
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi, options: JSONSerialization.ReadingOptions.mutableContainers)
            var jsonDataDictionary = Dictionary<String, Any>()
            if let jsonArray = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonArray
            } else {
                semaphore.signal()
                return
            }
            if let jsonArr = jsonDataDictionary["data"] as? [Any] {
                for i in (0..<jsonArr.count){
                    currPark = SearchedParkStruct(id: UUID(), fullName: "", states: "", websiteUrl: "", latitude: "", longitude: "", description: "", photoUrl: [String](), photoCaption: [String]())
                    if let firstJsonObj = jsonArr[i] as? [String: Any] {
                        if let fullName = firstJsonObj["fullName"] as? String {
                            currPark.fullName = fullName
                        } else {
                            semaphore.signal()
                            return
                        }
                        if let states = firstJsonObj["states"] as? String {
                            currPark.states = states
                        }
                        else {
                            semaphore.signal()
                            return
                        }
                        if let url = firstJsonObj["url"] as? String {
                            currPark.websiteUrl = url
                        }
                        else {
                            semaphore.signal()
                            return
                        }
                        
                        if let latlong = firstJsonObj["latLong"]  as? String  {
                            let parts = latlong.components(separatedBy: ", ")
                            
                            currPark.latitude = parts[0].components(separatedBy: ":")[1]
                            currPark.longitude = parts[1].components(separatedBy: ":")[1]
                        }
                        else {
                            semaphore.signal()
                            return
                        }
                        if let imagesArr = firstJsonObj["images"] as? [Any] {
                            for i in (0..<imagesArr.count)
                            {
                                
                                if let imageParse = imagesArr[i] as? [String: Any]  {
                                    if let caption = imageParse["caption"] as? String {
                                        currPark.photoCaption.append(caption)
                                    }
                                    else {
                                        semaphore.signal()
                                        return
                                    }
                                    if let photoUrl = imageParse["url"] as? String {
                                        currPark.photoCaption.append(photoUrl)
                                    }
                                    else {
                                        semaphore.signal()
                                        return
                                    }
                                }
                                else {
                                    semaphore.signal()
                                    return
                                }
                            }
                        }
                        else {
                            semaphore.signal()
                            return
                        }
                        listOfParks.append(currPark)
                    } else {
                        semaphore.signal()
                        return
                    }
                }
            }
        } catch {
            
            semaphore.signal()
            
            return
            
        }
        
        semaphore.signal()
        
    }).resume()
    _ = semaphore.wait(timeout: .now() + 60)
    
    
}
