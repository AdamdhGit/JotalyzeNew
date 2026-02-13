//
//  LoadCoreData.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/26/25.
//

import CoreData
import Foundation

class LoadCoreData: ObservableObject {
    
    let container = NSPersistentContainer(name: "CoreData")
      //make a reference to the CoreData bundle FILE name

  init() {
      container.loadPersistentStores { description, error in
      //load the data
          if let error = error {
              print("Core Data failed to load: \(error.localizedDescription)")
          }
      }
  }
    
}
