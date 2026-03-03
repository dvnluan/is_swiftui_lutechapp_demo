import Foundation
import UserNotifications

// MARK: - Notification Manager
/// Quản lý toàn bộ việc xin quyền và gửi thông báo local
/// Dùng `actor` để đảm bảo thread-safe khi gọi từ nhiều nơi
actor NotificationManager {
    
    // Singleton để dùng chung trong toàn app
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Xin quyền thông báo
    
    /// Yêu cầu người dùng cấp quyền nhận thông báo
    /// Nên gọi sau khi người dùng đã đăng nhập thành công
    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            // Xin quyền hiển thị thông báo, âm thanh và badge
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                print("🔔 Quyền thông báo đã được cấp")
            } else {
                print("🔕 Người dùng từ chối quyền thông báo")
            }
        } catch {
            print("❌ Lỗi xin quyền: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Kiểm tra trạng thái quyền
    
    /// Kiểm tra xem quyền thông báo có được cấp không
    func isAuthorized() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus == .authorized
    }
    
    // MARK: - Gửi thông báo Local
    
    /// Gửi thông báo khi người dùng thêm sản phẩm vào yêu thích
    func sendFavoriteNotification(productName: String) async {
        // Kiểm tra quyền trước khi gửi
        guard await isAuthorized() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "LU Tech ❤️"
        content.body = "Đã thêm \"\(productName)\" vào yêu thích!"
        content.sound = .default
        
        // Trigger ngay lập tức (delay 0.5s để tránh gửi trùng)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("❌ Gửi thông báo lỗi: \(error)")
        }
    }
    
    /// Gửi thông báo chào mừng sau khi đăng nhập
    func sendWelcomeNotification(userName: String) async {
        guard await isAuthorized() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Chào mừng trở lại! 👋"
        content.body = "Xin chào \(userName), hôm nay có nhiều ưu đãi hấp dẫn cho bạn!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "welcome_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        try? await UNUserNotificationCenter.current().add(request)
    }
}
