//
//  NumberFormatter +.swift
//  Calculator
//
//  Created by Hyungmin Lee on 2023/06/13.
//

import Foundation

extension NumberFormatter {
    func convertToFormatterString(string: String) -> String {
        let formatterNumber = self.number(from: string) ?? 0 as NSNumber
        let formatterString = self.string(from: formatterNumber) ?? ""
        
        return formatterString
    }
}
