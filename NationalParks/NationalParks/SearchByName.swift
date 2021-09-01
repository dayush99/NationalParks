//
//  SearchByName.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/18/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI

struct SearchByName: View {
    
    
    
    @State private var searchTextFieldValue = ""
    
    @State private var searchStringEntered = ""
    
    
    @State var selectedSearchCategory = 1
    
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header:
                    Text("Enter national park full name to search for")
                    
                ) {
                    
                    HStack {
                        
                        /*
                         
                         🔴 When the user enters a character in the TextField,
                         
                         searchTextFieldValue changes upon which the body View is refreshed.
                         
                         When the user hits Return on keyboard, the entire search string is
                         
                         put into searchStringEntered upon which the body View is refreshed.
                         
                         */
                        TextField("Enter National Park Full Name", text: $searchTextFieldValue,
                                  
                                  onCommit: {
                                    
                                    // Record entered value after Return key is pressed
                                    self.searchStringEntered = self.searchTextFieldValue
                                    
                        }
                            
                        )   // End of TextField
                            
                            
                            
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                        
                        
                        
                        // Button to clear the text field
                        Button(action: {
                            
                            self.searchTextFieldValue = ""
                            
                            self.searchStringEntered = ""
                            
                        }) {
                            
                            Image(systemName: "multiply.circle")
                                
                                .imageScale(.medium)
                                
                                .font(Font.title.weight(.regular))
                            
                        }
                        
                    }   // End of HStack
                    
                }   // End of Section
                
                
                
                // Show this section only after Return key is pressed
                if !searchStringEntered.isEmpty {
                    Section(header: Text("List Details of " + searchStringEntered)) {
                        NavigationLink(destination: searchName) {
                            Image(systemName: "list.bullet")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            
                        }
                        
                    }
                    
                }
                
            }   // End of Form
                
                .navigationBarTitle(Text("Search a National Park"), displayMode: .inline)
            
            
            
        }   // End of NavigationView
        
    }
    
    
    
    var searchName: some View {
        
        getParkDataFromApi(search: searchStringEntered)
        return AnyView(FoundPark(park: currPark))
        
    }
    
}
