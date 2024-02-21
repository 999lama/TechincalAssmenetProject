//
//  UserListViewModel.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 20/02/2024.
//

import Foundation
import Combine

class UserListViewModel: ObservableObject {
    
    @Published var userList: [UserModel] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    @Published var isLoading = true
    @Published var isError = false
    var cancelable: Set<AnyCancellable> = []
    
    
    func getUsers() {
        APIClientManager.shared.fetchData(endPoint: .getUserList)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.isError = true
                    self?.isLoading = false
                }
            }, receiveValue: { (data: UserList) in
                for user in data.data {
                    self.userList.append(UserModel(id: Int(user.id_ ?? "") ?? Int(), name: user.name ?? "", email: user.email ?? "", gender: user.gender  ?? "", status: user.status  ?? ""))
                }
                self.isLoading = false
                self.isError = false
                print("Received data: \(data)")
            })
            .store(in: &cancelable) // Make sure to store the cancellable to avoid premature deallocation
        
    }
    
}
