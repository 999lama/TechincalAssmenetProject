//
//  UserListView.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 21/02/2024.
//

import SwiftUI
import CoreData

struct UserListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: UserListViewModel = UserListViewModel()
    
    var body: some View {
        
        Group {
            if viewModel.isLoading && !viewModel.isError {
                ProgressView()
                    .tint(Color.primaryColor)
                    .frame(width: 200, height: 200)
            } else if !viewModel.isLoading && viewModel.isError  {
                Text("Failed to load the data")
                Button(action: {
                    DispatchQueue.main.async {
                        viewModel.fetchUserList()
                    }
                }, label: {
                    Text("Retry")
                        .foregroundStyle(Color.primaryColor)
                        .font(.title3)
                        .bold()
                })
            } else {
                List {
                    ForEach(viewModel.userList, id: \.self) { user in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .bold()
                                    .foregroundStyle(.black)
                                Text(user.email)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Text(user.status)
                                .foregroundColor(user.status == "active" ? .green : .gray)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 70)
                    }
                }
            }
    }
       
        
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                          Color.primaryColor,
                          for: .navigationBar)
                      .toolbarBackground(.visible, for: .navigationBar)
        
    }
    
}


#Preview {
    UserListView()
}
