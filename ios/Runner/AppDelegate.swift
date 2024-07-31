import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var methodChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "com.headspace.simple_news_client/background_service", binaryMessenger: controller.binaryMessenger)

        GeneratedPluginRegistrant.register(with: self)

        // Set up background fetch
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

        // Set the method call handler
        methodChannel?.setMethodCallHandler(handle)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "scheduleFetch" {
            print("scheduleFetch received from Flutter")
            self.scheduleFetchNews()
            result("iosFetchNews")
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func scheduleFetchNews() {
        // Send a message to Flutter to fetch news
        methodChannel?.invokeMethod("fetchNews", arguments: nil, result: { (result) in
            if let error = result as? FlutterError {
                print("Error invoking fetchNews method: \(error)")
            } else {
                print("fetchNews invoked from scheduleFetchNews")
            }
        })

        // Schedule the next call to this method
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) { //30 seconds
            self.scheduleFetchNews()
        }
    }

    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        methodChannel?.invokeMethod("fetchNews", arguments: nil, result: { (result) in
            if let error = result as? FlutterError {
                print("Error invoking fetchNews method: \(error)")
                completionHandler(.failed)
            } else {
                print("fetchNews invoked from background fetch")
                completionHandler(.newData)
            }
        })
    }
}
