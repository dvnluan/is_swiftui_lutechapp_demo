import SwiftUI
import UserNotifications

@main
struct lutechApp: App {
    
    // UIApplicationDelegate để handle notification events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - AppDelegate
/// Xử lý notification lifecycle và các app-level events
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Đăng ký AppDelegate làm notification delegate
        // → cho phép nhận notification ngay cả khi app đang mở (foreground)
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // MARK: - Hiển thị notification khi app đang ở foreground
    
    /// Mặc định iOS không show notification khi app đang mở.
    /// Method này cho phép override và show notification dạng banner ngay trong app
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Hiện thông báo dạng banner + sound dù app đang mở
        completionHandler([.banner, .sound])
    }
    
    /// Xử lý khi người dùng bấm vào notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("📲 Người dùng bấm vào notification: \(response.notification.request.content.title)")
        completionHandler()
    }
}
