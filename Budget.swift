//
//  Budget.swift
//  Ice Cream
//
//  Created by Bethany on 2025/3/5.
//

import SwiftUI
import SwiftData

struct Budget: View {
    // 1) Reads data from "Expense" database
    // "@Query" is used to retrieve data from database
    @Query(sort: \Expense.dateCreated, order: .reverse)
    private var expenses: [Expense]
    
    // 2) Controls when an "Add Expense" sheet pops out
    @State private var showSheet = false
    
    // 3) Calculates the total of all expenses
    private var totalSaving: Double {
        expenses.reduce(0) {$0 + $1.cost}
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.72, green: 0.9, blue: 0.66)
                .ignoresSafeArea ()
            VStack {
                Text("Frances' Budget")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black)
                
                //Display total expenses
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width:600,height:80)
                        .cornerRadius(8)
                    Text ("Total Saving: $\(totalSaving, specifier:"%.2f")")
                        .bold()
                        .foregroundColor(Color.white)
                        .font(.system(size:30))
                }
                .padding(.bottom, 8)
                
                // List out all expenses
                List {
                    Section {
                        ForEach(expenses) { exp in
                            HStack {
                                Text(exp.name)
                                    .font(.title)
                                Spacer()
                                Text("$\(exp.cost,specifier:"%.2f")")
                                    .font(.title)
                            }
                        }
                        .onDelete(perform: deleteExpense)
                    } header: {
                        //Top part
                        HStack{
                            Text("Expenses/Income")
                                .font(.largeTitle)
                            Spacer()
                            // A "+" (plus) button for adding new expenses
                            Button {
                                showSheet = true
                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.largeTitle)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .sheet(isPresented:$showSheet){
                    AddExpensesView()
                        .presentationDetents([.medium, .large])
                }
            }
            .padding()
        }
    }
    
    //Function for deleting an "Expense/income"
    private func deleteExpense(offsets: IndexSet) {
        for index in offsets {
            let exp = expenses[index]
            if let ctx = exp.modelContext {
                ctx.delete(exp)
            }
        }
    }
}

//This view is for adding new expenses/income
struct AddExpensesView: View {
    //get SwiftData's context
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var costString = ""
    @State private var selectedCategory = "Expense"

    
    var body: some View {
        NavigationStack {
            Form {
                //This allows the user to choose between Expense and Income
                Picker("Category", selection: $selectedCategory) {
                    Text("Expense").tag("Expense")
                    Text("Income").tag("Income")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                //This asks for user input on the name and amount of the expense/income
                TextField("\(selectedCategory) Name", text: $name)
                TextField("Amount", text: $costString)
            }
            .padding()
            .navigationTitle("Add \(selectedCategory)") //Title of this sheet (changes according to expense/income)
            .toolbar {
                ToolbarItem() {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem() {
                    Button("Save") {
                        saveExpense()
                    }
                    .disabled(name.isEmpty || costString.isEmpty)
                }
            }
        }
        .background(Color(red: 0.72, green: 0.9, blue: 0.66).edgesIgnoringSafeArea(.all))
    }
    
    //Function for saving the "Expense" inputted
    private func saveExpense() {
        //if "Expense" was selected, the inputted amount would become negative (subtracted from the total savings), after first changing costString from a string into a double
        if selectedCategory == "Expense" {
            let costValue = (Double(costString) ?? 0.0) * -1
            let newExp = Expense(name: name, cost: costValue)
            context.insert(newExp)
        }
        else //in this case, if "Income" was selected costString is simply turned from a String into a Double
        {
            let costValue = Double(costString) ?? 0.0
            let newExp = Expense(name: name, cost: costValue)
            context.insert(newExp)
        }
        dismiss()
        
    }
}


#Preview {
    //Budget()
    AddExpensesView()
}
