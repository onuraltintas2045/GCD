//
//  GCDViewModel.swift
//  GCD
//
//  Created by Onur Altintas on 30.04.2025.
//

import Foundation

final class GCDViewModel {
    
    weak var delegate: GCDViewModelDelegate?
    
    func heavyCalculationStart() {
        DispatchQueue.global().async {
            self.heavyCalculation()
            
            DispatchQueue.main.async {
                self.delegate?.heavyCalculateDidFinish()
            }
        }
    }
    
    func heavyCalculation() {
        Thread.sleep(forTimeInterval: 5)
    }
    
}
