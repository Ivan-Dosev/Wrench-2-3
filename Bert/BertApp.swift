//2
//  BertApp.swift
//  Bert
//
//  Created by Ivan Dimitrov on 30.07.21.
//

import SwiftUI
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("SwiftUI_2_Lifecycle_PhoneNumber_AuthApp application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("\(#function)")
    Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("\(#function)")
    if Auth.auth().canHandleNotification(notification) {
      completionHandler(.noData)
      return
    }
  }
  
  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    print("\(#function)")
    if Auth.auth().canHandle(url) {
      return true
    }
    return false
  }
}

@main
struct BertApp: App {
    
//    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { (url) in

                    Auth.auth().canHandle(url.absoluteURL)
             
            }
        }
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      for urlContext in URLContexts {
          let url = urlContext.url
          Auth.auth().canHandle(url)
      }
      // URL not auth related, developer should handle it.
    }
}
