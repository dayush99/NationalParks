//
//  ParksVisited.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/17/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI
import CoreData

struct ParksVisited: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    
    // ❎ CoreData FetchRequest returning all Song entities in the database
    
    @FetchRequest(fetchRequest: ParkVisit.allParksFetchRequest()) var allParks: FetchedResults<ParkVisit>
    
    
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    
    @EnvironmentObject var userData: UserData
    
    
    
    var body: some View {
        
        NavigationView {
            
            if self.allParks.count == 0 {
                
                // If the database is empty, ask the user to populate it.
                Button(action: {
                    self.addInitialContentToDatabase()
                }) {
                    HStack {
                        Image(systemName: "gear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Populate Database")
                    }
                }
            }
            
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Songs in a dynamic scrollable list.
                 */
                ForEach(self.allParks) { aPark in
                    NavigationLink(destination: ParkDetails(park: aPark)) {
                        ParkItem(nationalPark: aPark)
                    }
                }
                .onDelete(perform: delete)
                
            }   // End of List
                .navigationBarTitle(Text("National Parks Visited"), displayMode: .inline)
                // Place the Edit button on left and Add (+) button on right of the navigation bar
                
                .navigationBarItems(leading: EditButton(), trailing:
                    NavigationLink(destination: AddPark() ) {
                        Image(systemName: "plus")
                })
            
        }   // End of NavigationView
    }
    /*
     ----------------------------
     MARK: - Delete Selected Song
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
        let songToDelete = self.allParks[offsets.first!]
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(songToDelete)
        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Unable to delete selected song!")
        }
    }
    /*
     ---------------------------------------
     MARK: - Add Initial Content to Database
     ---------------------------------------
     */
    func addInitialContentToDatabase() {
        
        // This public function is given in LoadInitialContentData.swift
        loadInitialDatabaseContent()
        // listOfMusicAlbums = [Album]() is now available
        for pstruct in listOfParkStructs {
            /*
             =====================================================
             Create an instance of the Entities and dress it up
             =====================================================
             */
            let aPark = ParkVisit(context: self.managedObjectContext)
            let aAudio = Audio(context: self.managedObjectContext)
            let aPhoto = Photo(context: self.managedObjectContext)
            
            //set up references
            aPark.audio = aAudio
            aPark.photo = aPhoto
            aAudio.parkVisit = aPark
            aPhoto.parkVisit = aPark
            
            //aAudio.voiceRecording = pstruct.photoAndAudioFilename
            
            aPark.fullName = pstruct.fullName
            aPark.states = pstruct.states
            aPark.dateVisited = pstruct.dateVisited
            aPark.speechToTextNotes = pstruct.speechToTextNotes
            aPark.rating = pstruct.rating
            
            aPhoto.dateTime = pstruct.photoDateTime
            aPhoto.latitude = pstruct.photoLatitude as NSNumber
            aPhoto.longitude = pstruct.photoLongitude as NSNumber
            
            //let aThumbnail = Thumbnail(context: self.managedObjectContext)
            
            // Obtain the URL of the album cover photo filename from main bundle
            let imageUrl = Bundle.main.url(forResource: pstruct.photoAndAudioFilename, withExtension: "jpg", subdirectory: "NationalParkPhotos")
            
            //convert the image to binary data
            do {
                // Try to get the photo image data from imageUrl
                aPhoto.nationalParkPhoto = try Data(contentsOf: imageUrl!, options: NSData.ReadingOptions.mappedIfSafe)
                
            } catch {
                fatalError("Park photo file is not found in the main bundle!")
            }
            
            //convert the audio to binary data
            let audioUrl = Bundle.main.url(forResource: pstruct.photoAndAudioFilename, withExtension: "m4a", subdirectory: "AudioFiles")
            do {
                // Try to get the photo image data from imageUrl
                aAudio.voiceRecording = try Data(contentsOf: audioUrl!, options: NSData.ReadingOptions.mappedIfSafe)
                
            } catch {
                fatalError("Park photo file is not found in the main bundle!")
            }
        }   // End of for loop'
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
    }
}

struct ParksVisited_Previews: PreviewProvider {
    static var previews: some View {
        ParksVisited()
    }
}
