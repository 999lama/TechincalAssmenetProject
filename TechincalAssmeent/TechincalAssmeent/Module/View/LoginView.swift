//
//  LoginView.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 18/02/2024.
//

import SwiftUI


struct LoginView <ViewModel>: View  where ViewModel: LoginViewModelBinding & LoginViewModelCommand {
    
    @State var userName: String = ""
    @State var password: String = ""
    @State var enableLoginButton = false
    @State var showPopUp = false
   
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
    
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                VStack(alignment: .center ) {
                    Text("Hello,")
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(Color.primaryColor)
                    
                    VStack {
                        TextField("Username", text: $userName)
                            .textContentType(.username)
                            .onChange(of: userName, {
                                handleEnableButton()
                            })
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .onChange(of: password, {
                                
                                handleEnableButton()
                            })
                        
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                    
              
                    
                    Button(action: {
                        self.handleLogin()
                    }, label: {
                        Text("Login")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 10)
                            .background(enableLoginButton ? Color.primaryColor : .gray)
                            .cornerRadius(10)
                        
                    })
                    .disabled(!enableLoginButton)
            
                    .fullScreenCover(isPresented: $viewModel.isLoginSuccess, content: {
                    HomeView(viewModel: SendMessageViewModel())
                })
            }
            .onAppear{
                
            }
        }
    }
    
    func handleEnableButton()  {
        enableLoginButton = !userName.isEmpty && !password.isEmpty ? true : false
    }
    
    func handleLogin() {
        guard !userName.isEmpty && !password.isEmpty else {
            print("Error please enter a password or username")
            return
        }
        viewModel.savePasswordToKeychain(with: userName, and: password)
    }
 

    
}


