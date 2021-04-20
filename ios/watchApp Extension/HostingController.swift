//
//  HostingController.swift
//  watchApp Extension
//
//  Created by Jonathan Bones on 19.04.21.
//

import WatchKit
import WatchConnectivity
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView>  {
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    override var body: ContentView {
        return ContentView(model: viewModel)
    }
}

extension HostingController: WCSessionDelegate {
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let counterValue = message["counter"] as? String {
            viewModel.updateValue(with: counterValue)
        }
    }
}
