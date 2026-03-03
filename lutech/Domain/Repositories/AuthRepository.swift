import Foundation

/// Giao diện kho lưu trữ Xác thực
protocol AuthRepository {
    func login(email: String, password: String) async throws -> User
    func loginWithSocial(provider: String) async throws -> User
    func logout() async throws
    func getCurrentUser() -> User?
}
