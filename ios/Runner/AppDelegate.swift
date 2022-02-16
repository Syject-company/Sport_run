import UIKit
import Flutter
import Firebase
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
      
      UNUserNotificationCenter.current().delegate = self
               
              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
               
              UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (_, error) in
                  guard error == nil else{
                      print(error!.localizedDescription)
                      return
                  }
              }
               
              application.registerForRemoteNotifications()

      
      return true
  }
    
}
