import Foundation

/// Thể hiện của ProductRepository - tất cả lời gọi DummyDataSource đều phải await (actor isolation)
class ProductRepositoryImpl: ProductRepository {
    
    func getCategories() async throws -> [Category] {
        try await Task.sleep(nanoseconds: 300_000_000)
        // Lấy dữ liệu từ actor (must be awaited)
        return await DummyDataSource.shared.categories
    }
    
    func getProducts(categoryId: String?) async throws -> [Product] {
        try await Task.sleep(nanoseconds: 300_000_000)
        if let categoryId {
            return await DummyDataSource.shared.getProducts(by: categoryId)
        }
        return await DummyDataSource.shared.getProducts()
    }
    
    func getPhoneProducts() async throws -> [Product] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return await DummyDataSource.shared.getProducts(by: "1")
    }
    
    func getTabletProducts() async throws -> [Product] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return await DummyDataSource.shared.getProducts(by: "2")
    }
    
    func getFavoriteProducts() async throws -> [Product] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return await DummyDataSource.shared.getFavorites()
    }
    
    func getTestimonials() async throws -> [Testimonial] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return await DummyDataSource.shared.testimonials
    }
    
    func toggleFavorite(productId: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 200_000_000)
        // toggleFavorite trên actor, tự động thread-safe
        return await DummyDataSource.shared.toggleFavorite(productId: productId)
    }
}
