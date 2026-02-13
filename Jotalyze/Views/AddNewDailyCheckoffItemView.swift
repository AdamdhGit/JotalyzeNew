//
//  AddNewDailyCheckoffItemView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/26/25.
//

import SwiftUI

struct AddNewDailyCheckoffItemView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.dismiss) var dismiss
    @State var habitNameText: String = ""
    @Environment(\.managedObjectContext) var moc
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State var mondaySelected: Bool = true
    @State var tuesdaySelected: Bool = true
    @State var wednesdaySelected: Bool = true
    @State var thursdaySelected: Bool = true
    @State var fridaySelected: Bool = true
    @State var saturdaySelected: Bool = true
    @State var sundaySelected: Bool = true
    
    var body: some View {
        ZStack{
            
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack{
                
                ZStack{
                    Text("New Habit")
                    HStack{
                        Button("Cancel"){
                            dismiss()
                        }.tint(colorScheme == .light ? .black : .white)
                        Spacer()
                        
                        Button ("Save"){
                            let newHabitCheckoffItem = DailyCheckoffItem(context: moc)
                            newHabitCheckoffItem.name = habitNameText
                            newHabitCheckoffItem.mondayExists = mondaySelected
                            newHabitCheckoffItem.tuesdayExists = tuesdaySelected
                            newHabitCheckoffItem.wednesdayExists = wednesdaySelected
                            newHabitCheckoffItem.thursdayExists = thursdaySelected
                            newHabitCheckoffItem.fridayExists = fridaySelected
                            newHabitCheckoffItem.saturdayExists = saturdaySelected
                            newHabitCheckoffItem.sundayExists = sundaySelected
                            try? moc.save()
                            dismiss()
                        }.tint(colorScheme == .light ? .black : .white)
                            .disabled(habitNameText.isEmpty)
                            .disabled(!mondaySelected && !tuesdaySelected && !wednesdaySelected && !thursdaySelected && !fridaySelected && !saturdaySelected && !sundaySelected)
                    }
                }.padding(.bottom, 30).padding(.top, 20)
                
                HStack{
                    Text("Habit Name").bold()
                    Spacer()
                }
                HStack{
                    TextField("Name Your Habit", text: $habitNameText).padding(.bottom, 30)
                        .fontWeight(.light)
                        .tint(colorScheme == .light ? .black : .white)
                        .focused($isTextFieldFocused)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isTextFieldFocused = true // Delay to ensure it works
                                
                            }
                        }
                        .onChange(of: habitNameText) { oldValue, newValue in
                            if habitNameText.count > 25 {
                                habitNameText = oldValue
                            }
                        }
                    
                    Text("\(habitNameText.count)/25").foregroundStyle(.gray).fontWeight(.light).padding(.bottom, 30)
                }
                
                HStack{
                    Text("Frequency").bold()
                    Spacer()
                }
                
                VStack(spacing: 15){
                    
                    HStack{
                        Button{
                            sundaySelected.toggle()
                        }label:{
                            HStack{
                                Image(systemName: sundaySelected ? "checkmark.circle" : "circle")
                                Text("Sunday")
                            }
                        }.tint(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                    }
                    
                    HStack{
                        Button{
                            mondaySelected.toggle()
                        }label:{
                            HStack{
                                Image(systemName: mondaySelected ? "checkmark.circle" : "circle")
                                Text("Monday")
                            }
                        }.tint(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                    }
                    
                    HStack{
                        Button{
                            tuesdaySelected.toggle()
                        }label:{
                            HStack{
                                Image(systemName: tuesdaySelected ? "checkmark.circle" : "circle")
                                Text("Tuesday")
                            }
                        }.tint(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                    }
                    HStack{
                        Button{
                            wednesdaySelected.toggle()
                        }label:{
                            HStack{
                                Image(systemName: wednesdaySelected ? "checkmark.circle" : "circle")
                                Text("Wednesday")
                            }
                        }.tint(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                    }
                    HStack{
                        Button{
                            thursdaySelected.toggle()
                        }label:{
                            HStack{
                                Image(systemName: thursdaySelected ? "checkmark.circle" : "circle")
                                Text("Thursday")
                            }
                        }.tint(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                    }
                    HStack{
                        Button{
                            fridaySelected.toggle()
                        }label:{
                            HStack{
                                Image(systemName: fridaySelected ? "checkmark.circle" : "circle")
                                Text("Friday")
                            }
                        }.tint(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                    }
                    HStack{
                        Button{
                            saturdaySelected.toggle()
                        }label:{
                            HStack{
                                Image(systemName: saturdaySelected ? "checkmark.circle" : "circle")
                                Text("Saturday")
                            }
                        }.tint(colorScheme == .light ? .black : .white)
                        
                        Spacer()
                    }
                    
                }.fontWeight(.light).padding(.top, 10)
                
                Spacer()
            }.padding(.horizontal)
        }.background(colorScheme == .light ? Color.white.ignoresSafeArea() : Color.black.ignoresSafeArea())
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
}

#Preview {
    AddNewDailyCheckoffItemView()
}
