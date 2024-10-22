import FirebaseMessaging
import UIKit
import Flutter
import Firebase
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    // TODO. 스플래시 딜레이 3초
    // Thread.sleep(forTimeInterval: 3.0)

    // 앱이 종료된 상태에서 푸시 알림을 통해 실행되었을 때
    if let remoteNotification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
      handleRemoteNotification(remoteNotification)
    }

    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.badge, .sound, .alert]

        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    print("Error requesting notification authorization: \(error.localizedDescription)")
                } else {
                    print("Permission granted: \(granted)")
                    if granted {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                    }
                }
            }
        )
    } else {
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    Messaging.messaging().delegate = self

    // 여기서 withRegistry:를 with:로 수정합니다.
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 앱이 종료된 상태에서 푸시 알림을 통해 실행되었을 때 처리
  private func handleRemoteNotification(_ userInfo: [AnyHashable: Any]) {
    if let id = userInfo["targetId"], let category = userInfo["category"] {
        // Flutter에 데이터 전달
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 딜레이를 추가하여 MethodChannel이 초기화되도록 함
            if let flutterViewController = self.window?.rootViewController as? FlutterViewController {
                let methodChannel = FlutterMethodChannel(name: "com.sungkyul/notification", binaryMessenger: flutterViewController.binaryMessenger)
                
                let notificationData: [String: Any] = ["id": id, "category": category]
                print("Sending data to Flutter: id = \(id), category = \(category)")
                methodChannel.invokeMethod("navigateToDetail", arguments: notificationData)
            }
        }
    } else {
        print("Invalid id or category in userInfo: \(userInfo["id"]), \(userInfo["category"])")
    }
}

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }

  // 앱이 실행 중인 경우
  // MARK: - UNUserNotificationCenterDelegate
  @available(iOS 10, *)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    print("Message ID: \(userInfo["gcm.message_id"] ?? "")")
    print(userInfo)
    
    completionHandler([.alert, .badge, .sound])
  }

  // 백그라운드인 경우 & 사용자가 푸시를 클릭한 경우
  @available(iOS 10.0, *)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
      
    if let id = userInfo["targetId"], let category = userInfo["category"] {
      // Flutter에 데이터 전달
      if let flutterViewController = window?.rootViewController as? FlutterViewController {
        let methodChannel = FlutterMethodChannel(name: "com.sungkyul/notification", binaryMessenger: flutterViewController.binaryMessenger)
        
        let notificationData: [String: Any] = ["id": id, "category": category]
        print("Sending data to Flutter: id = \(id), category = \(category)")
        methodChannel.invokeMethod("navigateToDetail", arguments: notificationData)
      }
    } else {
      // id나 category가 누락되었거나 타입이 맞지 않을 때 오류 출력
      print("Invalid id or category in userInfo: \(userInfo["id"]), \(userInfo["category"])")
    } 

    print("Message ID: \(userInfo["gcm.message_id"] ?? "")")
    print(userInfo)
    
    completionHandler()
  }

  // MARK: - MessagingDelegate
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    if let _ = fcmToken {
        // 서버로 토큰 전송 로직이 필요하다면 여기에 추가
    }
  }
}
