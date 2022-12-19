import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyBNkh6iBjAbnTLYqrU5hPxTbAFiJ0ATHhc")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
