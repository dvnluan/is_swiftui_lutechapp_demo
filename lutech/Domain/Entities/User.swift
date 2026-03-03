import Foundation

/// Thực thể Người dùng
struct User: Identifiable {
    let id: String
    let email: String
    let name: String
    let avatarUrl: String?
}
