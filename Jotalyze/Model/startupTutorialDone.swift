//
//  startupTutorialDone.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 4/1/25.
//

import Foundation

class StartupTutorialDone: ObservableObject {
    @Published var tutorialIsDone: Bool {
           didSet {
               // Save to UserDefaults whenever tutorial property changes
               UserDefaults.standard.set(tutorialIsDone, forKey: "tutorialIsDone")
           }
       }
    
    init(){
        
        tutorialIsDone = UserDefaults.standard.bool(forKey: "tutorialIsDone")
        
        if !UserDefaults.standard.bool(forKey: "tutorialIsDone") {
                    self.tutorialIsDone = false
                }
        
    }
    
}
