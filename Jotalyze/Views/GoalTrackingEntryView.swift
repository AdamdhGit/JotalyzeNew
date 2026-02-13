//
//  GoalTrackingEntryView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/22/25.
//

import SwiftUI

struct GoalTrackingEntryView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss
    
    @State var goalManager:GoalManager
    @State var goalNameText: String = ""
    @State var goalTypeChosen: String = "Action Based"
    @State var editingGoals = false
    @State var selectedGoal:Goal?
    @State var tabViewSelection = 0
    @State var progressEntryText = ""
    @State var addGoalViewIsShowing = false
    @State var goalHourAmount:Double = 0.0
    
    @State var hoursLogged:Double = 0
    
    @State var journalManager:JournalManager
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State var goalDeleted:Bool = false
    @State var goalSelectedToDelete:Goal?
    
    let goalTypes = ["Action Based", "Hour Based", "Other"]
    
    var body: some View {
        
        TabView(selection: $tabViewSelection){
            
            VStack{
                
                if !addGoalViewIsShowing {

                    HStack{
                        Button("Cancel"){
                            dismiss()
                        }.tint(colorScheme == .light ? .black : .white)
                        Spacer()
                        if !goalManager.myGoals.isEmpty {
                            Button{
                                    addGoalViewIsShowing = true
                            }label:{
                                Image(systemName: "plus")
                                Text("Add Goal")
                            }.tint(colorScheme == .light ? .black : .white)
                        }
                    }.padding(.horizontal).padding(.top, 20)
                }
                
                ScrollView{
                    
                    //add goal
                    if addGoalViewIsShowing {
                        
                        ZStack{
                            Text("New Goal")
                            HStack{
                                Button("Back"){
                                    addGoalViewIsShowing = false
                                }.tint(colorScheme == .light ? .black : .white)
                                Spacer()
                                
                                Button("Create"){
                                    let newGoal = Goal(id: UUID(), goalType: goalTypeChosen, goalName: goalNameText, goalHours: Int(goalHourAmount))
                                    goalManager.saveGoal(newGoal)
                                    goalManager.getAllGoals()
                                    addGoalViewIsShowing = false
                                    goalNameText = ""
                                }.disabled(goalNameText.isEmpty).tint(colorScheme == .light ? .black : .white)
                                    .disabled(goalTypeChosen == "Hour Based" && goalHourAmount == 0)
                                
                            }
                        }.padding(.top, 20)
                        VStack{
                            
                            HStack{
                                Text("Goal Name").bold()
                                Spacer()
                            }.padding(.top, 30)
                            HStack{
                                TextField("Name Your Goal", text: $goalNameText).padding(.bottom, 30)
                                    .fontWeight(.light)
                                    .tint(colorScheme == .light ? .black : .white)
                                    .focused($isTextFieldFocused)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            isTextFieldFocused = true // Delay to ensure it works
                                            
                                        }
                                    }
                                    .onChange(of: goalNameText) { oldValue, newValue in
                                        if goalNameText.count > 25 {
                                            goalNameText = oldValue
                                        }
                                    }
                                
                                Text("\(goalNameText.count)/25").foregroundStyle(.gray).fontWeight(.light).padding(.bottom, 30)
                            }
                            
                            HStack{
                                Text("Goal Type").bold()
                                Spacer()
                            }
                            
                            HStack{
                                Picker("Goal Type", selection: $goalTypeChosen) {
                                    ForEach(goalTypes, id: \.self){i in
                                        Text(i)
                                        
                                    }
                                }.pickerStyle(.segmented).padding(.bottom, 30).padding(.top, 10)
                                Spacer()
                            }
                            
                            VStack{
                                if goalTypeChosen == "Action Based" {
                                    VStack{
                                        Text("Track goal completions, like going to the gym, with the completion count displayed in Insights.")
                                            .multilineTextAlignment(.center)
                                            .fontWeight(.light)
                                        Spacer()
                                    }
                                    
                                }
                                
                                if goalTypeChosen == "Hour Based" {
                                    VStack{
                                        Text("Track progress toward a goal based on time spent, like study hours, with progress bars displayed in Insights.").padding(.bottom, 15).multilineTextAlignment(.center)
                                            .fontWeight(.light)
                                        
                                        
                                        HStack{
                                            Text("Goal Amount").bold()
                                            Spacer()
                                        }.padding(.top, 20)
                                        
                             
                                        Slider(value: $goalHourAmount, in: 0...100, step: 1.0).padding(.horizontal).tint(colorScheme == .light ? .black : .white)
                                          
                                        HStack{
                                            Text("\(goalHourAmount == 0 ? "Slide To Set Goal" : String(Int(goalHourAmount))) \(goalHourAmount == 1 ? "Hour" : "Hours")")
                                                .foregroundStyle(goalHourAmount == 0 ? .gray : (colorScheme == .light ? .black : .white)).fontWeight(.light)
                                                .font(.caption)
                                            Spacer()
                                        }.padding(.leading)
                                        
                                    }
                                }
                                
                                if goalTypeChosen == "Other" {
                                    VStack{
                                        Text("A flexible goal type for anything you want to achieve.")
                                          .multilineTextAlignment(.center)
                                          .fontWeight(.light)
                                        
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            
                        }
                    }
                    
                    
                   
                    
                    //display goals
                    
                    if !addGoalViewIsShowing {
                        VStack(alignment: .leading){
                            
                            
                            if goalManager.myGoals.isEmpty {
                                ContentUnavailableView("No Current Goals", systemImage: "trophy")
                                HStack{
                                    Spacer()
                                    Button("Create Goal"){
                                        addGoalViewIsShowing = true
                                    }.foregroundStyle(.white).padding().background( RoundedRectangle(cornerRadius: 10).frame(height: 40).foregroundStyle(darkGrayColor))
                                        .fontWeight(.light)
                                    Spacer()
                                }
                            } else {
                                HStack{
                                    VStack(alignment: .leading){
                                        Text("My Goals").font(.title3).padding(.bottom, 10).fontWeight(.light)
                                  
                                            Text("Select a goal to log progress").foregroundStyle(.gray).font(.caption)
                                            
                                    }
                                    
                                    Spacer()
                                    
                                    VStack{
                                        Button{
                                          
                                                editingGoals.toggle()
                                            
                                        }label:{
                                            Text(editingGoals ? "Done Editing" : "Edit Goals").font(.caption)
                                        }.foregroundStyle(.gray).opacity(0.75)
                                        Spacer()
                                    }
                                }.padding(.bottom, 10)
                               
                                
                                ForEach(goalManager.myGoals.sorted(by: { $0.goalName < $1.goalName })){i in
                                    
                                   
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10).frame(height: 50).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            HStack{
                                                Button{
                                                    selectedGoal = i
                                                    tabViewSelection = 1
                                                    
                                                }label:{
                                                    
                                                    Text(i.goalName).foregroundStyle(colorScheme == .light ? .black : .white).frame(maxWidth: .infinity, alignment: .leading).fontWeight(.light)
                                                }
                                                
                                                Spacer()
                                                
                                                VStack{
                                                    if editingGoals {
                                                        Button{
                                                            goalDeleted = true
                                                            goalSelectedToDelete = i
                                                            
                                                        }label:{
                                                            Image(systemName: "trash")
                                                                .font(.subheadline).foregroundStyle(.red)
                                                  .opacity(0.75)
                                                        }.confirmationDialog("Delete Goal: \(goalSelectedToDelete?.goalName ?? "")?", isPresented: $goalDeleted, titleVisibility: .visible) {
                                                            
                                                            Button("Delete", role: .destructive) {
                                                                if let goalSelected = goalSelectedToDelete {
                                                                    goalManager.deleteGoal(goal: goalSelected)
                                                                   
                                                                }
                                                            }
                                                            
                                                            Button("Cancel", role: .cancel) { }
                                                        } message: {
                                                            if goalSelectedToDelete?.goalType == "Hour Based" {
                                                                Text("Note: The associated progress bar in Insights will be deleted. Are you sure you want to proceed?")
                                                            } else {
                                                                Text("Note: The associated completion count in Insights will be deleted. Are you sure you want to proceed?")
                                                            }
                                                        }
                                                    }
                                                }.frame(width: 20, height: 20)
                                                
                                            }.padding()
                                        }
                                        .padding(.horizontal, 5)
                                    
                                }
                                
                            }
                        }.padding(.top, 30)
                    }
                    
                    Spacer()
                    
                }.padding(.horizontal).scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .tabBar)
            .onAppear{
                goalManager.getAllGoals()
            }
            .tag(0)
            .background(.gray.opacity(0.1))
            
            
            ScrollView{
                HStack{
                    Button("Back"){
                        tabViewSelection = 0
                        progressEntryText = ""
                        isTextFieldFocused = false
                        
                    }.tint(colorScheme == .light ? .black : .white)
                    Spacer()
                    
                    Button("Save"){
                        let newEntry = JournalEntry(id: UUID(), mood: "", title: "", entry: progressEntryText, date: Date.now, entryType: "Goal", goalName: selectedGoal?.goalName, goalType: selectedGoal?.goalType, progressLogged: hoursLogged)
                        
                        if var editedGoal = selectedGoal {
                            if editedGoal.goalType == "Hour Based" {
                                editedGoal.hoursCompleted = (editedGoal.hoursCompleted ?? 0) + Int(hoursLogged)
                                goalManager.saveGoal(editedGoal)
                                selectedGoal = editedGoal
                            }
                            
                            if editedGoal.goalType == "Action Based" {
                                editedGoal.totalCompletions = (editedGoal.totalCompletions ?? 0) + 1
                                goalManager.saveGoal(editedGoal)
                                selectedGoal = editedGoal
                            }
                            //print("goal logged hours: \(editedGoal.hoursCompleted ?? 0)")
                        }
                        
                        journalManager.saveJournalEntry(newEntry)
                        journalManager.getAllJournalEntries()
                        
                        
                        dismiss()
                        
                        if journalManager.journalEntries.count == 5 || journalManager.journalEntries.count == 20 || journalManager.journalEntries.count == 50 || journalManager.journalEntries.count == 75 ||
                            journalManager.journalEntries.count == 100 {
                            requestReview()
                        }
                      
                       // calendarViewSelected = nil
                       // allSelected = true
                    }.disabled(progressEntryText.isEmpty)
                        .disabled(selectedGoal?.goalType == "Hour Based" && hoursLogged == 0)
                        .tint(colorScheme == .light ? .black : .white)
                    
                }.padding(.horizontal).padding(.top, 20)
                
                HStack{
                    Text(selectedGoal?.goalName ?? "").padding(.top, 30).font(.title3).fontWeight(.light)
                    Spacer()
                }.padding(.horizontal)
                //Divider().padding(.vertical, 10)
                
                if selectedGoal?.goalType == "Hour Based" {
                    
                    HStack{
                        Text("Duration").foregroundStyle(.gray)
                        Spacer()
                    }.padding(.horizontal).padding(.top, 15).font(.subheadline)
                    HStack{
                        Slider(value: $hoursLogged, in: 0...12, step: 1.0).padding(.horizontal).frame(width: 300)
                            .onAppear{
                                hoursLogged = 0
                            }
                            .tint(colorScheme == .light ? .black : .white)
                        Spacer()
                    }
                    HStack{
                        Text("\(hoursLogged == 0 ? "Slide To Track" : String(Int(hoursLogged))) \(hoursLogged == 1 ? "Hour" : "Hours")")
                            .fontWeight(.light)
                            .foregroundStyle(hoursLogged == 0 ? .gray : (colorScheme == .light ? .black : .white))
                        Spacer()
                    }.padding(.horizontal).padding(.bottom, 10).font(.caption)
                    
                    Divider().padding(.vertical, 10).padding(.horizontal)
                    
                }
                
                ScrollViewReader{proxy in
                        ScrollView{
                            ZStack(alignment: .topLeading){
                                
                                if progressEntryText.isEmpty {
                                    Text("How did it go today? What went well? What was challenging?").fontWeight(.light).foregroundStyle(Color(UIColor.placeholderText)).padding(.horizontal)
                                }
                                TextField("", text: $progressEntryText, axis: .vertical)
                                    .padding(.horizontal)
                                    .id("bottom")
                                    .focused($isTextFieldFocused)
                                    .fontWeight(.light)
                                    .tint(colorScheme == .light ? .black : .white)
                            }
                        }.frame(height: selectedGoal?.goalType == "Hour Based" ? 130 : 230)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isTextFieldFocused = true // Delay to ensure it works
                                
                            }
                        }
                    
                       .onTapGesture {
                                                       isTextFieldFocused = true // Focus when tapped anywhere in the area
                                                   }
                       .onChange(of: progressEntryText) {
             withAnimation {
                 proxy.scrollTo("bottom", anchor: .bottom)
             }
         }
         
    }
            
                Spacer()
            }
            .toolbar(.hidden, for: .tabBar)
            .tag(1)
            
        }
        
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
}

#Preview {
    GoalTrackingEntryView(goalManager: GoalManager(), journalManager: JournalManager())
}
