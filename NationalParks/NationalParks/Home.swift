//
//  Home.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/15/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI

// List of Parks
let parkText = ["Bryce Canyon National Park, Utah","Glacier National Park, Montana","Grand Canyon National Park, Arizona","Grand Teton National Park, Wyoming","Great Smoky Mountains National Park, North Carolina and Tennessee","Olympic National Park, Washington","Rocky Mountain National Park, Colorado","Yellowstone National Park, Idaho, Montana, and Wyoming","Yosemite National Park, California"]
 
struct Home: View {
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
    
    var body: some View {
 
        NavigationView {
            ZStack(alignment: .center){
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                VStack {
                    Image("Welcome")
                   
                    Image("photo\(userData.imageNumber + 1)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width - 10)
                        .padding(.top, 30)
                        .padding(.bottom, 5)
                    
                    Text("\(parkText[userData.imageNumber])")
                    .bold().multilineTextAlignment(.center)
                   
                    HStack {
                        Button(action: {    // Button 1
                            self.userData.imageNumber = 0
                        }) {
                            self.imageForButton(buttonNumber: 0)
                            }
                        Button(action: {    // Button 2
                            self.userData.imageNumber = 1
                        }) {
                            self.imageForButton(buttonNumber: 1)
                            }
                        Button(action: {    // Button 3
                            self.userData.imageNumber = 2
                        }) {
                            self.imageForButton(buttonNumber: 2)
                            }
                        Button(action: {    // Button 4
                            self.userData.imageNumber = 3
                        }) {
                            self.imageForButton(buttonNumber: 3)
                            }
                        Button(action: {    // Button 5
                            self.userData.imageNumber = 4
                        }) {
                            self.imageForButton(buttonNumber: 4)
                            }
                        Button(action: {    // Button 6
                            self.userData.imageNumber = 5
                        }) {
                            self.imageForButton(buttonNumber: 5)
                            }
                        Button(action: {    // Button 7
                            self.userData.imageNumber = 6
                        }) {
                            self.imageForButton(buttonNumber: 6)
                            }
                        Button(action: {    // Button 8
                            self.userData.imageNumber = 7
                        }) {
                            self.imageForButton(buttonNumber: 7)
                            }
                        Button(action: {    // Button 9
                            self.userData.imageNumber = 8
                        }) {
                            self.imageForButton(buttonNumber: 8)
                            }
                       
                    }   // End of HStack
                    .imageScale(.medium)
                    .font(Font.title.weight(.regular))
                   
                    Spacer()
                    
                    Text("Powered By:").bold()
                    
                    NavigationLink(destination:
                        WebView(url: "https://www.nps.gov/subjects/developer/index.htm")
                            .navigationBarTitle(Text("National Park Service API"), displayMode: .inline) )
                        {
                            Text("National Park Service API")
                            .bold()
                        }

                    Spacer()
                   
                }   // End of VStack
                .onAppear() {
                    self.userData.startTimer()
                }
                .onDisappear() {
                    self.userData.stopTimer()
                }
               
            }   // End of ZStack
           
        }   // End of NavigationView
       
    }
   
    func imageForButton(buttonNumber: Int) -> Image {
   
        if self.userData.imageNumber == buttonNumber {
            return Image(systemName: "\(buttonNumber+1).circle.fill")
        } else {
            return Image(systemName: "\(buttonNumber+1).circle")
        }
    }
   
}
 
 
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
