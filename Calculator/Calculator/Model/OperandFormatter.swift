//
//  OperandFormatter.swift
//  Calculator
//
//  Created by Hyungmin Lee on 2023/06/13.
//

import Foundation

struct OperandFormatter {
    private let numberFormatter: NumberFormatter
    
    init(_ numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
    }
    
    func setUpChangedOperandText(_ currentOperand: String, _ insertedNumber: String) -> String? {
        guard checkOverMaximumDigits(currentOperand, insertedNumber) == false,
              checkOverMaximumPointDigits(currentOperand, insertedNumber) == false else { return nil }
        
        return setUpOperandFormatText(currentOperand, insertedNumber)
    }
    
    private func setUpOperandFormatText(_ currentOperand: String, _ insertedNumber: String) -> String? {
        let isSubstitutionOperand = (Int(currentOperand) == initialNumber) && (insertedNumber != ".")
        
        if isSubstitutionOperand {
            return "\(Int(insertedNumber) ?? initialNumber)"
        }
        
        if insertedNumber == "." {
            let operandAsFormatter = numberFormatter.convertToFormatterString(string: currentOperand)
            
            return currentOperand.contains(".") ? operandAsFormatter : operandAsFormatter + "."
        }
        
        if currentOperand.contains(".") && Double(insertedNumber) == 0.0 {
            let operand = currentOperand.components(separatedBy: ".")
            let operandAsFormatter = numberFormatter.convertToFormatterString(string: operand.first ?? "")
            let operandPointNumber = operand.last ?? ""
            
            return operandAsFormatter + "." + operandPointNumber + insertedNumber
        }
        
        return numberFormatter.convertToFormatterString(string: currentOperand + insertedNumber)
    }
}

// MARK: - Check Numbers
extension OperandFormatter {
    private func checkOverMaximumDigits(_ currentOperand: String, _ insertedNumber: String) -> Bool {
        let operand = currentOperand.replacingOccurrences(of: ".", with: "")
        let appendedOperandCount = (operand + insertedNumber).count
        
        return appendedOperandCount > maximumOperandDigits
    }
    
    private func checkOverMaximumPointDigits(_ currentOperand: String, _ insertedNumber: String) -> Bool {
        guard currentOperand.contains(".") else { return false }
        guard let pointNumber = currentOperand.components(separatedBy: ".").last else { return false }
        
        let appendedPointNumber = (pointNumber + insertedNumber).count
        
        return appendedPointNumber > maximumPointDigits
    }
}
