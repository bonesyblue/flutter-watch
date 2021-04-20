//
//  ContentViewModel.swift
//  watchApp Extension
//
//  Created by Jonathan Bones on 20.04.21.
//

import Foundation
import WatchConnectivity

class ContentViewModel: ObservableObject {
    @Published var value: Double = 0
    
    func updateValue(with text: String){
        DispatchQueue.main.async {
            self.value = Double(text) ?? 0
        }
    }
    
    func postValue(){
        print(value)
        let watchSession = WCSession.default
        if watchSession.isReachable {
            DispatchQueue.main.async {
                print("Sending counter to Flutter app")
                watchSession.sendMessage(
                    ["counter": String(format: "%.0f", self.value.rounded())],
                    replyHandler: nil,
                    errorHandler: nil)
            }
        } else {
            print("iOS app not reachable")
        }
    }
}
