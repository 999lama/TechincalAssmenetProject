//
//  MessageView.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 21/02/2024.
//

import SwiftUI

struct MessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
            HStack{
                if !isCurrentUser {
                    Image(systemName: "circle.fill")
                        .font(.largeTitle)
                }
                Text(contentMessage)
                    .padding(10)
                    .foregroundColor(isCurrentUser ? Color.white : Color.black)
                    .background(isCurrentUser ? Color.primaryColor : Color(UIColor.systemGray6 ))
                    .cornerRadius(10)
            
                if isCurrentUser {
                    Image(systemName: "person.circle.fill")
                        .font(.largeTitle)
                }
         
            }.frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
    }
}

