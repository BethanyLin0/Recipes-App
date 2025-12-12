//
//  ContentView.swift
//  Ice Cream
//
//  Created by Bethany on 2025/3/5.
//

import SwiftUI

struct Platform: Hashable {
    //defining an interface (entrance for text inputs and images)
    var name: String
    let color: Color
}

struct ContentView: View {
    var platforms: [Platform] = [
        .init(name: "Recipes", color: .black ),
        .init(name: "Calculator", color: .black),
        .init(name: "Budget", color:.black )
    ]
    
    var body: some View {
        NavigationStack{
            List {
                Section("Let's Make Some Ice Cream!") {
                    //ForEach iterates over the platforms array, where each platform has a name and a color.
                    ForEach(platforms, id:\.name) {platform in
                        //This creates a navigation link to navigate to one of the three pages when tapping on an ice cream platform
                        NavigationLink(value: platform){
                            HStack{
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 70))
                                    .foregroundColor(.black)
                                
                                Text(platform.name)
                                    .foregroundColor(platform.color)
                                    . font(.system(size: 70))
                                    .bold()
                            }
                        }
                    }
                    //This displays the home page image
                    Image("Home Page Strawberry Ice Cream")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1300, height:500)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 0.72, green: 0.9, blue: 0.66))
            .navigationDestination(for: Platform.self) { platform in
                //A switch statement is like an advanced if statement
                //All possible outcomes are listed, and one be selected
                switch platform.name {
                case "Recipes":
                    Recipes()
                case "Calculator":
                    Calculator()
                case "Budget":
                    Budget()
                //Validation method: if the selected page doesn't exist, a message "Unknown Page" shows up
                default:
                    Text("Unknown Page")
                }
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    ContentView()
}

