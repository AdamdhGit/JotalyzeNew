//
//  ProtectYourDataView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/12/24.
//

import SwiftUI

struct ProtectYourDataView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack{
            
            Color.gray.opacity(0.1).ignoresSafeArea()

            ScrollView{
                VStack(alignment: .leading, spacing: 10){
                    
                    HStack{
                        Spacer()
                        Button("Done"){
                            dismiss()
                        }.tint(colorScheme == .light ? .black : .white).padding(.top, 20)
                            
                    }
                    
                    
                    HStack{
                        Spacer()
                        Text("How We Protect Your Data").bold()
                        
                        Spacer()
                    }.frame(height: 30).padding(.top, 10)
                    
                    HStack{
                        Spacer()
                        Text("Your privacy and security are our top priorities. Read more below about how we safeguard your journal entries.").font(.subheadline).fontWeight(.light).multilineTextAlignment(.center)
                        Spacer()
                    }.padding(.bottom, 15)
                    
                    ZStack{
                            
                            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                        VStack{
                            HStack{
                                Text("Local Encryption")
                                Spacer()
                            }.padding(.bottom, 10)
                            
                            HStack{
                                Text("All your entries are encrypted and securely stored on your device, ensuring that only you can access them, even if your device is lost or compromised.").font(.subheadline).fontWeight(.light).padding(.bottom, 5)
                                Spacer()
                            }
                        }.padding()
                    }
                    
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                        VStack{
                            HStack{
                                Text("Secure Access with Face ID, Touch ID, or Passcode")
                                Spacer()
                            }.padding(.bottom, 10)
                            
                            HStack{
                                Text("For extra protection, we offer the ability to lock your journal using Face ID, Touch ID, or a passcode, making sure your entries remain private and accessible only to you.").font(.subheadline).fontWeight(.light).padding(.bottom, 5)
                                Spacer()
                            }
                        }.padding()
                    }.padding(.bottom, 50)
                    
                  
                    
                }.padding(.horizontal)
            }
             .scrollIndicators(.hidden)
        }.background(colorScheme == .light ? Color.white.ignoresSafeArea() : darkGrayColor.ignoresSafeArea())
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
}

#Preview {
    ProtectYourDataView()
}
