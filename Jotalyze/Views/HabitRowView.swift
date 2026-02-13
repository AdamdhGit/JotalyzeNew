//
//  HabitRowView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/2/26.
//

import SwiftUI

struct HabitRowView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \DailyCheckoffItem.name, ascending: true)]) var dailyCheckoffItems: FetchedResults<DailyCheckoffItem>
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var i: DailyCheckoffItem
    @Environment(\.managedObjectContext) var moc
    
    @Binding var habitDeletePressed: Bool
    @Binding var habitSelectedToDelete:DailyCheckoffItem?
    @Binding var isEditingCheckoffItems: Bool
    
    @State private var currentWeekday =
        Calendar.current.component(.weekday, from: Date())
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(height: 120)
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2).padding(.horizontal)
            VStack{
                HStack{
                    Text("\(i.name ?? "")").font(.subheadline).opacity(0.75)
                    Spacer()
                    if isEditingCheckoffItems{
                        Button{
                            habitDeletePressed = true
                            habitSelectedToDelete = i
                            
                            
                        }label:{
                            Image(systemName: "trash").font(.subheadline).padding()
                            
                        }.foregroundStyle(.red).opacity(0.75).offset(x:-15)
                            .confirmationDialog("Delete Habit: \(habitSelectedToDelete?.name ?? "")?", isPresented: $habitDeletePressed, titleVisibility: .visible) {
                                
                                Button("Delete", role: .destructive) {
                                    if let habitSelected = habitSelectedToDelete {
                                        moc.delete(habitSelected)
                                        try? moc.save()
                                        
                                        if dailyCheckoffItems.isEmpty {
                                            isEditingCheckoffItems = false
                                        }
                                    }
                                }
                                
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                    Text("Are you sure you want to delete this habit?")
                            }
                    }
                    
                }.padding(.leading).padding(.top, 10).padding(.leading).frame(height: 15)
                HStack(spacing: 15){
                    
                    if i.sundayExists {
                        ZStack{
                            if currentWeekday == 1 {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).frame(width: 35, height: 60)
                            }
                            VStack(spacing: 5){
                                Text("S").font(.caption)
                                Button{
                                    i.objectWillChange.send()
                                    i.sundayDone.toggle()
                                    try? moc.save()
                                }label:{
                                    
                                    Image(systemName: i.sundayDone ? "checkmark.circle" : "circle")
                                    
                                }.tint(colorScheme == .light ? .black : .white)
                                
                            }
                        }
                    }
                    
                    if i.mondayExists {
                        ZStack{
                            if currentWeekday == 2 {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).frame(width: 35, height: 60)
                            }
                            VStack(spacing: 5){
                                Text("M").font(.caption)
                                Button{
                                    i.objectWillChange.send()
                                    i.mondayDone.toggle()
                                    try? moc.save()
                                }label:{
                                    Image(systemName: i.mondayDone ? "checkmark.circle" : "circle")
                                }.tint(colorScheme == .light ? .black : .white)
                            }
                        }
                    }
                    
                    if i.tuesdayExists {
                        ZStack{
                            if currentWeekday == 3 {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).frame(width: 35, height: 60)
                            }
                            VStack(spacing: 5){
                                Text("T").font(.caption)
                                Button{
                                    i.objectWillChange.send()
                                    i.tuesdayDone.toggle()
                                    try? moc.save()
                                }label:{
                                    Image(systemName: i.tuesdayDone ? "checkmark.circle" : "circle")
                                }.tint(colorScheme == .light ? .black : .white)
                            }
                        }
                    }
                    
                    if i.wednesdayExists {
                        ZStack{
                            if currentWeekday == 4 {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).frame(width: 35, height: 60)
                            }
                            VStack(spacing: 5){
                                Text("W").font(.caption)
                                Button{
                                    i.objectWillChange.send()
                                    i.wednesdayDone.toggle()
                                    try? moc.save()
                                }label:{
                                    Image(systemName: i.wednesdayDone ? "checkmark.circle" : "circle")
                                }.tint(colorScheme == .light ? .black : .white)
                            }
                        }
                    }
                    
                    if i.thursdayExists {
                        ZStack{
                            if currentWeekday == 5 {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).frame(width: 35, height: 60)
                            }
                            VStack(spacing: 5){
                                Text("Th").font(.caption)
                                Button{
                                    i.objectWillChange.send()
                                    i.thursdayDone.toggle()
                                    try? moc.save()
                                }label:{
                                    Image(systemName: i.thursdayDone ? "checkmark.circle" : "circle")
                                }.tint(colorScheme == .light ? .black : .white)
                            }
                        }
                    }
                    
                    if i.fridayExists {
                        ZStack{
                            if currentWeekday == 6 {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).frame(width: 35, height: 60)
                            }
                            VStack(spacing: 5){
                                Text("F").font(.caption)
                                Button{
                                    i.objectWillChange.send()
                                    i.fridayDone.toggle()
                                    try? moc.save()
                                }label:{
                                    Image(systemName: i.fridayDone ? "checkmark.circle" : "circle")
                                }.tint(colorScheme == .light ? .black : .white)
                            }
                        }
                    }
                    
                    if i.saturdayExists {
                        ZStack{
                            if currentWeekday == 7 {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).frame(width: 35, height: 60)
                            }
                            VStack(spacing: 5){
                                Text("Sa").font(.caption)
                                Button{
                                    i.objectWillChange.send()
                                    i.saturdayDone.toggle()
                                    try? moc.save()
                                }label:{
                                    Image(systemName: i.saturdayDone ? "checkmark.circle" : "circle")
                                }.tint(colorScheme == .light ? .black : .white)
                            }
                        }
                    }
                    
                    Spacer()
                }.padding(.top, 15).fontWeight(.light).font(.title3).opacity(0.5).padding(.leading, 30).frame(height: 70)
            }
        }.padding(.bottom, 3).onAppear{
            updateCurrentDay()
        }   .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                updateCurrentDay()
            }
        }
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
    func updateCurrentDay() {
           let today = Calendar.current.component(.weekday, from: Date())
           if today != currentWeekday {
               currentWeekday = today // Updates @State, triggering view refresh
               print("day updated")
           }
       }
    
}

#Preview {
    HabitRowView(i: DailyCheckoffItem(), habitDeletePressed: .constant(false), habitSelectedToDelete: .constant(DailyCheckoffItem()), isEditingCheckoffItems: .constant(false))
}
