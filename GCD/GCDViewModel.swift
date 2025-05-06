//
//  GCDViewModel.swift
//  GCD
//
//  Created by Onur Altintas on 30.04.2025.
//

import Foundation

final class GCDViewModel {
    
    weak var delegate: GCDViewModelDelegate?
    private(set) var users: [UserModel] = []
    
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
    }
    
    func dispatchGroupExamp() {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            print("1. işlem tamamlandı")
            group.leave()
        }
        
        group.enter()
        DispatchQueue.global().async {
            print("2. işlem tamamlandı")
            group.leave()
        }
        
        group.enter()
        DispatchQueue.global().async {
            print("3. işlem tamamlandı")
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("Tüm işlemler tamamlandı")
        }
    }
    
    func heavyCalculation() {
        Thread.sleep(forTimeInterval: 5)
    }
    
    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let users = try JSONDecoder().decode([UserModel].self, from: data)
                DispatchQueue.main.async {
                    self.users = users
                    self.delegate?.didUpdateUser()
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                }
            }
            
        }
        task.resume()
        
    }
    
}
