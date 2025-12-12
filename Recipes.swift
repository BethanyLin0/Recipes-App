//
//  Recipes.swift
//  Ice Cream
//
//  Created by Bethany on 2025/3/5.
//

import SwiftUI
import SwiftData

struct Recipes: View {
    // @Query retrieves all Recipes from database and then sorts them according to "dateCreated" (ordered from new to old)
    @Query(sort: \Recipe.dateCreated, order: .reverse)
    
    //Storing all recipe data in an 1 Dimensional array called Recipe (arrays in Swift are dynamic by default)
    private var allRecipes: [Recipe]
    
    //This controls when the "Add a Recipe" sheet appears. It's hidden at first (and only comes on when a button is pressed, which is coded below)
    //states means that when it's updated, we can take actions with it
    @State private var showSheet = false
    
    //When a recipe needs to be edited
    @State private var recipeToEdit: Recipe?
    
    var body: some View {
        ZStack {
            Color(red: 0.72, green: 0.9, blue: 0.66)
                .ignoresSafeArea()
            VStack {
                Text("Frances' Recipes")
                    .font(.system(size:30))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                
                //Displaying "allRecipes" from the database, in the form of a "list"
                List {
                    Section {
                        //ForEach turns an array of data into multiple views
                        ForEach(allRecipes) {recipe in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(recipe.name)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                Text("Ingredients: \(recipe.ingredients)")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                    .textSelection(.enabled)
                                Text("Last Made: \(recipe.lastMade)")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                //If statement to retrieve link saved earlier (only if the user entered a link)
                                if (!recipe.tutorialLink.isEmpty)
                                {
                                    //turns user input into a link
                                    Link("Link to Tutorial", destination: URL(string: "\(recipe.tutorialLink)")!)
                                        .font(.title2)
                                }
                                else //If user didn't enter a link, this message is displayed
                                {
                                    Text("No link was added")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                }
                                Text("Notes: \(recipe.notes)")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                            //When this section of the list is tapped/clicked, the edit recipe sheet shows up
                            .onTapGesture {
                                recipeToEdit = recipe
                            }
                        }
                        //This calls the deleteRecipe function
                        .onDelete(perform: deleteRecipe)
                    } header: {
                        //Top part of this View
                        HStack{
                            Text("Recipes")
                                .font(.largeTitle)
                            Spacer()
                            // A "+" (plus) button for adding new recipes (by calling out the AddNewRecipe sheet)
                            Button {
                                showSheet = true
                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.largeTitle)
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
            .padding()
            .sheet(isPresented: $showSheet) {
                //This sheet is used to add new recipes (see AddRecipeView below)
                AddRecipeView()
                    .presentationDetents([.medium, .large])
            }
            //This EditRecipeSheet is called when sections of the list is tapped/clicked
            .sheet(item: $recipeToEdit) {
                recipe in EditRecipeSheet(recipe: recipe)
            }
        }
    }
    
    //This is a function for deleting recipes
    private func deleteRecipe(offsets: IndexSet) {
        for index in offsets {
            let recipe = allRecipes[index]
            // SwiftData has built-in modelContext
            if let context = recipe.modelContext {
                context.delete(recipe)
            }
        }
    }
}

//A new view used for the "Add Recipe" sheet, which uses SwiftData
//Following client requirements:
//Texts for name, ingredients, notes, and links to videos/online tutorials

struct AddRecipeView: View {
    //Get SwiftData's Context (used to input new data)
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    //State variables because they store the data and track changes in the data
    @State private var name = ""
    @State private var ingredients = ""
    @State private var lastMade = ""
    @State private var tutorialLink = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            //Creates text boxes for user input
            Form {
                TextField("Name 🍦", text: $name)
                    .font(.title2)
                TextField("Ingredients 🥛", text: $ingredients)
                    .font(.title2)
                TextField("Last Made ⏰", text: $lastMade)
                    .font(.title2)
                TextField("Tutorial Link 🔗",text: $tutorialLink)
                    .font(.title2)
                TextField("Notes 📝", text: $notes)
                    .font(.title2)
                    .lineLimit(10)
            }
            .padding()
            .navigationTitle("Add a Recipe") //Title of this sheet
            .toolbar {
                ToolbarItem() {
                    //"Cancel" button for sheet
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem() {
                    //"Save" button for sheet
                    Button("Save") {
                        addRecipe()
                    }
                    //User can only save a Recipe if the Recipe name text box is NOT empty
                    .disabled(name.isEmpty)
                }
            }
            .background(Color(red: 0.72, green: 0.9, blue: 0.66).edgesIgnoringSafeArea(.all))
        }
    }
    
    //This function saves the inputted data for new recipe
    func addRecipe() {
        let newRecipe = Recipe (
            name: name,
            ingredients: ingredients,
            lastMade: lastMade,
            tutorialLink: tutorialLink,
            notes: notes
        )
        context.insert(newRecipe)
        dismiss()
    }
}


//This sheet is called when the user clicks on the texts of the entered data. It allows the user to edit their responses and automatically saves the new input values to SwiftData.
struct EditRecipeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var recipe: Recipe
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name 🍦", text: $recipe.name)
                    .font(.title2)
                TextField("Ingredients 🥛", text: $recipe.ingredients)
                    .font(.title2)
                TextField("Last Made ⏰", text: $recipe.lastMade)
                    .font(.title2)
                TextField("Tutorial Link 🔗",text: $recipe.tutorialLink)
                    .font(.title2)
                TextField("Notes 📝", text: $recipe.notes)
                    .font(.title2)
                    .lineLimit(10)
            }
            .padding()
            .navigationTitle("Edit Recipe")
            .toolbar {
                ToolbarItem() {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .background(Color(red: 0.72, green: 0.9, blue: 0.66).edgesIgnoringSafeArea(.all))
        }
    }
}


//Allows you to preview the UI while coding
#Preview {
    Recipes()
}
