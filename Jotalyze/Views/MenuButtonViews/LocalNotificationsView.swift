//
//  LocalNotificationsView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/28/25.
//

import SwiftUI
import UserNotifications

struct LocalNotificationsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    @State private var notificationsEnabled: Bool = false
    @State private var selectedTime = Date()
    @AppStorage("hasSetInitialNotificationPreference") private var hasSetInitialNotificationPreference:Bool = false
    @State private var notificationsHaveBeenTurnedOff:Bool = false
    
    @AppStorage("morningPreparationNotificationOn") private var morningPreparationNotificationOn:Bool = false
    @AppStorage("eveningReflectionNotificationOn") private var eveningReflectionNotificationOn:Bool = false
    @AppStorage("journalReminderNotificationOn") private var journalReminderNotificationOn:Bool = false
    
    @State var viewOpacity = 0.5
    
    @State var morningPreparationTime:Date =  UserDefaults.standard.object(forKey: "morningPreparationTime") as? Date ?? (Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date())
    @State var eveningReflectionTime:Date =  UserDefaults.standard.object(forKey: "eveningReflectionTime") as? Date ?? (Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date()) ?? Date())
    @State var journalReminderTime:Date =  UserDefaults.standard.object(forKey: "journalReminderTime") as? Date ?? (Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date())
    
    var body: some View {
        
        ZStack{
            
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            ScrollView{
                VStack(alignment: .leading, spacing: 3){
                    
                    //MARK: Done Button and Notification Permissions
                    HStack{
                        Spacer()
                        Button("Done"){
                            dismiss()
                        }.padding(.horizontal).tint(colorScheme == .light ? .black : .white).padding(.top, 20)
                    }.onChange(of: notificationsEnabled) { oldValue, newValue in
                        if newValue == true {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){success, error in
                                if success {
                                    print("Permission granted!")
                                    
                                } else if let error {
                                    print(error.localizedDescription)
                                }
                                
                                UNUserNotificationCenter.current().getNotificationSettings { settings in
                                    if settings.authorizationStatus == .authorized {
                                        print("User allowed notifications.")
                                        hasSetInitialNotificationPreference = true
                                        viewOpacity = 1.0
                                    }  else if settings.authorizationStatus == .denied {
                                        print("User denied notifications.")
                                        hasSetInitialNotificationPreference = true
                                        notificationsHaveBeenTurnedOff = true
                                        viewOpacity = 0.5
                                    }
                                }
                                
                            }
                        }
                    }
                    .onAppear{
                        //check their notification status onAppear incase they changed in Settings.
                        UNUserNotificationCenter.current().getNotificationSettings { settings in
                            if settings.authorizationStatus == .authorized {
                                print("User allowed notifications.")
                                notificationsHaveBeenTurnedOff = false
                                viewOpacity = 1.0
                            }  else if settings.authorizationStatus == .denied {
                                print("User denied notifications.")
                                notificationsHaveBeenTurnedOff = true
                                //MARK: delete all notifications setup if they turn off notifications overall
                                morningPreparationNotificationOn = false
                                eveningReflectionNotificationOn = false
                                journalReminderNotificationOn = false
                                viewOpacity = 0.5
                            }
                        }
                    }
                    .onChange(of: scenePhase) { oldValue, newValue in
                        if newValue == .active {
                            //check their notification status onAppear incase they changed in Settings.
                            UNUserNotificationCenter.current().getNotificationSettings { settings in
                                if settings.authorizationStatus == .authorized {
                                    print("User allowed notifications.")
                                    
                                    notificationsHaveBeenTurnedOff = false
                                    viewOpacity = 1.0
                                }  else if settings.authorizationStatus == .denied {
                                    print("User denied notifications.")
                                    notificationsHaveBeenTurnedOff = true
                                    
                                    //MARK: delete all notifications setup if they turn off notifications overall
                                    morningPreparationNotificationOn = false
                                    eveningReflectionNotificationOn = false
                                    journalReminderNotificationOn = false
                                    
                                    viewOpacity = 0.5
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                    if !hasSetInitialNotificationPreference {
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10).frame(height: 50).foregroundStyle(darkGrayColor)
                            Toggle(isOn: $notificationsEnabled){
                                Text("Enable Notifications").foregroundStyle(.white)
                            }.tint(.white).frame(width: 320)
                        }.padding(.top, 20).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    }
                    
                    if notificationsHaveBeenTurnedOff {
                        
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10).frame(height: 150).foregroundStyle(colorScheme == .light ? .black : darkGrayColor)
                            VStack{
                                Text("Notifications are not enabled. To receive reminders you need to give permissions in Settings").padding(.bottom, 10).foregroundStyle(.white).fontWeight(.light).multilineTextAlignment(.center).font(.subheadline).padding(.horizontal)
                                Button("Open Settings"){
                                    openAppSettings()
                                }.tint(colorScheme == .light ? .white : .black).foregroundStyle(colorScheme == .light ? .black : .white).buttonStyle(.borderedProminent).fontWeight(.light)
                            }
                        }.padding(.bottom, 20).padding(.top, 20)
                    }
                    
                    //MARK: The Notifications
                    
                    //MARK: dailies notifications
                    
                    Text("Notifications").foregroundStyle(colorScheme == .light ? .black : .white).bold().padding(.bottom, 20).padding(.top, notificationsHaveBeenTurnedOff ? 5 : 20)
                    Text("Dailies").foregroundStyle(colorScheme == .light ? .black : .white).fontWeight(.light).padding(.bottom, 5)
                    
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                        HStack{
                            VStack{
                                HStack{
                                    Text("Morning Preparation")
                                    Spacer()
                                }.padding(.bottom, 3)
                                HStack{
                                    Text("Reminder to prepare for a productive day ahead.").multilineTextAlignment(.leading).fontWeight(.light).font(.caption)
                                    
                                    Spacer()
                                }
                                
                            }.padding()
                            
                            Divider().padding(.vertical)
                            VStack{
                                DatePicker("", selection: $morningPreparationTime, displayedComponents: .hourAndMinute).labelsHidden().accessibilityLabel("Select Morning Preparation Time").tint(.black).scaleEffect(0.75).frame(width: 90).padding(.bottom, 5)
                                Toggle("", isOn: $morningPreparationNotificationOn).labelsHidden()
                                    .accessibilityLabel("Morning Preparation Notification Toggle")
                                    .disabled(notificationsHaveBeenTurnedOff)
                                    .disabled(!hasSetInitialNotificationPreference)
                            }.padding()
                        }.padding()
                    }.shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .opacity(viewOpacity)
                        .onChange(of: morningPreparationNotificationOn) { oldValue, newValue in
                            print("Old value: \(oldValue), New value: \(newValue)")
                            //as soon as its toggled on, runs the current time set.
                            //if its toggled off it cancels and removes the current time set.
                            if newValue == true {
                                let content = UNMutableNotificationContent()
                                content.title = "Jotalyze: Morning Preparation"
                                content.subtitle = "Prepare for a productive day!"
                                content.sound = UNNotificationSound.default
                                
                                let components = Calendar.current.dateComponents([.hour, .minute], from: morningPreparationTime)
                                let trigger =   UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                              
                                
                                let request = UNNotificationRequest(identifier: "morningPreparationReminder", content: content, trigger: trigger)
                                
                                UNUserNotificationCenter.current().add(request)
                            } else {
                               
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["morningPreparationReminder"])
                                print("Notification cancelled.")
                            }
                            
                        }
                        .onChange(of: morningPreparationTime) {
                           
                            
                            //if time is changed it removes old time, updates to new one. ONLY does this if notification toggled ON.
                            if morningPreparationNotificationOn {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["morningPreparationReminder"])
                                print("Notification cancelled.")
                                
                                //set the new notification time
                                let content = UNMutableNotificationContent()
                                content.title = "Jotalyze: Morning Preparation"
                                content.subtitle = "Prepare for a productive day!"
                                content.sound = UNNotificationSound.default
                                
                                let components = Calendar.current.dateComponents([.hour, .minute], from: morningPreparationTime)
                                let trigger =   UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                                
                                
                                let request = UNNotificationRequest(identifier: "morningPreparationReminder", content: content, trigger: trigger)
                                
                                UNUserNotificationCenter.current().add(request)
                            }
                            
                        }

                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                        HStack{
                            VStack{
                                HStack{
                                    Text("Evening Reflection")
                                    Spacer()
                                }.padding(.bottom, 3)
                                HStack{
                                    Text("Reminder to wind down and reflect on your day.").multilineTextAlignment(.leading).fontWeight(.light).font(.caption)
                                    Spacer()
                                }
                                
                            }.padding()
                            
                            Divider().padding(.vertical)
                            VStack{
                                DatePicker("", selection: $eveningReflectionTime, displayedComponents: .hourAndMinute).labelsHidden().accessibilityLabel("Select Evening Reflection Time").tint(.black).scaleEffect(0.75).frame(width: 90).padding(.bottom, 5)
                                Toggle("", isOn: $eveningReflectionNotificationOn).labelsHidden()
                                    .accessibilityLabel("Evening Reflection Notification Toggle")
                                    .disabled(notificationsHaveBeenTurnedOff)
                                    .disabled(!hasSetInitialNotificationPreference)
                            }.padding()
                        }.padding()
                    }.shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .opacity(viewOpacity)
                        .onChange(of: eveningReflectionNotificationOn) { oldValue, newValue in
                            if newValue == true {
                                let content = UNMutableNotificationContent()
                                content.title = "Jotalyze: Evening Reflection"
                                content.subtitle = "Take a moment to reflect on your day."
                                content.sound = UNNotificationSound.default
                                
                                let components = Calendar.current.dateComponents([.hour, .minute], from: eveningReflectionTime)
                                let trigger =   UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                                
                                let request = UNNotificationRequest(identifier: "eveningReflectionReminder", content: content, trigger: trigger)
                                
                                UNUserNotificationCenter.current().add(request)
                            } else {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["eveningReflectionReminder"])
                                print("Notification cancelled.")
                            }
                        }.onChange(of: eveningReflectionTime) {
                            
                            
                            //if time is changed it removes old time, updates to new one. ONLY does this if notification toggled ON.
                            if eveningReflectionNotificationOn {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["eveningReflectionReminder"])
                                print("Notification cancelled.")
                                
                                //set the new notification time
                                let content = UNMutableNotificationContent()
                                content.title = "Jotalyze: Evening Reflection"
                                content.subtitle = "Take a moment to reflect on your day."
                                content.sound = UNNotificationSound.default
                                
                                let components = Calendar.current.dateComponents([.hour, .minute], from: eveningReflectionTime)
                                let trigger =   UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                                
                                
                                let request = UNNotificationRequest(identifier: "eveningReflectionReminder", content: content, trigger: trigger)
                                
                                UNUserNotificationCenter.current().add(request)
                            }
                            
                        }
                    
                    //MARK: other journal types
                    
                    Text("Other Journal Types").foregroundStyle(colorScheme == .light ? .black : .white).fontWeight(.light).padding(.bottom, 5).padding(.top, 20)
                    
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                        HStack{
                            VStack{
                                HStack{
                                    Text("Journal Reminder")
                                    Spacer()
                                }.padding(.bottom, 3)
                                HStack{
                                    Text("A general reminder to check-in, track goals, express gratitude, and reflect on meaningful moments.").multilineTextAlignment(.leading).fontWeight(.light).font(.caption)
                                    Spacer()
                                }
                                
                            }.padding()
                            
                            Divider().padding(.vertical)
                            VStack{
                                DatePicker("", selection: $journalReminderTime, displayedComponents: .hourAndMinute).labelsHidden().accessibilityLabel("Select A Journal Reminder Time").tint(.black).scaleEffect(0.75).frame(width: 90).padding(.bottom, 5)
                                Toggle("", isOn: $journalReminderNotificationOn).labelsHidden()
                                    .accessibilityLabel("Journal Reminder Notification Toggle")
                                    .disabled(notificationsHaveBeenTurnedOff)
                                    .disabled(!hasSetInitialNotificationPreference)
                            }.padding()
                        }.padding()
                    }.shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .opacity(viewOpacity)
                        .onChange(of: journalReminderNotificationOn) { oldValue, newValue in
                            print("Old value: \(oldValue), New value: \(newValue)")
                            if newValue == true {
                                let content = UNMutableNotificationContent()
                                content.title = "Jotalyze: Daily Journaling"
                                content.subtitle = "Take a moment to journal."
                                content.sound = UNNotificationSound.default
                                
                                let components = Calendar.current.dateComponents([.hour, .minute], from: journalReminderTime)
                                let trigger =   UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                                
                                let request = UNNotificationRequest(identifier: "journalReminder", content: content, trigger: trigger)
                                
                                UNUserNotificationCenter.current().add(request)
                            } else {
                                // Cancel Notification if toggle is off
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["journalReminder"])
                                print("Notification cancelled.")
                            }
                            
                        }.onChange(of: journalReminderTime) {
                            
                            
                            //if time is changed it removes old time, updates to new one. ONLY does this if notification toggled ON.
                            if journalReminderNotificationOn {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["journalReminder"])
                                print("Notification cancelled.")
                                
                                //set the new notification time
                                let content = UNMutableNotificationContent()
                                content.title = "Jotalyze: Daily Journaling"
                                content.subtitle = "Take a moment to journal."
                                content.sound = UNNotificationSound.default
                                
                                let components = Calendar.current.dateComponents([.hour, .minute], from: journalReminderTime)
                                let trigger =   UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                                
                                
                                let request = UNNotificationRequest(identifier: "journalReminder", content: content, trigger: trigger)
                                
                                UNUserNotificationCenter.current().add(request)
                            }
                            
                        }
                    
                    Spacer()
                    
                }.padding(.horizontal)
            }.scrollIndicators(.hidden)
        }.background(colorScheme == .light ? Color.white.ignoresSafeArea() : darkGrayColor.ignoresSafeArea())
            .onChange(of: morningPreparationTime) {
                //save time
                UserDefaults.standard.set(morningPreparationTime, forKey: "morningPreparationTime")
            }
            .onChange(of: eveningReflectionTime) {
                UserDefaults.standard.set(eveningReflectionTime, forKey: "eveningReflectionTime")
            }
            .onChange(of: journalReminderTime) {
                UserDefaults.standard.set(journalReminderTime, forKey: "journalReminderTime")
            }
   
    }

    func openAppSettings() {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            } else {
                // Handle case where URL couldn't be opened
                print("Unable to open settings.")
            }
        }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
}

#Preview {
    LocalNotificationsView()
}
