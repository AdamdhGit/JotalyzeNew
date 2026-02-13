//
//  TestNewViews.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/21/25.
//

import SwiftUI

struct TestNewViews: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var showColor = false
    @State var selectedDate:Date = Date()
    
    var body: some View {
        
        ZStack{
            
            HStack{
                RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray).frame(width: 250, height: 15).opacity(0.3)
                Spacer()
            }
            
            HStack{
                RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .black : .white).frame(width: 250, height: 15)
                Spacer()
            }.mask{
                
                HStack{
                    
                    Rectangle().frame(width: 150, height: 15)
                    Spacer()
                }
            }
            
        }.padding(.leading)
        
        DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute).labelsHidden().accessibilityLabel("Select A Time")
        
        Button("color"){
            showColor.toggle()
        }
        ZStack{
            Color.red
            Color.blue
        }.frame(height: 50).opacity(showColor ? 1 : 0)
        
        ScrollView(.horizontal){
            HStack{
                ForEach(0..<20){i in
                    Text("Test").background(.red)
                }
            }
        }.frame(width: 200).clipShape(RoundedRectangle(cornerRadius: 10))
        
        Rectangle().frame(width: 200, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        Button("Test"){
            
        }
        
        Button{
            
        }label:{
            Text("Test")
        }
        Text("test")
        
        HStack{
            Button{
                
            }label:{
                Image(systemName: "chevron.right")
            }
        }
        
    }
}

#Preview {
    TestNewViews()
}
