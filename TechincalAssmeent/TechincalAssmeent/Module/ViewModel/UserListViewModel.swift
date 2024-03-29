//
//  UserListViewModel.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 20/02/2024.
//

import Foundation
import Combine
import CoreData
import SwiftUI

protocol UserListViewModelBinding: ObservableObject {
    var userList: [UserModel] { get set }
    var isLoading: Bool { get set }
    var isError: Bool { get set }
    var errorMessage: String { get set }
}

protocol UserListViewModelCommand: ObservableObject {
    func fetchUserList()
}



class UserListViewModel: UserListViewModelBinding {
    @Published var errorMessage: String = ""
    @Published var userList: [UserModel] = []
    @Published var isLoading = true
    @Published var isError = false
    var cancelable: Set<AnyCancellable> = []
    @FetchRequest(sortDescriptors: []) var userManagedList: FetchedResults<ManagedUser>
    
  
    
 

    
}
extension UserListViewModel: UserListViewModelCommand {
    func fetchUserList() {

        if !userManagedList.isEmpty {
            for user in userManagedList {
                self.userList.append(UserModel(id: Int(user.id_ ?? "") ?? Int(), name: user.name ?? "", email: user.email ?? "", gender: user.gender  ?? "", status: user.status  ?? ""))
            }
        } else {
            APIClientManager.shared.fetchData(endPoint: .getUserList)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                        self?.errorMessage = error.localizedDescription
                        self?.isError = true
                        self?.isLoading = false
                    }
                }, receiveValue: { (data: UserListModel) in
                    for user in data.data {
                        self.userList.append(UserModel(id: Int(user.id_ ?? "") ?? Int(), name: user.name ?? "", email: user.email ?? "", gender: user.gender  ?? "", status: user.status  ?? ""))
                    }
                    self.isLoading = false
                    self.isError = false
                    print("Received data: \(data)")
                })
                .store(in: &cancelable)
            
        }
    
    }
}
