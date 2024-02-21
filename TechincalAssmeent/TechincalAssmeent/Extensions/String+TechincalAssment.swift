//
//  String+TechincalAssment.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 21/02/2024.
//

import Foundation


extension String {

    static func printApplicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
