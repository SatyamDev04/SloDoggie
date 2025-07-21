//
//  RenameCommunityView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//
import SwiftUI

struct RenameCommunitySheet: View {
    @Binding var isPresented: Bool
    @State private var newCommunityName: String
    let onRename: (String) -> Void
    
    init(isPresented: Binding<Bool>, currentName: String, onRename: @escaping (String) -> Void) {
        _isPresented = isPresented
        _newCommunityName = State(initialValue: currentName)
        self.onRename = onRename
    }
    
    var body: some View {
        ZStack {
            ZStack {
                // Background dimming
                Color(hex: "#3C3C434A").opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    HStack{
                        Spacer()
                        Button(action: {
                            isPresented = false
                        }) {
                            Image("crossIcon")
                                .resizable()
                                .frame(width: 38, height: 38)
                                .background(Color.white.clipShape(Circle()))
                                .padding(.bottom, -15)
                                .padding(.trailing, 30)
                        }
                    }
                    .offset(x: 10, y: -10)
                    
                    VStack{
                        HStack {
                            Text("Name Community")
                                .font(.custom("Outfit-Medium", size: 18))
                                .padding(.bottom, 2)
                            Spacer()
                        }
                        Divider()
                        
                        TextField("Event Community", text: $newCommunityName)
                            .padding(.horizontal)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                        
                        HStack {
                            Button("Cancel") {
                                isPresented = false
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.black)
                            .font(.custom("Outfit-Medium", size: 16))
                            
                            Button("Rename") {
                                onRename(newCommunityName)
                                isPresented = false
                            }
                            .font(.custom("Outfit-Medium", size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            
                            .background(Color(hex: "#258694"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                    .cornerRadius(14)
                    .background(Color.white)
                    .cornerRadius(10, corners: .allCorners)
                }
                
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
     }
  }

struct RenameCommunitySheet_Previews: PreviewProvider {
    static var previews: some View {
        RenameCommunitySheet(
            isPresented: .constant(true),
            currentName: "Event Community 1"
        ) { newName in
            print("Renamed to: \(newName)")
        }
    }
}

