//
//  Calculator.swift
//  Ice Cream
//
//  Created by Bethany on 2025/3/5.
//

import SwiftUI

//"Enum" is short for enumeration. It defines a common type for a group of related values and enables developers to establish a collection of named constants, known as enumerators, each linked with an integer value.
enum CalcButton: String {
    case one = "1", two = "2", three = "3"
    case four = "4", five = "5", six = "6"
    case seven = "7", eight = "8", nine = "9"
    case zero = "0", add = "+", subtract = "–"
    case divide = "÷", multiply = "×", equal = "="
    case clear = "AC"
    
    //Switch statement is used to assign colors to buttons of the same type at once (e.g. operators, equal sign, single digits (0-9), and the All Clear sign)
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return Color(red: 0.04, green: 0.43, blue: 0.25)
        case .clear:
            return Color(.lightGray)
        default:
            return Color(.darkGray)
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, equal, none
}


//Calculator View
struct Calculator: View {
    
    //State allows you to make a variable that can be automatically changed and updated
    //"0" is the initial/default value displayed on the calculator
    @State var value = "0"
    
    //When an operation button is pressed, output value automatically displays a 0, for user to input another number
    @State var runningNumber = 0
    
    //This variable tracks the current mathematical operation
    @State var currentOperation: Operation = .none
    
    //Creating a 2-Dimensional array called CalcButton to store all buttons on the calculator
    let buttons: [[CalcButton]] = [
        [.add, .subtract, .multiply, .divide],
        [.seven, .eight, .nine, .zero],
        [.four, .five, .six, .clear],
        [.one, .two, .three, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.72, green: 0.9, blue: 0.66)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                //Text display
                HStack{
                    Spacer()
                    Text(value)
                        .font(.system(size: 120))
                        .foregroundColor(.white)
                }
                .padding()
                
                //Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack (spacing: 15) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                //connects to calculateIt function, called when user taps on buttons
                                self.calculateIt(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size:70))
                                    .frame(width:140, height: 140)
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(80)
                            })
                        }
                    }
                }
            }
            .padding(.bottom, 3)
        }
    }
    
    //Function for what to do when a button is tapped/clicked
    func calculateIt(button: CalcButton){
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            //If statement to determine which operator was tapped/clicked
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Int(self.value) ?? 0 //"?? makes it optional"
            }
            else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Int(self.value) ?? 0
            }
            else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Int(self.value) ?? 0
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Int(self.value) ?? 0
            }
            else if button == .equal {
                let runningValue = runningNumber
                let currentValue = Int(self.value) ?? 0
                switch currentOperation {
                case .add: value = "\(runningValue + currentValue)"
                case .subtract: value = "\(runningValue - currentValue)"
                case .multiply: value = "\(runningValue * currentValue)"
                case .divide: value = "\(runningValue / currentValue)"
                case .equal, .none:
                    break
                }
            }
            //If button pressed is not equal, the calculator automatically resets to display a "0" for a new entry (e.g. after an add, subtract, multiply, or divide button is tapped, the calculator resets to 0 for a new number to be entered)
            if button != .equal {
                value = "0"
            }
            //This sets the value displayed on the calculator (value) to "0", effectively clearing the current input or calculation.
        case .clear:
            value = "0"
            //If the tapped button does not match the conditions above (not equal to .equal or .clear), this block is executed. It takes the number from the button.rawValue. If the current value displayed on the calculator is "0", it replaces it with the number. If the current value is not "0", the number is appended to the existing value. This ensures that numbers are concatenated correctly when the user enters multiple digits.
        default:
            let number = button.rawValue
            if self.value == "0"
            {
                value = number
            }
            else
            {
                //Adding the digits
                value += number
            }
        }
    }
}

#Preview {
    Calculator()
}
