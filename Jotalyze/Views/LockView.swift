//
//  LockView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/12/24.
//

import LocalAuthentication
import SwiftUI

struct LockView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var journalLock: JournalLock
    @State var showContentView = false
    @State var showErrorText = false
    @State var showAuthenticationButton = false
    
    @State var journalManager = JournalManager.shared
    
    @AppStorage("NewUserFirstLaunch") var newUserFirstLaunch: Bool = true
    
    
    var body: some View {
        
    VStack {
            
            if showContentView || !journalLock.isLocked || (journalLock.isLocked && journalLock.justSet) {
                //successfully unlocked, or unlocked, show content view
                
              HomeView()
                
            } else {
                //hasn't been unlocked but required to unlock
                
                ZStack {
                    
                    if colorScheme == .light {
                        Color.white.ignoresSafeArea(.all)
                    }
                    if colorScheme == .dark {
                        Color.black.ignoresSafeArea(.all)
                    }
                   
                    
                    VStack(spacing: 20) {
                        
                        ContentUnavailableView("Jotalyze is Locked", systemImage: "lock.shield", description: Text("Use Face ID or Passcode to Unlock")).frame(height: 200)
                        
                        if showAuthenticationButton {
                            authenticateButton
                        }
                        
                        
                        
                        if showErrorText {
                            errorText
                        }
                        
                        Spacer()
                        
                    }.padding(.top, 50)
                }
            }
        }
        .onAppear{
            if journalLock.isLocked {
                authenticateWithBiometrics { success, error in
                    if success {
                        showContentView = true
                    } else {
                        showErrorText = true
                        showAuthenticationButton = true
                    }
                }
            }
        }
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
    
    var errorText: some View {
        Text("Authentication not working? Ensure that either Face ID or Passcode is enabled for the Jotalyze app in your device settings under Face ID & Passcode.").font(.subheadline)
            .multilineTextAlignment(.center)
            .padding()
            .opacity(0.5)
    }
    
    var authenticateButton: some View {
        Button("Authenticate"){
            authenticateWithBiometrics { success, error in
                if success {
                    showContentView = true
                } else {
                    showErrorText = true
                    showAuthenticationButton = true
                }
            }
        }.foregroundStyle(colorScheme == .light ? .white : .black).font(.body).buttonStyle(.borderedProminent).tint(colorScheme == .light ? .black : .white)
            .foregroundStyle(.white)
    }
    
}
#Preview {
    LockView().environmentObject(JournalLock())
}
