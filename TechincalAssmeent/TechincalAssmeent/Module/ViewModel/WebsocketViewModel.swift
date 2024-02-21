//
//  WebsocketViewModel.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 21/02/2024.
//

import Foundation
import Combine


class SendMessageViewModel: ObservableObject {
    @Published var recivesMessages: [String] = []
    @Published var isAlertPresented: Bool = false

    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables: Set<AnyCancellable> = []

    init() { }
    
    func createWebSocketConnection() {
        guard let url = URL(string: "wss://echo.websocket.org") else {
            return
        }

        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()

        receiveMessages()
    }

    // Function to send a message through WebSocket connection
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


    // Function to handle received messages through WebSocket connection
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
