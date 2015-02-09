//
//  ViewController.swift
//  CarpimTablosu
//
//  Created by Haydar Kulekci on 08/02/15.
//  Copyright (c) 2015 Haydar Kulekci. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    // Settings View Controls
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var operatorTextField: UITextField!
    @IBOutlet weak var maximumNumberTextField: UITextField!
    @IBOutlet weak var operatorSelect: UIPickerView! = UIPickerView()
    var operators = ["+", "x"] // , "-", "/"
    
    
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var resultLabel: UITextField!
    
    var maximumNumber: Int = 0
    var currentOperator: String? = ""
    var first_number: Int = 0
    var second_number: Int = 0
    var calculation_result:Double = 0.0
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBAction func next(sender: AnyObject) {
        resultTextField.text = "________"
        text.text = carpim_bul()
    }
    @IBAction func openSettings(sender: AnyObject) {
        settingsView.hidden = false
        resultTextField.resignFirstResponder()
    }
    
    @IBAction func saveSettings(sender: AnyObject) {
        
        var error:Bool = true
        
        switch operatorTextField.text {
            case "+":
                currentOperator = "+"
            case "-":
                currentOperator = "-"
            case "x":
                currentOperator = "x"
            case "/":
                currentOperator = "/"
            default:
                currentOperator = nil
        }

        if (currentOperator == nil) {
            operatorTextField.text = defaults.stringForKey("currentOperator")
            return
        }

        var savedNumber:Int? = maximumNumberTextField.text.toInt()
        
        if (savedNumber == nil) {
            maximumNumberTextField.text = String(defaults.integerForKey("maximumNumber"))
            return
        } else {
            maximumNumber = savedNumber!
        }

        defaults.setInteger(maximumNumberTextField.text.toInt()!, forKey: "maximumNumber")
        defaults.setValue(operatorTextField.text, forKey: "currentOperator")
            
        settingsView.hidden = true
        maximumNumberTextField.resignFirstResponder()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTextField.delegate = self
        operatorTextField.delegate = self
        operatorSelect.delegate = self
        settingsView.hidden = true
        operatorSelect.hidden = true
        operatorTextField.inputView = operatorSelect
        
        maximumNumber = defaults.integerForKey("maximumNumber")
        if maximumNumber == 0 {
            maximumNumber = 9
            defaults.setInteger(maximumNumber, forKey: "maximumNumber")
        }
        maximumNumberTextField.text = String(maximumNumber)
        
        currentOperator = defaults.valueForKey("currentOperator")?.string
        if (currentOperator == nil) {
            currentOperator = "x"
            defaults.setValue(currentOperator, forKey: "currentOperator")
        }
        operatorTextField.text = currentOperator
        
        resultTextField.text = "________"
        text.text = carpim_bul()
        text.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carpim_bul() -> String {

        first_number = Int(arc4random_uniform(UInt32(maximumNumber))) + 1
        second_number = Int(arc4random_uniform(UInt32(9))) + 1
        
        calculation_result = 0
        let str:String = currentOperator as String!
        switch str {
            case "+":
                calculation_result = Double(first_number + second_number)
            case "-":
                calculation_result = Double(first_number - second_number)
            case "x":
                calculation_result = Double(first_number * second_number)
            case "/":
                calculation_result = Double(first_number / second_number)
            default:
                calculation_result = 0.0
            
        }
        
        // println("Sonuç : \(calculation_result)")
        
        return "\(first_number) \(String(currentOperator!)) \(second_number) = ?"
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textField == operatorTextField) {
            operatorSelect.hidden = false
            return false
        } else if (textField == resultTextField) {
            textField.text = ""
        }
        operatorSelect.hidden = true
        return true
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var current_text = "\(resultTextField.text)\(string)"
        println("Replacement : \(current_text)")
        var double_value:Double = (current_text as NSString).doubleValue
        println("Integer Result : \(double_value)")
        
        if (calculation_result == double_value) {
            
            resultLabel.text = "Correct!"
            
            var delta: Int64 = 1 * Int64(NSEC_PER_SEC)
            
            var time = dispatch_time(DISPATCH_TIME_NOW, delta)
            
            dispatch_after(time, dispatch_get_main_queue(), {
                self.resultTextField.text = "________"
                self.text.text = self.carpim_bul()
                self.resultTextField.resignFirstResponder()
                self.resultLabel.text = ""
            });
            
            
        } else {
            resultLabel.text = ""
        }
        
        return true
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return operators.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return operators[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        operatorTextField.text = operators[row]
        operatorSelect.hidden = true
    }


}

