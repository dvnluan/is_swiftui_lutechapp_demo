import Foundation

/// Giao diện kho lưu trữ Sản phẩm và Dữ liệu trang chủ
protocol ProductRepository {
    func getCategories() async throws -> [Category]
    func getProducts(categoryId: String?) async throws -> [Product]
    func getPhoneProducts() async throws -> [Product]
    func getTabletProducts() async throws -> [Product]
    func getFavoriteProducts() async throws -> [Product]
    func getTestimonials() async throws -> [Testimonial]
    func toggleFavorite(productId: String) async throws -> Bool
}
