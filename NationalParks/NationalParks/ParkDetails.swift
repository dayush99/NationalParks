//
//  ParkDetails.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/17/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import MapKit
import AVFoundation

struct ParkDetails: View {
    
    // ❎ Input parameter: CoreData Song Entity instance reference
    let park: ParkVisit
    @EnvironmentObject var audioPlayer: AudioPlayer
    // ❎ CoreData FetchRequest returning all Song entities in the database
    @FetchRequest(fetchRequest: ParkVisit.allParksFetchRequest()) var allParks: FetchedResults<ParkVisit>
    
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        Form {
            Section(header: Text("National Park Full Name")) {
                Text(park.fullName ?? "")
            }
            Section(header: Text("States")) {
                Text(park.states ?? "")
            }
            Section(header: Text("National Park Visit Photo")) {
                photoImageFromBinaryData(binaryData: park.photo!.nationalParkPhoto!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Section(header: Text("Show National Park Location on Map")) {
                NavigationLink(destination: photoLocationOnMap) {
                    Image(systemName: "map.fill")
                }
            }
            Section(header: Text("Play Notes taken by voice recording")) {
                Button(action: {
                    if self.audioPlayer.isPlaying {
                        self.audioPlayer.pauseAudioPlayer()
                    } else {
                        self.audioPlayer.startAudioPlayer()
                    }
                }) {
                    Image(systemName: self.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.blue)
                        .font(Font.title.weight(.regular))
                    }
            }
            Section(header: Text("Notes Taken by Speech to Text Conversion")) {
                Text(park.speechToTextNotes!)
            }
            Section(header: Text("Date Visited National Park")) {
                PublicationDateAndTime(stringDate: park.dateVisited!)
            }
            Section(header: Text("My National Park Rating")) {
                Text(park.rating ?? "")
            }
        }            .font(.system(size: 14))
            // End of Form
            .navigationBarTitle(Text("National Park Details"), displayMode: .inline)
            .onAppear() {
                self.createPlayer()
            }
            .onDisappear() {
                self.audioPlayer.stopAudioPlayer()
            }
    }// End of body
    
    var photoLocationOnMap: some View {
        let photoLatitude = park.photo!.latitude as! Double
        let photoLongitude = park.photo!.longitude as! Double
        
        return AnyView(MapView(mapType: MKMapType.standard, latitude: photoLatitude, longitude: photoLongitude, delta: 15.0, deltaUnit: "degrees", annotationTitle: park.fullName!, annotationSubtitle: park.photo!.dateTime!))
                .navigationBarTitle(Text(verbatim: park.fullName!), displayMode: .inline)
                .edgesIgnoringSafeArea(.all)
    }
    /*
    ---------------------------
    MARK: - Create Audio Player
    ---------------------------
    */
    func createPlayer() {
        audioPlayer.createAudioPlayer(audioData: park.audio!.voiceRecording!)
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
}
