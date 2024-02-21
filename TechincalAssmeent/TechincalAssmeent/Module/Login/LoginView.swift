//
//  LoginView.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 18/02/2024.
//

import SwiftUI


struct LoginView: View {
    
    @State var userName: String = ""
    @State var password: String = ""
    @State var isLoginSuccess = false
    @State var enableLoginButton = false
    @State var showPopUp = false

    
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
            
                .fullScreenCover(isPresented: $isLoginSuccess, content: {
//                    HomeView()
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
        savePassword()
    }
 
    func savePassword() {
        let keychainItem = KeychainItem(service: "TechincalAssmeent.com", account: userName, password: password)
        
        do {
            try keychainItem.savePassword()
            isLoginSuccess = true
//            UserManager.shared.loginUser(username: userName)
        } catch {
            print(error)
        }
    }
    
    func doTheJob() {
        Task {
            let keychainItem = KeychainItem(service: "YourAppService", account: "user@example.com", password: "securePassword")
            
            do {
                try keychainItem.savePassword()
                let loadedPassword = try keychainItem.loadPassword()
                try keychainItem.deletePassword()
                print("Loaded password \(loadedPassword)")
            } catch {
                print(error)
            }
        }
    }
    
}

#Preview {
    LoginView()
}

