import Foundation
import Combine

// MARK: - AuthViewModel
/// @MainActor đảm bảo tất cả UI update đều chạy trên main thread
/// Được tạo một lần duy nhất trong ContentView và inject qua @EnvironmentObject
@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    /// Flag để ContentView biết lúc nào cần popToRoot sau khi logout
    /// Cần dùng flag riêng vì .onChange(of: currentUser) cũng trigger lúc restore session
    @Published var isLoggedOut = false
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository = AuthRepositoryImpl()) {
        self.authRepository = authRepository
        // Khôi phục session từ UserDefaults khi app khởi động
        Task {
            await restoreSession()
        }
    }
    
    // MARK: - Restore Session (Auto Login)
    
    /// Kiểm tra session đã lưu trong UserDefaults → tự động đăng nhập lại nếu còn hợp lệ
    private func restoreSession() async {
        let savedUser = await AppSessionManager.shared.getSavedSession()
        if let user = savedUser {
            self.currentUser = user
            print("🔄 Khôi phục session cho: \(user.name)")
        }
    }
    
    // MARK: - Form Validation (dùng String extensions)
    
    /// Validate form → trả về error message, nil nếu hợp lệ
    private func validateForm() -> String? {
        guard email.trimmed.isNotEmpty else { return "Vui lòng nhập email." }
        guard email.trimmed.isValidEmail else { return "Email không đúng định dạng (vd: user@email.com)." }
        guard password.isNotEmpty else { return "Vui lòng nhập mật khẩu." }
        guard password.isValidPassword else { return "Mật khẩu phải có ít nhất 6 ký tự." }
        return nil
    }
    
    // MARK: - Login
    
    func login() {
        // Validate trước khi gọi API
        if let validationError = validateForm() {
            errorMessage = validationError
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await authRepository.login(email: email.trimmed, password: password)
                self.currentUser = user
                // Xin quyền notification ngay sau khi đăng nhập thành công
                await NotificationManager.shared.requestPermission()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    func loginWithSocial(provider: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let user = try await authRepository.loginWithSocial(provider: provider)
                self.currentUser = user
                await NotificationManager.shared.requestPermission()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        isLoading = true
        Task {
            do {
                try await authRepository.logout()
                self.currentUser = nil
                self.email = ""
                self.password = ""
                // Set flag để ContentView biết cần navigate về Login
                self.isLoggedOut = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    /// Reset flag sau khi ContentView đã xử lý navigation
    func resetLogoutFlag() {
        isLoggedOut = false
    }
}
