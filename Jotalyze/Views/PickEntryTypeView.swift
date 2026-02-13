//
//  PickEntryTypeView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/21/25.
//

import SwiftUI

struct PickEntryTypeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Binding var moodCheckInSelected: Bool
    @Binding var gratitudeSelected: Bool
    @Binding var goalTrackingEntrySelected: Bool
    @Binding var captureTheMomentSelected: Bool
    
    var body: some View {
            ZStack{
                    Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing: 20){
                    Text("CHOOSE ENTRY TYPE").bold().font(.caption).padding(.bottom, -10).padding(.top, 20)
                    
                    Button{
                        dismiss()
                        moodCheckInSelected = true
                    }label:{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 300, height: 50).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2).padding(.horizontal)
                            HStack{
                                Image(systemName: "cloud.sun")
                                Text("Mood Check-In")
                            }.fontWeight(.light).font(.subheadline)
                            
                        }.padding(.top,30)
                    }.buttonStyle(.plain)
                    
                    
                    Button{
                        dismiss()
                        gratitudeSelected = true
                    }label:{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 300, height: 50).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2).padding(.horizontal)
                            HStack{
                                Image(systemName: "heart")
                                Text("Gratitude")
                                
                            }.fontWeight(.light).font(.subheadline)
                        }
                    }.buttonStyle(.plain)
                    
                    
                    
                    Button{
                        dismiss()
                        goalTrackingEntrySelected = true
                    }label:{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 300, height: 50).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2).padding(.horizontal)
                            HStack{
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                Text("Goal Tracking")
                                
                            }.fontWeight(.light).font(.subheadline)
                        }
                    }.buttonStyle(.plain)
                    
                    Button{
                        dismiss()
                        captureTheMomentSelected = true
                    }label:{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 300, height: 50).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2).padding(.horizontal)
                            HStack{
                                Image(systemName: "camera")
                                Text("Capture The Moment")
                                
                            }.fontWeight(.light).font(.subheadline)
                        }
                    }.buttonStyle(.plain)
                    
                    
                    Spacer()
                    
                }
            }.background(colorScheme == .light ? Color.white.ignoresSafeArea() : darkGrayColor.ignoresSafeArea())
        
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
}

#Preview {
    PickEntryTypeView(moodCheckInSelected: .constant(false), gratitudeSelected: .constant(false), goalTrackingEntrySelected: .constant(false), captureTheMomentSelected: .constant(false))
}
