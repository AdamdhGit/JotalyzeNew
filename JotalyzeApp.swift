//
//  JotalyzeApp.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/11/24.
//

import SwiftUI

//appl_kyjNYNKmZxskCSLviaKRvTnZytj

@main
struct JotalyzeApp: App {
    
    @StateObject var journalLock = JournalLock()
    @StateObject var loadCoreData = LoadCoreData()
    @StateObject var startupTutorialDone = StartupTutorialDone()
    
    @AppStorage("isExistingUser") var isExistingUser: Bool = false
    
    init() {
           // ONLY pre-premium release:
           if !isExistingUser {
               isExistingUser = true // mark existing users
           }
       }
    
    var body: some Scene {
        WindowGroup {
            
            if !startupTutorialDone.tutorialIsDone {
                StartupTutorialView().environmentObject(startupTutorialDone)
            } else {
                LockView()
                    .environmentObject(startupTutorialDone)
                    .environmentObject(journalLock)
                    .environment(\.managedObjectContext, loadCoreData.container.viewContext)
                    
            }
            }
  
    }

}

