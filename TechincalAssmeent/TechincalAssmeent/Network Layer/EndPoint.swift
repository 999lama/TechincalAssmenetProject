//
//  EndPoint.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 19/02/2024.
//

import Foundation

/// Enum representing various API endpoints.
enum Endpoint {
    case getUserList
    
    var baseURL: String {
        switch self {
        default:
            return Constant.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .getUserList:
            return "/users"
        }
    }
    
    var urlString: String {
        return baseURL + path
    }
}
