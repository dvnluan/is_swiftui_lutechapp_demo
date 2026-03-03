import Foundation

/// Thực thể Danh mục
struct Category: Identifiable, Hashable {
    let id: String
    let name: String
    let iconSystemName: String // Tên icon từ SF Symbols
}
