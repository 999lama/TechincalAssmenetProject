//
//  TechincalAssmeentApp.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 21/02/2024.
//

import SwiftUI

@main
struct TechincalAssmeentApp: App {
    let persistenceController = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    String.printApplicationDocumentsDirectory()
                }
        }
    }
}
