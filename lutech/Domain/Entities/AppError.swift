import Foundation

// MARK: - AppError
/// Custom error enum cho toàn bộ app - tốt hơn dùng NSError thô
enum AppError: LocalizedError {
    case invalidEmail
    case weakPassword
    case invalidCredentials
    case networkError
    case unknown(Error)
    
    // Thông báo lỗi hiển thị cho người dùng (tiếng Việt)
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Email không hợp lệ. Vui lòng kiểm tra lại."
        case .weakPassword:
            return "Mật khẩu phải có ít nhất 6 ký tự."
        case .invalidCredentials:
            return "Email hoặc mật khẩu không chính xác."
        case .networkError:
            return "Lỗi kết nối mạng. Vui lòng thử lại."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
