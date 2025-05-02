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
    
    func asyncExample() {
        for i in 0...10 {
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    print("print1", i)
                }
                print("print2", i)
            }
        }
    }
    
    /*
     //Deadlock
    func deadlockExample() {
        print("1")
        DispatchQueue.main.async {
            print("2")
            DispatchQueue.main.sync {
                print("3")
            }
            print("4")
        }
        print("5")
    } */
    
    func heavyCalculation() {
        Thread.sleep(forTimeInterval: 5)
    }
    
}
