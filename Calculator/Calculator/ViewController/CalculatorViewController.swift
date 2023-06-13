//
//  Calculator - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

let initialNumber = 0
let maximumPointDigits = 5
let maximumOperandDigits = 20

final class CalculatorViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentOperatorLabel: UILabel!
    @IBOutlet weak var currentOperandLabel: UILabel!
    @IBOutlet weak var calculationFormulaStackView: UIStackView!
    @IBOutlet weak var calculateButton: UIButton!
    
    private let numberFormatter = NumberFormatter()
    private var isPrevResult = false
    private var inputFormula = ""
    private lazy var operandFormatter = OperandFormatter(numberFormatter)
    private var isFirstArithmeticFormula: Bool {
        return calculationFormulaStackView.subviews.count == 0
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maximumPointDigits
        calculateButton.isEnabled = false
    }
}

// MARK: - Button Action
extension CalculatorViewController {
    @IBAction func didTappedOperators(_ sender: UIButton) {
        guard currentOperandLabel.text != "\(initialNumber)", isPrevResult == false else {
            currentOperatorLabel.text = isFirstArithmeticFormula ? "" : sender.currentTitle
            return
        }
        
        addArithmetic()
        currentOperatorLabel.text = sender.currentTitle
        currentOperandLabel.text = "\(initialNumber)"
        calculateButton.isEnabled = true
    }
    
    @IBAction func didTappedCalculate(_ sender: UIButton) {
        guard isPrevResult == false else { return }
        
        addArithmetic()
        
        guard let result = calculateResult() else { return }
        
        currentOperatorLabel.text = ""
        currentOperandLabel.text = "\(result)"
        isPrevResult = true
    }
    
    @IBAction func didTappedNumbers(_ sender: UIButton) {
        guard var currentOperand = currentOperandLabel.text?.replacingOccurrences(of: ",", with: ""), let insertedNumber = sender.currentTitle else { return }
        
        if isPrevResult {
            currentOperand = "\(initialNumber)"
            isPrevResult = false
            clearFormula()
        }
        
        guard let operandText = operandFormatter.setUpInputOperandText(currentOperand, insertedNumber) else { return }
        
        currentOperandLabel.text = operandText
    }
    
    @IBAction func didTappedMenus(_ sender: UIButton) {
        guard let insertedMenu = sender.currentTitle,
                let menu = Menus(rawValue: insertedMenu) else { return }
        
        switch menu {
        case .allClear:
            clearFormula()
            fallthrough
            
        case .clearElement:
            currentOperandLabel.text = "\(initialNumber)"
            
        case .changeSign:
            changeOperandSign()
        }
    }
}

// MARK: - Calculate Method
extension CalculatorViewController {
    private func changeOperandSign() {
        guard let currentOperandString = currentOperandLabel.text,
              Int(currentOperandString) != initialNumber else { return }
        
        let isNegativeNumber = currentOperandString.hasPrefix("-")
        
        currentOperandLabel.text = isNegativeNumber ? String(currentOperandString.dropFirst()) : "-\(currentOperandString)"
    }
    
    private func calculateResult() -> String? {
        var formula = ExpressionParser<CalculatorItemQueue, CalculatorItemQueue>.parse(from: inputFormula)
        
        guard let result = numberFormatter.string(from: formula.result() as NSNumber) else { return nil }
        
        return result
    }
    
    private func addInputFormula(_ currentOperandString: String?) {
        inputFormula += currentOperatorLabel.text ?? ""
        inputFormula += currentOperandString ?? ""
    }

    private func clearFormula() {
        clearCalculationFormulaStackView()
        inputFormula = ""
        currentOperatorLabel.text = ""
        calculateButton.isEnabled = false
    }
}

// MARK: - UI Method
extension CalculatorViewController {
    private func addArithmetic() {
        let operand = operandFormatter.makeRefinementArithmeticOperand(currentOperandLabel.text)
        let operndAsFormatterString = numberFormatter.convertToFormatterString(string: operand ?? "")
        
        addFormulaStackView(operndAsFormatterString)
        addInputFormula(operand)
        scrollView.scrollToBottom(animated: true)
    }
    
    private func addFormulaStackView(_ currentOperandString: String?){
        let arithmeticStackView = ArithmeticStackView(currentOperatorLabel.text, currentOperandString)
        
        calculationFormulaStackView.addArrangedSubview(arithmeticStackView)
        scrollView.layoutIfNeeded()
    }
    
    private func clearCalculationFormulaStackView() {
        calculationFormulaStackView.subviews.forEach { $0.removeFromSuperview() }
    }
}
