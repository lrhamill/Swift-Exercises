//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Liam Hamill on 21/05/2015.
//  Copyright (c) 2015 Liam Hamill. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let val):
                    return "\(val)"
                case .UnaryOperation(let op, _):
                    return "\(op)"
                case .BinaryOperation(let op, _):
                    return "\(op)"
                }
            }
        }
    }

    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    private var variableValues = [String: Double]()
    
    init() {
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        
    }
    
    func pushVar(symbol: String) -> Double? {
        if let value = variableValues[symbol] {
            return pushOperand(value)
        } else {
            return nil
        }
        
            
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluateStack()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            return evaluateStack()
        }
        
        return nil
    }
    
    func emptyStack() {
        opStack = [Op]()
        return
    }
    
    private func recEvaluate(ops: [Op]) -> (result: Double?, remainingOps:  [Op]) {
        if !ops.isEmpty {
            
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = recEvaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = recEvaluate(remainingOps)
                if let op1 = op1Evaluation.result {
                    let op2Evaluation = recEvaluate(op1Evaluation.remainingOps)
                    if let op2 = op2Evaluation.result {
                        return (operation(op1, op2), op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        
        return (nil, ops)
    }
    
    private func evaluateStack() -> Double? {
        let (result, _) = recEvaluate(opStack)
        return result
        
    }
    
}