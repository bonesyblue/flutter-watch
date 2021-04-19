import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
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
    }
}
