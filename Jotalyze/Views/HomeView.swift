//
//  HomeView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/21/25.
//


import SwiftUI
import StoreKit
import LocalAuthentication
import Network

struct HomeView: View {
  
    @Environment(\.colorScheme) var colorScheme
    
    @State var selectedView: String = "Journal"
    @State var showingEntryTypes = false
    
    @EnvironmentObject var journalLock: JournalLock
    @State var showLocalNotificationsView: Bool = false
    @State var showProtectYourDataView = false
    
    //journal types
    @State var moodCheckInSelected = false
    @State var gratitudeSelected = false
    @State var goalTrackingEntrySelected = false
    @State var captureTheMomentSelected = false
    
    //@State var journalManager = JournalManager()
    @State var journalManager = JournalManager.shared
    
    @State var goalManager = GoalManager()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedView) {
                
                ContentView(journalManager: journalManager, showingEntryTypes: $showingEntryTypes).tabItem{
                    Image(systemName: "book.fill")
                    Text("Journal")
                }.tag("Journal")
                
                InsightsSheetView(journalManager: journalManager, goalManager: goalManager).tabItem{
                    Image(systemName: "chart.pie.fill")
                    Text("Insights")
                }.tag("Insights")
                
                DailiesView(journalManager: journalManager).tabItem{
                    Image(systemName: "checkmark.circle")
                    Text("Dailies")
                }.tag("Dailies")
                
            }.tint(colorScheme == .dark ? .white : .black)
                .navigationTitle(selectedView)
                .navigationBarTitleDisplayMode(.inline)
            //.preferredColorScheme(.dark)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            
                            Button {
                                authenticateWithBiometrics { success, error in
                                    if success {
                                        journalLock.isLocked.toggle()
                                        journalLock.justSet = true
                                    } else {
                                        print("error authenticating")
                                    }
                                }
                            }label: {
                                Text(journalLock.isLocked ? "Unlock Journal" : "Lock Journal on Launch")
                                Image(systemName: journalLock.isLocked ? "lock" : "lock.open")
                            }
                            Button{
                                showProtectYourDataView.toggle()
                            }label: {
                                Text("How We Protect Your Data")
                                Image(systemName: "info.circle")
                            }
                            
                            Button{
                                showLocalNotificationsView.toggle()
                            }label:{
                                Text("Notifications")
                                Image(systemName: "bell")
                            }
                            
                        }label: {
                            menuButton
                        }.offset(y:-1)
                    }
                }
        }
        .sheet(isPresented: $showingEntryTypes) {
            PickEntryTypeView(moodCheckInSelected: $moodCheckInSelected, gratitudeSelected: $gratitudeSelected, goalTrackingEntrySelected: $goalTrackingEntrySelected, captureTheMomentSelected: $captureTheMomentSelected)
                .presentationDetents([.height(400)])

        }
        .fullScreenCover(isPresented: $moodCheckInSelected) {
            MoodCheckInView(journalManager: journalManager)
        }
        .fullScreenCover(isPresented: $gratitudeSelected, content: {
            GratitudeEntryView(journalManager: journalManager)
        })
        .fullScreenCover(isPresented: $goalTrackingEntrySelected, content: {
            GoalTrackingEntryView(goalManager: goalManager, journalManager: journalManager)
        })
        .fullScreenCover(isPresented: $captureTheMomentSelected, content: {
            CaptureTheMomentView(journalManager: journalManager)
        })
        .sheet(isPresented: $showProtectYourDataView, content: {
            ProtectYourDataView()
        })
        .sheet(isPresented: $showLocalNotificationsView, content: {
            LocalNotificationsView()
        })
        
       
   
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate using Face ID, Touch ID, or passcode."
            
            // Request biometric authentication
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authenticationError)
                    }
                }
            }
        } else {
            completion(false, error)
        }
    }
    
    var menuButton: some View {
        ZStack{
            Rectangle().foregroundStyle(.clear).frame(width: 80, height: 50)
            Image(systemName: "slider.horizontal.3").bold().font(.body).foregroundStyle(.gray).opacity(0.5)
        }
    }

}

#Preview {
    
    let loadCoreData = LoadCoreData()
    
    HomeView()
        .environmentObject(JournalLock())
        .environment(\.managedObjectContext, loadCoreData.container.viewContext)
}
