//
//  DailiesView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/25/25.
//

import LocalAuthentication
import SwiftUI

struct DailiesView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var journalLock: JournalLock
    @Environment(\.managedObjectContext) var moc
    @State var showProtectYourDataView = false
    
    @State var habitDeletePressed: Bool = false
    @State var habitSelectedToDelete:DailyCheckoffItem?
    @State var isEditingCheckoffItems: Bool = false
    
    //to highlight current day of week with rectangle. just day 1-7, that's all. done.
    
    @AppStorage("currentWeek") var currentWeek:Int?
    //to reset all checkmarks on a new week. done.
    
    @AppStorage("currentDayOfYear") var currentDayOfYear:Int = 0
    //to reset morning prep/evening reflection. done.
    
    @State var morningPreparationSelected:Bool = false
    @State var eveningReflectionSelected:Bool = false
    @State var journalManager:JournalManager
    
    @AppStorage("morningPreparationSaved") var morningPreparationSaved:Bool = false
    @State var animateSun:Bool = false
    @AppStorage("eveningReflectionSaved") var eveningReflectionSaved:Bool = false
    @State var animateMoon:Bool = false

    
    
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DailyCheckoffItem.name, ascending: true)]) var dailyCheckoffItems: FetchedResults<DailyCheckoffItem>
    
    @State var addNewDailyCheckoffItemIsShowing: Bool = false
    
   
    
    @State var showLocalNotificationsView: Bool = false
    
    var body: some View {
        
        ZStack{
            
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 0){
                
                ScrollView{
                    HStack{
                        Button{
                            morningPreparationSelected.toggle()
                        }label:{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 178, height: 300)
                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                Image(systemName: "sun.max.fill").resizable().frame(width: 50, height: 50).foregroundStyle(colorScheme == .light ? .black : .white).offset(x: -40, y:100)//.offset(y: animateSun ? -55 : 0)
                                HStack{
                                    VStack{
                                        Text(morningPreparationSaved ? "You've" : "Morning")
                                        Text(morningPreparationSaved ? "Prepared." : "Preparation")
                                    }.foregroundStyle(colorScheme == .light ? .black : .white).font(.title2).offset(y:-50).fontWeight(.light)
                                }
                            }
                        }.disabled(morningPreparationSaved)
                        
                        Button{
                            eveningReflectionSelected.toggle()
                        }label:{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10).foregroundStyle(.black).frame(width: 178, height: 300)
                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                Image(systemName: "moon.fill").resizable().frame(width: 40, height: 40).foregroundStyle(.white).offset(x: -40, y:100)//.offset(y: animateMoon ? -55 : 0)
                                VStack{
                                    Text(eveningReflectionSaved ? "You've" : "Evening")
                                    Text(eveningReflectionSaved ? "Reflected." : "Reflection")
                                }.foregroundStyle(.white).font(.title2).offset(y:-50).fontWeight(.light)
                            }
                        }.disabled(eveningReflectionSaved)
                       
                    }.padding(.top, 15)
                    
                    HStack{
                        
                        Text("Daily Check-Offs").fontWeight(.light).font(.title3).frame(height: 30)
                        
                        
                        Spacer()
                        
                        if !dailyCheckoffItems.isEmpty {
                            Button{
                                
                                    addNewDailyCheckoffItemIsShowing.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isEditingCheckoffItems = false
                                    }
                                
                                
                              
                            }label:{
                          
                                    HStack{
                                        Image(systemName: "plus.circle")
                                        Text("New")
                                    }
                                
                            }.tint(colorScheme == .light ? .black : .white)
                                .fontWeight(.light)
                            .font(.subheadline)

                            Divider().frame(height: 15)
                            Button{
                                isEditingCheckoffItems.toggle()
                            }label:{
                              
                                Text(isEditingCheckoffItems ? "Done" : "Edit")
                                //Image(systemName: "minus.circle").font(.subheadline)
                               
                            }.font(.subheadline).tint(colorScheme == .light ? .black : .white).padding(.vertical, 5).fontWeight(.light).padding(.trailing, 3)
                        }
                        
                        
                        
                        
                    }.padding(.top, 20).padding(.horizontal)
                    
                    
                    if dailyCheckoffItems.isEmpty {
                        
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(height: 230)
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2).padding(.horizontal)
                            VStack{
                                ContentUnavailableView("Build Routine", systemImage: "checkmark.circle", description: Text("Track your daily habits and progress. Check-offs refresh every Sunday.")).frame(height: 190).offset(y: 10).scaleEffect(0.9)
                                
                                ZStack{
                                   
                                    Button{
                                        addNewDailyCheckoffItemIsShowing.toggle()
                                    }label:{
                                        Image(systemName: "plus.circle")
                                        Text("Add New")
                                    }.foregroundStyle(.white).font(.subheadline).tint(.black).padding(.vertical, 5).fontWeight(.light).buttonStyle(.borderedProminent)
                                }.offset(y:-30)
                            }
                        }
                        
                    }
                    
                    if !dailyCheckoffItems.isEmpty {
                        ForEach(dailyCheckoffItems){i in
                            HabitRowView(i: i, habitDeletePressed: $habitDeletePressed, habitSelectedToDelete: $habitSelectedToDelete, isEditingCheckoffItems: $isEditingCheckoffItems)
                        }
                    }
                    Spacer()
                }.scrollIndicators(.hidden)
            }
            .sheet(isPresented: $showProtectYourDataView, content: {
                ProtectYourDataView()
            })
            .sheet(isPresented: $showLocalNotificationsView, content: {
                LocalNotificationsView()
            })
            
        }
        .fullScreenCover(isPresented: $addNewDailyCheckoffItemIsShowing, content: {
            AddNewDailyCheckoffItemView()
        })
        .fullScreenCover(isPresented: $morningPreparationSelected, content: {
            MorningPreparationView(journalManager: journalManager, morningPreparationSaved: $morningPreparationSaved, animateSun: $animateSun)
        })
        .fullScreenCover(isPresented: $eveningReflectionSelected, content: {
            EveningReflectionView(journalManager: journalManager, eveningReflectionSaved: $eveningReflectionSaved, animateMoon: $animateMoon)
        })
        .onAppear{
            updateCurrentWeek()
            updateCurrentDayOfYear()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                updateCurrentWeek()
                updateCurrentDayOfYear()
            }
        }
        .onChange(of: currentDayOfYear) { oldValue, newValue in
            morningPreparationSaved = false
            eveningReflectionSaved = false
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
    
    var menuButton: some View {
        ZStack{
            Rectangle().foregroundStyle(.clear).frame(width: 80, height: 50)
            Image(systemName: "slider.horizontal.3").bold().font(.body).foregroundStyle(.gray).opacity(0.5)
        }
    }
    
    func updateCurrentDayOfYear() {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        if currentDayOfYear != dayOfYear {
            morningPreparationSaved = false
            eveningReflectionSaved = false
            currentDayOfYear = dayOfYear
        }
    }
    
    func updateCurrentWeek() {
        let thisWeek = Calendar.current.component(.weekOfYear, from: Date())
        if thisWeek != currentWeek {
            currentWeek = thisWeek
            for i in dailyCheckoffItems {
                i.mondayDone = false
                i.tuesdayDone = false
                i.wednesdayDone = false
                i.thursdayDone = false
                i.fridayDone = false
                i.saturdayDone = false
                i.sundayDone = false
            }
            
            try? moc.save()
            
        }
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
    var morningDarkModeGrayColor: Color {
        Color(red: 75/255, green: 75/255, blue: 75/255)
    }
    
}

#Preview {
    let loadCoreData = LoadCoreData()
    
    DailiesView(journalManager: JournalManager()).environmentObject(JournalLock())
        .environment(\.managedObjectContext, loadCoreData.container.viewContext)
}
