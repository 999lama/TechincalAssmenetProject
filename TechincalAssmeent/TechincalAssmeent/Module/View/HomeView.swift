//
//  HomeView.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 18/02/2024.
//

import SwiftUI

struct HomeView<SendMessageViewModel>: View where SendMessageViewModel: SendMessageViewModelBinding & SendMessageViewModelCommand {
    
    @State private var showUserList = false
    @State private var connectToWebSocket = false
    @StateObject var viewModel: SendMessageViewModel
    @State private var messageToSend: String = ""
    
    var body: some View {
        NavigationStack {
            
            Group {
                if connectToWebSocket {
                    cconnectView
                } else {
                    disconnectView
                }
            }
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
       
                .background(
                NavigationLink(
                    "", destination: UserListView(viewModel: UserListViewModel()),
                   isActive: $showUserList
                 )
                )
            
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(
                              Color.primaryColor,
                              for: .navigationBar)
                          .toolbarBackground(.visible, for: .navigationBar)
              
                
        }
    }
    
    
    var disconnectView: some View {
        VStack {
            Text("Connect to webSocket")
                .foregroundStyle(Color.gray)
            Button(action: {
                connectToWebSocket = true
                viewModel.createWebSocketConnection()
            }, label: {
                Text("Connect")
                    .foregroundStyle(Color.backgroundColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.primaryColor)
                    .cornerRadius(10)
                
            })
        }
    }
    
    var cconnectView: some View {
        VStack {
            HStack {
                Text("Diconnect from webSocket")
                Button(action: {
                    connectToWebSocket = false
                    viewModel.disconnectWebSocket()
                }, label: {
                    Text("Diconnect")
                        .bold()
                        .foregroundStyle(Color.primaryColor)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .cornerRadius(10)
                    
                })
            }
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.recivesMessages.dropFirst(), id: \.self) { message in
                        MessageView(contentMessage: message, isCurrentUser: true)
                        MessageView(contentMessage: message, isCurrentUser: false)
                        
                    }
                }.frame(maxWidth: .infinity)
                    .padding()
                
            }.frame(maxWidth: .infinity)
            
            HStack {
                TextField("Enter message", text: $messageToSend)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(8)
                
                Button(action: {
                    viewModel.sendMessage(messageToSend)
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .tint(Color.primaryColor)
                })
                .padding(8)
            }
            .background(Color.white)
            .padding()
            .alert(isPresented: $viewModel.isAlertPresented) {
                Alert(title: Text("Message Sent"), message: Text("\(messageToSend)"), dismissButton: .default(Text("Dismiss")))
            }
        }
    
    
    }
    

}


