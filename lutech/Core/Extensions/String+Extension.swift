import Foundation

// MARK: - Extension cho String
extension String {
    
    /// Kiểm tra email hợp lệ bằng regex
    var isValidEmail: Bool {
        let pattern = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        return self.range(of: pattern, options: .regularExpression) != nil
    }
    
    /// Kiểm tra mật khẩu tối thiểu 6 ký tự
    var isValidPassword: Bool {
        return count >= 6
    }
    
    /// Bỏ khoảng trắng đầu cuối
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Kiểm tra chuỗi không rỗng (sau khi trim)
    var isNotEmpty: Bool {
        return !trimmed.isEmpty
    }
}
