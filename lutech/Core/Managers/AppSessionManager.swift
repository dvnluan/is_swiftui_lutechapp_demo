import Foundation

// MARK: - AppSessionManager
/// Quản lý trạng thái đăng nhập (persisted qua UserDefaults)
/// Dùng `actor` để đảm bảo thread-safe khi read/write session
actor AppSessionManager {
    
    // Singleton
    static let shared = AppSessionManager()
    
    private init() {}
    
    // Khoá lưu trong UserDefaults
    private let userIdKey = "lutech_logged_user_id"
    private let userNameKey = "lutech_logged_user_name"
    private let userEmailKey = "lutech_logged_user_email"
    private let accessTokenKey = "lutech_access_token"
    
    // MARK: - Lưu session sau khi đăng nhập
    
    /// Lưu thông tin user và access token vào UserDefaults
    /// Trong app thật nên dùng Keychain cho token
    func saveSession(user: User, accessToken: String) {
        UserDefaults.standard.set(user.id, forKey: userIdKey)
        UserDefaults.standard.set(user.name, forKey: userNameKey)
        UserDefaults.standard.set(user.email, forKey: userEmailKey)
        // Lưu access token (nên dùng Keychain ở app thật)
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
        print("✅ Session đã được lưu cho user: \(user.name)")
    }
    
    // MARK: - Xoá session khi logout
    
    /// Xoá toàn bộ session khỏi UserDefaults
    func clearSession() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userNameKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        print("🚪 Session đã được xoá")
    }
    
    // MARK: - Kiểm tra đã đăng nhập chưa
    
    /// Trả về user nếu đã đăng nhập (session còn), ngược lại trả về nil
    func getSavedSession() -> User? {
        guard
            let id = UserDefaults.standard.string(forKey: userIdKey),
            let name = UserDefaults.standard.string(forKey: userNameKey),
            let email = UserDefaults.standard.string(forKey: userEmailKey)
        else {
            return nil // Chưa đăng nhập
        }
        return User(id: id, email: email, name: name, avatarUrl: "person.circle.fill")
    }
    
    /// Lấy access token hiện tại (dùng để gọi API trong app thật)
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    /// Kiểm tra nhanh: đã có session chưa?
    var isLoggedIn: Bool {
        return UserDefaults.standard.string(forKey: userIdKey) != nil
    }
}
