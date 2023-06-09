//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentOperatorLabel: UILabel!
    @IBOutlet weak var currentOperandLabel: UILabel!
    @IBOutlet weak var calculationFormulaStackView: UIStackView!
    
    private var isPrevResult = false
    private var inputFormula = ""
    private let initialNumber = 0
    private var isFirstArithmeticFormula: Bool {
        return calculationFormulaStackView.subviews.count == 0
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let insertedNumber = sender.currentTitle else { return }
        
        if isPrevResult {
            currentOperandLabel.text = "\(initialNumber)"
            isPrevResult = false
        }
        
        let currentOperand = currentOperandLabel.text ?? "\(initialNumber)"
        let isAppendedOperand = (Int(currentOperand) == initialNumber) && (insertedNumber != ".")
        
        currentOperandLabel.text = isAppendedOperand ? insertedNumber : currentOperand + insertedNumber
    }
    
    @IBAction func didTappedMenus(_ sender: UIButton) {
        guard let insertedMenu = sender.currentTitle,
                let menu = Menus(rawValue: insertedMenu) else { return }
        
        switch menu {
        case .allClear:
            clearCalculationFormulaStackView()
            inputFormula = ""
            currentOperatorLabel.text = ""
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
        guard var currentOperand = Double(currentOperandString) else { return }

        currentOperand = -currentOperand
        currentOperandLabel.text = "\(currentOperand)"
    }
    
    private func calculateResult() -> String? {
        var formula = ExpressionParser<CalculatorItemQueue, CalculatorItemQueue>.parse(from: inputFormula)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 20
        
        guard let result = numberFormatter.string(from: formula.result() as NSNumber) else { return nil }
        
        return result
    }
    
    private func addInputFormula() {
        inputFormula += currentOperatorLabel.text ?? ""
        inputFormula += currentOperandLabel.text ?? ""
    }
}

// MARK: - UI Method
extension CalculatorViewController {
    private func addArithmetic() {
        addFormulaStackView()
        addInputFormula()
        scrollView.scrollToBottom(animated: true)
    }
    
    private func addFormulaStackView(){
        let arithmeticStackView = ArithmeticStackView(currentOperatorLabel.text, currentOperandLabel.text)
        
        calculationFormulaStackView.addArrangedSubview(arithmeticStackView)
        scrollView.layoutIfNeeded()
    }
    
    private func clearCalculationFormulaStackView() {
        calculationFormulaStackView.subviews.forEach { $0.removeFromSuperview() }
    }
}
