//
//  HomeView.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 18/02/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showUserList = false
    
    var body: some View {
        NavigationStack {
            Text("Connect to webSocket")
                .foregroundStyle(Color.gray)
            Button(action: {}, label: {
                Text("Connect")
                    .foregroundStyle(Color.backgroundColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.primaryColor)
                    .cornerRadius(10)
                
            })
               
            .navigationTitle("Hello, \(UseCredentials.shared.username)")
                .tint(.white)
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showUserList = true
                        }, label: {
                            Text("User List")
                                .foregroundStyle(Color.primaryColor)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.backgroundColor)
                                .cornerRadius(10)
                            
                        })
                    }
                 
                }
            
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(
                              Color.primaryColor,
                              for: .navigationBar)
                          .toolbarBackground(.visible, for: .navigationBar)
              
                
        }
    }
}

#Preview {
    HomeView()
}
