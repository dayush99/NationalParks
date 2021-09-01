//
//  UserData.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/12/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {

    /*

     -------------------------------

     MARK: - Slide Show Declarations

     -------------------------------

     */

    let numberOfImagesInSlideShow = 9

    var counter = 0
    @Published var savedInDatabase =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    /*

     Create a Timer using initializer () and store its object reference into slideShowTimer.

     A Timer() object invokes a method after a certain time interval has elapsed.

     */

    var slideShowTimer = Timer()


   

    // Publish imageNumber to refresh the View body in Home.swift when it is changed in the slide show

    @Published var imageNumber = 0

   

    public func startTimer() {

        // Stop timer if running

        stopTimer()

        slideShowTimer = Timer.scheduledTimer(timeInterval: 3,

                             target: self,

                             selector: (#selector(fireTimer)),

                             userInfo: nil,

                             repeats: true)

    }

 

    public func stopTimer() {

        counter = 0

        slideShowTimer.invalidate()

    }

   

    @objc func fireTimer() {

        counter += 1

        if counter == numberOfImagesInSlideShow {

            counter = 0

        }

        /*

         Each time imageNumber is changed here, the View body in Home.swift will be re-rendered to

         reflect the change since it subscribes to changes in imageNumber as specified above.

         */

        imageNumber = counter

    }

 

}
