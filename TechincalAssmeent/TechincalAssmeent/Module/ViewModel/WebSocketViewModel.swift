//
//  WebSocketViewModel.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 21/02/2024.
//

import Foundation
import Combine

protocol SendMessageViewModelBinding: ObservableObject {
    var recivesMessages: [String] { get set }
    var isAlertPresented: Bool { get set }
}

protocol SendMessageViewModelCommand: ObservableObject {
    func createWebSocketConnection()
    func disconnectWebSocket()
    func sendMessage(_ messageToSend: String)
    func receiveMessages()
}

class SendMessageViewModel: SendMessageViewModelBinding {
    @Published var recivesMessages: [String] = []
    @Published var isAlertPresented: Bool = false

    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables: Set<AnyCancellable> = []

    init() { }
    

}


extension SendMessageViewModel: SendMessageViewModelCommand {
    
    func createWebSocketConnection() {
        guard let url = URL(string: "wss://echo.websocket.org") else {
            return
        }

        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()

        receiveMessages()
    }

    func disconnectWebSocket() {
           webSocketTask?.cancel(with: .goingAway, reason: nil)
           cancellables.removeAll() // Remove all cancellables when disconnecting
       }

    
    func sendMessage(_ messageToSend: String) {
        let message = URLSessionWebSocketTask.Message.string(messageToSend)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket send error: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.isAlertPresented = true
                }
            }
        }
    }



    func receiveMessages() {
        webSocketTask?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    Just(text)
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] receivedText in
                            self?.recivesMessages.append(receivedText)
                        }
                        .store(in: &self.cancellables)
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    break
                }

                // Continue listening for more messages
                self.receiveMessages()

            case .failure(let error):
                print("WebSocket receive error: \(error)")
            }
        }
    }
    
}
