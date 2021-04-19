import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Activate the watch session if supported
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        if let controller = window?.rootViewController as? FlutterViewController {
            setupMethodChannels(with: controller)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupMethodChannels(with controller: FlutterViewController){
        let channelId = "com.example.watchExtension/methodChannel"
        let channel = FlutterMethodChannel(
            name: channelId,
            binaryMessenger: controller.binaryMessenger
        )
        channel.setMethodCallHandler { (call, result) in
            // Handle the method calls below
            switch call.method {
            case "postString":
                if let text = call.arguments as? String {
                    self.handleText(text: text)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func handleText(text: String){
        print(text)
        let watchSession = WCSession.default
        if watchSession.isPaired && watchSession.isReachable {
            DispatchQueue.main.async {
                print("Sending counter state to watch extension")
                watchSession.sendMessage(
                    ["counter": text],
                    replyHandler: nil,
                    errorHandler: nil)
            }
        } else {
            print("Watch not reachable")
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
