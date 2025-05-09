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
    
    func serialQueue() {
        let serialQue = DispatchQueue(label: "serialQueue")
        
        serialQue.sync {
            print("işlem 1 yapıldı")
            
        }
        
        serialQue.sync {
            print("işlem 2 yapıldı")
        }
        
        
        serialQue.sync {
            print("işlem 3 yapıldı")
        }
    }
    
    func serialQue2() {
        let serialQueu2 = DispatchQueue(label: "serialQueu2")
        print("işlemler başladı")
        serialQueu2.async {
            let start = Date()
            while Date().timeIntervalSince(start) < 5 {
                // Boş döngü 5 saniye
            }
            print("işlem 1 tamamlandı")
        }
        
        serialQueu2.async {
            let start = Date()
            while Date().timeIntervalSince(start) < 3 {
                // Boş döngü 5 saniye
            }
            print("işlem 2 tamamlandı")
        }
        
        serialQueu2.async {
            let start = Date()
            while Date().timeIntervalSince(start) < 1 {
                // Boş döngü 5 saniye
            }
            print("işlem 3 tamamlandı")
        }
        
        print("işlemler bitti")
    }
    
    func globalQue3() {
        let globalQu3 = DispatchQueue.global()
        print("işlemler başladı")
        globalQu3.async {
            let start = Date()
            while Date().timeIntervalSince(start) < 5 {
                // Boş döngü 5 saniye
            }
            print("işlem 1 tamamlandı")
        }
        
        globalQu3.async {
            let start = Date()
            while Date().timeIntervalSince(start) < 3 {
                // Boş döngü 5 saniye
            }
            print("işlem 2 tamamlandı")
        }
        
        globalQu3.async {
            let start = Date()
            while Date().timeIntervalSince(start) < 1 {
                // Boş döngü 5 saniye
            }
            print("işlem 3 tamamlandı")
        }
        print("işlemler bitti")
    }
    
    //Deadlock
    func globalQueueSync() {
        
        //Deadlock olmaz ama güvenli değil
        DispatchQueue.global().async {
            print("işlem 1 tamamlandı")
            
            DispatchQueue.global().sync {
                print("işlem 2 tamamlandı")
                //self.delegate?.heavyCalculateDidFinish()
            }
        }
        
    }
    
    //Deadlock
    func globalQueueSync2() {
        
        let globalQ = DispatchQueue.global()
        globalQ.async {
            print("5 saniye geçti (UI donmuştur)")
            
        }
        
        globalQ.sync {
            self.delegate?.heavyCalculateDidFinish()
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
