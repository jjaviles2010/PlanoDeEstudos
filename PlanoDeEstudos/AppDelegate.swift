import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        center.delegate = self
        
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                print("Valeu meu truta!!!")
            case .denied:
                print("Qual é??")
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .sound, .carPlay, .badge]) { (accepted, error) in
                    if(accepted) {
                        print("Usuario aceitou")
                    } else {
                        print("Usuario recusou!")
                    }
                }
            case .provisional:
                break
            @unknown default:
                break
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: "Confirm", title: "Confirmar 👍🏼", options: [.foreground])
        
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancelar", options: [])
        
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], options: [.customDismissAction])
        
        center.setNotificationCategories([category])
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let id = response.notification.request.identifier
        let body = response.notification.request.content.body
        
        switch response.actionIdentifier {
        case "Confirm":
            print("Confirmou!!")
            NotificationCenter.default.post(name: Notification.Name("Confirmed"), object: nil, userInfo: ["id": id])
        case "Cancel":
            print("Cancelou")
        case UNNotificationDefaultActionIdentifier:
            print("Tocou na notificacao")
        case UNNotificationDismissActionIdentifier:
            print("Fez dismiss")
        default:
            print("Outro cenario")
        }
        
        completionHandler()
        
    }
    

}
