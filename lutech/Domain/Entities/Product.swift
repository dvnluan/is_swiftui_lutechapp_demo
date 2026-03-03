import Foundation

/// Thực thể Sản phẩm
struct Product: Identifiable, Hashable {
    let id: String
    let name: String
    let price: Double
    let originalPrice: Double?
    let soldCount: Int
    let imageUrl: String
    let description: String
    var isFavorite: Bool
    let categoryId: String
}
