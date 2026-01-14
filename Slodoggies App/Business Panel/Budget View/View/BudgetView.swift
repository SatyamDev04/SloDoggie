//
//  BudgetView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/09/25.
//

import SwiftUI

struct BudgetView: View {
    @State var adsDetail: adsDataModel
    @State private var selectedReason: String? = nil
    @State private var amount = ""
    @State private var showAmountPicker = false
    @State var errorMessage: String? = nil
    @State var showError: Bool = false
    @EnvironmentObject private var coordinator: Coordinator
    
    let amounts = [
        "10",
        "24",
        "40",
        "52"
    ]
    
    var body: some View {
        ZStack{
            VStack(spacing: 12) {   //  Everything inside VStack
                // Top Bar
                HStack(spacing: 20) {
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text("Budget")
                        .font(.custom("Outfit-Medium", size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#221B22"))
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                // Content
                VStack(spacing: 16) {
                    Text("Select Budget")
                        .font(.custom("Outfit-Medium", size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                    
                    DropdownSelector(
                        title: "",
                        text: $amount,
                        placeholderTxt: "Select Amount",
                        isPickerPresented: $showAmountPicker,
                        options: amounts
                    )
                    .padding(.top, -12)
                    
                    HStack{
                        Text("Ad Budget")
                            .font(.custom("Outfit-Medium", size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "#258694"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top)
                        
                        Spacer()
                        
                        Text("$42 Daily")
                            .font(.custom("Outfit-Medium", size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hex: "#258694"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top)
                        // Spacer()
                    }
                    .padding(.horizontal, 2)
                    
                    // Buttons
                    HStack {
                        Button(action: {
                            if amount.isEmpty{
                                showError = true
                                errorMessage = "Please select amount"
                            }else{
                                self.adsDetail.budget = amount
                                print("====Ads===\n\(self.adsDetail)")
                                coordinator.push(.adsPreviewView(adsDetail))
                            }
                        }){
                            Text("Save & Next")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .font(.custom("Outfit-Bold", size: 15))
                                .foregroundColor(.white)
                                .background(Color(hex: "#258694"))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                
                Spacer()   // Pushes everything to the top
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text(errorMessage ?? ""))
        }
     }
  }

  #Preview {
      BudgetView(adsDetail: adsDataModel())
  }
