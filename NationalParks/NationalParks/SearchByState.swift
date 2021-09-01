//
//  SearchByState.swift
//  NationalParks
//
//  Created by Ayush Dixit on 4/16/20.
//  Copyright © 2020 Ayush Dixit. All rights reserved.
//

import SwiftUI

struct SearchByState: View {
    
    // Default selected array index numbers
    @State private var selectedStateLabelIndex = 0
    @State private var searchCompleted = false
    
    // Arrays holding constant data
    let usStates = ["Alabama (AL)", "Alaska (AK)", "Arizona (AZ)", "Arkansas (AR)", "California (CA)", "Colorado (CO)", "Connecticut (CT)", "Delaware (DE)", "Florida (FL)", "Georgia (GA)", "Hawaii (HI)", "Idaho (ID)", "Illinois (IL)", "Indiana (IN)", "Iowa (IA)", "Kansas (KS)", "Kentucky (KY)", "Louisiana (LA)", "Maine (ME)", "Maryland (MD)", "Massachusetts (MA)", "Michigan (MI)", "Minnesota (MN)", "Mississippi (MS)", "Missouri (MO)", "Montana (MT)", "Nebraska (NE)", "Nevada (NV)", "New Hampshire (NH)", "New Jersey (NJ)", "New Mexico (NM)", "New York (NY)", "North Carolina (NC)", "North Dakota (ND)", "Ohio (OH)", "Oklahoma (OK)", "Oregon (OR)", "Pennsylvania (PA)", "Rhode Island (RI)", "South Carolina (SC)", "South Dakota (SD)", "Tennessee (TN)", "Texas (TX)", "Utah (UT)", "Vermont (VT)", "Virginia (VA)", "Washington (WA)", "West Virginia (WV)", "Wisconsin (WI)", "Wyoming (WY)"]
    
    var apiQuery = ""
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Select U.S State to Search for National Parks")) {
                    statePicker
                }
                Section(header: Text("Search National Parks in \(usStates[self.selectedStateLabelIndex])")) {
                    HStack {
                        Button(action: {
                            
                            self.searchApi()
                            self.searchCompleted = true
                            
                        }) {
                            Text(self.searchCompleted ? "Search Completed" : "Search")
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 36, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    }   // End of HStack
                }
                if searchCompleted {
                    Section(header: Text("List National Parks in \(self.usStates[self.selectedStateLabelIndex])")) {
                        
                        NavigationLink(destination: showSearchResults.navigationBarTitle(Text("National Parks in \(self.usStates[self.selectedStateLabelIndex])"), displayMode: .inline)
                        .font(.system(size: 14))
                            .font(.headline)) {
                                
                            Image(systemName: "list.bullet")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                        
                    } // End of Section
                }
            }   // End of Form
                .navigationBarTitle(Text("Search National Parks in a State"), displayMode: .inline)
            
            
        }   // End of NavigationView
    }       // End of body
    
    var statePicker: some View {
        Picker(selection: $selectedStateLabelIndex, label: Text("Selected State")) {
            ForEach(0 ..< usStates.count, id: \.self) {
                Text(self.usStates[$0]).tag($0)
            }
        }
    }
    
    
    func searchApi() {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        //        let searchQueryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Replace all occurrences of space within the search query with +
        //        let query = searchQueryTrimmed.replacingOccurrences(of: " ", with: "+")
        
        // Obtain the diet label selected by the user
        let stateLabel = usStates[selectedStateLabelIndex]
        
        // remove parenthesis
        let ar1 = stateLabel.components(separatedBy: "(")
        let ar2 = ar1[1].components(separatedBy: ")")
        let state = ar2[0]
        
        
        // Compose the Edamam API Query URL string
        // Global constants edamamAppID and edamamAppKey are given in EdamamApiData.swift file
        
        
        let ApiSearchQuery = "https://developer.nps.gov/api/v1/parks?stateCode=\(state)&fields=images"
        
        print(ApiSearchQuery)
        // This public function is given in EdamamApiData.swift file
        getDataFromApi(apiQueryUrl: ApiSearchQuery)
    }
    
    var showSearchResults: some View {
        if foundParksList.isEmpty {
            return AnyView(notFoundMessage)
        }
        
        return AnyView(SearchResultsList())
    }
    
    var emptyAlert: Alert {
        Alert(title: Text("The Search Field is Empty!"),
              message: Text("Please enter a search string!"),
              dismissButton: .default(Text("OK")))
    }
    
    var notFoundMessage: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
            Text("No Parks Found!\nPlease enter another search query!")
                .font(.body)    // Needed for the text to wrap around
                .multilineTextAlignment(.center)
        }
    }
}

struct SearchByState_Previews: PreviewProvider {
    static var previews: some View {
        SearchByState()
    }
}
