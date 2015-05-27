//
//  ViewController.swift
//  Calculator
//
//  Created by Liam Hamill on 31/03/2015.
//  Copyright (c) 2015 Liam Hamill. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var isTyping: Bool = false
    let pi = 22.0/7
    
    let defaultDisplay = "0"
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if isTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            isTyping = true
        }
    }
    
    @IBAction func displayPi(sender: UIButton) {
        
        enter()
        isTyping = true
        display.text = "\(pi)"
        
        return
    }
    
    private func clear() {
        display.text = defaultDisplay
        brain.emptyStack()
        isTyping = false
    }
    

    @IBAction func clearB(sender: UIButton) {
        clear()
    }
    
    @IBAction func deleteButton() {
        let len = count(display.text!)
        let reset = len <= 1
        
        if reset {
            clear()
            return
        } else {
            let index: String.Index = advance(display.text!.startIndex, len - 1)
            display.text = display.text!.substringToIndex(index)
        }
    }
    
    
    @IBAction func period(sender: UIButton) {
        let period = sender.currentTitle!
        
        for char in display.text! {
            if char == "." { return }
        }
        
        if isTyping {
            display.text! += period
        } else {
            display.text = "0" + period
            isTyping = true
        }
        
    }
    
    @IBAction func enter() {
        
        isTyping = false
        
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        }
    }
    
    var displayValue: Double? {
        get {
            if let returnVal = display.text {
                
                return (returnVal as NSString).doubleValue
                
            } else {
                clear()
                return nil }
        }
        
        set {
            if floor(newValue!) == newValue! {
                display.text = "\(Int(newValue!))"
            } else {
                display.text = "\(newValue!)"
            }
        }
    }
    @IBAction func operate(sender: UIButton) {
        
        let opSymbol = sender.currentTitle!
        
        if isTyping {
            enter()
        }
        
        if let output = brain.performOperation(opSymbol) {
            displayValue = output
        }
        
        
    }
    
}

