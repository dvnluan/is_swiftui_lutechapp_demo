import Foundation

/// Thể hiện của AuthRepository dùng DummyData + AppSessionManager
/// Dùng actor isolation: mọi lời gọi đến DummyDataSource đều được await
class AuthRepositoryImpl: AuthRepository {
    
    func login(email: String, password: String) async throws -> User {
        // Validate input trước (dùng extension String)
        guard email.trimmed.isValidEmail else {
            throw AppError.invalidEmail
        }
        guard password.isValidPassword else {
            throw AppError.weakPassword
        }
        
        // Giả lập độ trễ mạng
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Kiểm tra tài khoản giả lập
        if email.trimmed == "admin@lutech.com" && password == "123456" {
            let user = User(id: "u1", email: email, name: "Admin LU Tech", avatarUrl: "person.circle.fill")
            
            // Lưu session vào UserDefaults
            let fakeToken = "dummy_token_\(UUID().uuidString)"
            await AppSessionManager.shared.saveSession(user: user, accessToken: fakeToken)
            
            // Gửi thông báo chào mừng sau khi login
            await NotificationManager.shared.sendWelcomeNotification(userName: user.name)
            
            return user
        } else {
            throw AppError.invalidCredentials
        }
    }
    
    func loginWithSocial(provider: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let user = User(id: "u_\(provider)", email: "\(provider.lowercased())@example.com", name: "\(provider.capitalized) User", avatarUrl: "person.circle.fill")
        
        let fakeToken = "social_token_\(UUID().uuidString)"
        await AppSessionManager.shared.saveSession(user: user, accessToken: fakeToken)
        await NotificationManager.shared.sendWelcomeNotification(userName: user.name)
        
        return user
    }
    
    func logout() async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        // Xoá session
        await AppSessionManager.shared.clearSession()
    }
    
    func getCurrentUser() -> User? {
        // Kiểm tra session đồng bộ (dùng actor nonconcurrent check)
        // Vì getSavedSession không mutate, ta gọi synchronously qua nonisolated
        // Cách đơn giản: lưu 1 bản cache ở đây để dùng synchronously
        // Trong app thật nên dùng @MainActor hoặc check trước khi show UI
        return nil // Sẽ được check qua AppSessionManager.shared.getSavedSession() trong ContentView
    }
}
