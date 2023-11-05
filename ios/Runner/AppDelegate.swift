import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
//        let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
//                                                  binaryMessenger: controller.binaryMessenger)
//        batteryChannel.setMethodCallHandler({
//            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//            // This method is invoked on the UI thread.
//            // Handle battery messages.
//        })
        let objDetectChannel = FlutterMethodChannel(name: "call_native_manager",
                                                  binaryMessenger: controller.binaryMessenger)
        objDetectChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // This method is invoked on the UI thread.
            // Handle battery messages.
            NSLog("\n setMethodCallHandler \(call.method)")
            if call.method == ""{
                ObjectDetectManager.shared.detect(result: result)
            }else{
                result(FlutterMethodNotImplemented)
                return
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}