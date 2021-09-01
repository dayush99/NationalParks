//
//  SpeechToTextData.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/14/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Speech
import SwiftUI
import AVFoundation
import CoreLocation
 

// Global Constants
let audioEngine = AVAudioEngine()
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

let request = SFSpeechAudioBufferRecognitionRequest()

/*

 Set up Speech Recognizer object with selected language as English U.S. dialect.

 You can select one of more than 50 languages and dialects for speech recognition.

 Some of the English language dialects:

   English (Australia):         en-AU

   English (Ireland):           en-IE

   English (South Africa):      en-ZA

   English (United Kingdom):    en-GB

   English (United States):     en-US

 */

let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!

 

// Global Variable

var recognitionTask: SFSpeechRecognitionTask?

 

/*

 Built-in speech transcription system allows conversion of any audio recording into a text stream.

 Add a key to Info.plist called "Privacy - Speech Recognition Usage Description" with String value

 describing what you intend to do with the transcriptions.

 */
var audioSession:   AVAudioSession!

public func getPermissionForSpeechRecognition() {

    SFSpeechRecognizer.requestAuthorization { authStatus in

        DispatchQueue.main.async {

           

            if authStatus == .authorized {

                // The value is recorded in the Settings app

            } else {

                // The value is recorded in the Settings app

            }

        }

    }

}
public func getPermissionForVoiceRecording() {

   

    // Create the shared audio session instance

    audioSession = AVAudioSession.sharedInstance()

   

    do {

        // Set audio session category to record and play back audio

        try audioSession.setCategory(.playAndRecord, mode: .default)

       

        // Activate the audio session

        try audioSession.setActive(true)

       

        // Request permission to record user's voice

        audioSession.requestRecordPermission() { allowed in

            DispatchQueue.main.async {

                if allowed {

                    // Permission is recorded in the Settings app on user's device

                } else {

                    // Permission is recorded in the Settings app on user's device

                }

            }

        }

    } catch {

        print("Setting category or getting permission failed!")

    }

}
