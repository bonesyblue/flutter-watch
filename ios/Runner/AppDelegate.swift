import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    static var eventSink: FlutterEventSink?
    
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
            setupFlutterChannels(with: controller)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupFlutterChannels(with controller: FlutterViewController){
        let methodChannelId = "com.example.watchExtension/methodChannel"
        let methodChannel = FlutterMethodChannel(
            name: methodChannelId,
            binaryMessenger: controller.binaryMessenger
        )
        methodChannel.setMethodCallHandler { (call, result) in
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
        
        let eventChannelId = "com.example.watchExtension/eventChannel"
        let eventChannel = FlutterEventChannel(
            name: eventChannelId,
            binaryMessenger: controller.binaryMessenger
        )
        eventChannel.setStreamHandler(self)
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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let counterValue = message["counter"] as? String {
            // If the event sink is available, post the value received from the WatchKit extension
            AppDelegate.eventSink?(counterValue)
        }
    }
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        /**
         The event sink can be used to send data back to the Flutter client. See https://flutter.dev/docs/development/platform-integration/platform-channels#codec for supported data types and codecs. Add data to the stream by calling events(data). Use FlutterError to send errors and FlutterEndOfEventStream to signal completion of events.
        */
        AppDelegate.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        AppDelegate.eventSink = nil
        return nil
    }
    
    
}
