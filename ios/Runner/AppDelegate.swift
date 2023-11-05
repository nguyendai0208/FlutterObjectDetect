import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        _ = ObjectDetectManager.shared
        let objDetectChannel = FlutterMethodChannel(name: "call_native_manager",
                                                  binaryMessenger: controller.binaryMessenger)
        objDetectChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // This method is invoked on the UI thread.
            // Handle battery messages.
            NSLog("\n setMethodCallHandler \(call.method)")
            if call.method == "detect",
               let dicArg = call.arguments as? Dictionary<String, Any>,
               let data = dicArg["img"] as? FlutterStandardTypedData,
               let image = UIImage(data: data.data){
                ObjectDetectManager.shared.detect2(image: image, result: result)
            }else{
                result(FlutterMethodNotImplemented)
                return
            }
        })
//        let objDetectChannel = FlutterBasicMessageChannel(name: "call_native_manager",
//                                                  binaryMessenger: controller.binaryMessenger,
//                                                          codec: FlutterBinaryCodec.sharedInstance())
//        objDetectChannel.setMethodCallHandler({
//            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//            // This method is invoked on the UI thread.
//            // Handle battery messages.
//            NSLog("\n setMethodCallHandler \(call.method)")
//            if call.method == "detect"{
//                ObjectDetectManager.shared.detect(result: result)
//            }else{
//                result(FlutterMethodNotImplemented)
//                return
//            }
//        })
//        objDetectChannel.setMessageHandler {
//            (message: Any?, reply: FlutterReply) -> Void in
//            var method = ""
//            if let message = message as? Data, let msg = String(data: message, encoding: .utf8){
//                method = msg.replacingOccurrences(of: "\u{07}\u{06}", with: "")
//            }
//            NSLog("\n setMethodCallHandler \(method)")
//            if method == "detect"{
//                ObjectDetectManager.shared.detect(result: reply)
//                return
//            }else{
////                reply(FlutterMethodNotImplemented)
//                reply(nil)
//                return
//            }
//        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
