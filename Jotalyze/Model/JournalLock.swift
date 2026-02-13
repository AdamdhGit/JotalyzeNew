//
//  JournalLock.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/12/24.
//

import Foundation

class JournalLock: ObservableObject {
    @Published var isLocked: Bool {
           didSet {
               // Save to UserDefaults whenever isLocked changes
               UserDefaults.standard.set(isLocked, forKey: "isLocked")
           }
       }
    
   @Published var justSet = false

       init() {
           // Load the saved value from UserDefaults or set a default value
           self.isLocked = UserDefaults.standard.bool(forKey: "isLocked")
       }
}
