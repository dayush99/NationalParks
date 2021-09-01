//
//  AddPark.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/18/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI
import CoreData
import Speech
import AVFoundation

fileprivate var idAndFilename = UUID()

struct AddPark: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var parkName = ""
    @State private var stateName = ""
    @State private var visitDate = Date()
    @State private var ratingIndex = 2  // Default: "Average"
    @State var audioSession:   AVAudioSession!
    @State var audioRecorder:  AVAudioRecorder!
    @State private var recordingVoice = false
    @State private var speechToTextRecording = false
    @State private var speechConvertedToText = ""
    @State private var finalfilename = ""
    @State private var filename = ""
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var fillerUrl = URL(string: "")
    @State private var photoTakeOrPickIndex = 0     // Take using camera
    
    let ratingChoices = ["Outstanding", "Excellent", "Great", "Very Good", "Good", "Satisfactory", "Fair", "Poor"]
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
        
        // Set maximum date to 2 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
        return minDate...maxDate
    }
    
    var body: some View {
        Form {
            Section(header: Text("National Park Full Name")) {
                TextField("Enter National Park Full Name", text: $parkName)
            }
            Section(header: Text("National Park State Names")) {
                TextField("Enter National Park State Name", text: $stateName)
            }
            Section(header: Text("Date Visited National Park")) {
                DatePicker(
                    selection: $visitDate,
                    in: dateClosedRange,
                    displayedComponents: .date,
                    label: { Text("Date Visited") }
                )
            }
            Section(header: Text("My Rating of the National Park")) {
                Picker("", selection: $ratingIndex) {
                    ForEach(0 ..< ratingChoices.count, id: \.self) {
                        Text(self.ratingChoices[$0])
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            
            
            Section(header: Text("Take Notes by Recording Your Voice")) {
                Button(action: {
                    self.microphoneTapped()
                }) {
                    microphoneLabel
                }
            }
            
            Section(header: Text("Take Notes by Converting your Speech to Text")) {
                Button(action: {
                    self.speechMicrophoneTapped()
                }) {
                    speechMicrophoneLabel
                }
                .padding()
                Text(speechConvertedToText)
                    .multilineTextAlignment(.center)
                    // This enables the text to wrap around on multiple lines
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            
            Section(header: Text("Add National Park Visit Photo")) {
                VStack {
                    Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                        ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                            Text(self.photoTakeOrPickChoices[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Button(action: {
                        self.showImagePicker = true
                    }) {
                        Text("Get Photo")
                            .padding()
                    }
                }
            }
            Section(header: Text("National Park Visit Photo")) {
                thumbnailImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 100.0)
                Spacer()
            }
            
        }   // End of Form
            .disableAutocorrection(true)
            .autocapitalization(.words)
            .navigationBarTitle(Text("Add National Park"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.saveNewPark()
                    
                 
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
            })
            .sheet(isPresented: self.$showImagePicker) {

                PhotoCaptureView(showImagePicker: self.$showImagePicker,
                                 photoImageData: self.$photoImageData,
                                 cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
        
    }   // End of body
    var microphoneLabel: some View {
        VStack {
            Image(systemName: recordingVoice ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
                .padding()
            Text(recordingVoice ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }
    var speechMicrophoneLabel: some View {
        VStack {
            Image(systemName: speechToTextRecording ? "mic.fill" : "mic.slash.fill")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.blue)
                .padding()
            Text(speechToTextRecording ? "Recording your voice... Tap to Stop!" : "Start Recording!")
                .multilineTextAlignment(.center)
        }
    }
    var thumbnailImage: Image {
        
        if let imageData = self.photoImageData {
            let thumbnail = photoImageFromBinaryData(binaryData: imageData)
            return thumbnail
        } else {
            return Image("DefaultParkPhoto")
        }
    }
    
    func microphoneTapped() {
        if audioRecorder == nil {
            self.recordingVoice = true
            startRecording()
        } else {
            self.recordingVoice = false
            
            finishRecording()
            
        }
        
    }
    func speechMicrophoneTapped() {
        if speechToTextRecording {
            cancelRecording()
            self.speechToTextRecording = false
        } else {
            self.speechToTextRecording = true
            recordAndRecognizeSpeech()
        }
    }
    
    
    

    
    func startRecording() {
        filename = idAndFilename.uuidString + ".m4a"
        let audioFilenameUrl = documentDirectory.appendingPathComponent(filename)
        fillerUrl = audioFilenameUrl
        print(filename)
        print(audioFilenameUrl)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilenameUrl as URL, settings: settings)
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    

    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        self.recordingVoice = false
    }

       func cancelRecording() {
           request.endAudio()
           audioEngine.inputNode.removeTap(onBus: 0)
           audioEngine.stop()
           recognitionTask?.finish()
       }
    
       /*
       ----------------------------------------------
       MARK: - Record Audio and Transcribe it to Text
       ----------------------------------------------
       */
       func recordAndRecognizeSpeech() {

           let node = audioEngine.inputNode
           let recordingFormat = node.outputFormat(forBus: 0)
           node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
               request.append(buffer)
           }
        
           audioEngine.prepare()
          

           do {
               try audioEngine.start()
           } catch {
               print("Unable to start Audio Engine!")
               return
           }

           recognitionTask = speechRecognizer.recognitionTask(with: request, resultHandler: { result, error in
              
               if result != nil {  // check to see if result is empty (i.e. no speech found)
                   if let resultObtained = result {
                       let bestString = resultObtained.bestTranscription.formattedString
                       self.speechConvertedToText = bestString
                       
                   } else if let error = error {
                       print("Transcription failed, but will continue listening and try to transcribe. See \(error)")
                   }
               }
           })
       }
    
    /*
     ---------------------
     MARK: - Save New Park
     ---------------------
     */

    func saveNewPark() {
        
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Obtain DatePicker's selected date, format it as yyyy-MM-dd, and convert it to String
        let releaseDateString = dateFormatter.string(from: self.visitDate)
        
        
        let newPark = ParkVisit(context: self.managedObjectContext)
        let newAudio = Audio(context: self.managedObjectContext)
        let newPhoto = Photo(context: self.managedObjectContext)
        
        newPark.audio = newAudio
        newPark.photo = newPhoto
        newAudio.parkVisit = newPark
        newPhoto.parkVisit = newPark
        
        
        newPark.fullName = self.parkName
        newPark.states = self.stateName
        newPark.speechToTextNotes = self.speechConvertedToText
        newPark.dateVisited = releaseDateString
        newPark.rating = self.ratingChoices[ratingIndex]
        
        
        let currentDateString = dateFormatter.string(from: Date())
        newPhoto.dateTime = currentDateString
        
        let currLocation = currentLocation()
        newPhoto.latitude = currLocation.latitude as NSNumber
        newPhoto.longitude = currLocation.longitude as NSNumber
        
      
         if let imageData = self.photoImageData  {

            newPhoto.nationalParkPhoto = imageData

        }
            
         else {
            let imageUrl = Bundle.main.url(forResource: self.filename, withExtension: "jpg", subdirectory: "NationalParkPhotos")

        do {
            // Try to get the photo image data from imageUrl
            newPhoto.nationalParkPhoto = try Data(contentsOf: imageUrl!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            fatalError("Album cover photo file is not found in the main bundle!")
        }
        }
        
        
        
        //convert the audio to binary data
        //let audioUrl = Bundle.main.url(forResource: self.filename, withExtension: "m4a", subdirectory: "AudioFiles")
        do {
            // Try to get the photo image data from imageUrl
            newAudio.voiceRecording = try Data(contentsOf: fillerUrl!, options: NSData.ReadingOptions.mappedIfSafe)
            
        } catch {
            fatalError("Audio file is not found in the main bundle!")
        }
        
        
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
        
    }
}
