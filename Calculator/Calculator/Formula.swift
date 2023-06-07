//
//  Formula.swift
//  Calculator
//
//  Created by Hyungmin Lee on 2023/06/02.
//
struct Formula<OperandQueue: Queueable, OperatorQueue: Queueable> where OperandQueue.Element == Double, OperatorQueue.Element == Operator {
    var operands: OperandQueue
    var operators: OperatorQueue
    
    mutating func result() -> Double {
        guard var result = operands.dequeue() else { return 0.0 }
        
        while operators.isEmpty == false {
            guard let operand = operands.dequeue() else { break }
            guard let `operator` = operators.dequeue() else { break }
            
            if isDivideZero(operand, `operator`) { return Double.nan }
            
            result = `operator`.calculate(lhs: result, rhs: operand)
        }

        return result
    }
    
    private func isDivideZero(_ operand: Double,_ operator: Operator) -> Bool {
        return operand == 0.0 && `operator` == .divide
    }
}
