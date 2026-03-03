import Foundation

// MARK: - Sample Data dùng cho Preview và Testing
/// Không dùng actor, chỉ là dữ liệu tĩnh cho #Preview
enum SampleData {
    
    static let product = Product(
        id: "preview_1",
        name: "iPhone 15 Pro Max 256GB",
        price: 34_990_000,
        originalPrice: 35_990_000,
        soldCount: 1542,
        imageUrl: "iphone",
        description: "iPhone 15 Pro Max là siêu phẩm mới nhất của Apple với thiết kế titan đẳng cấp, vi xử lý A17 Pro mạnh mẽ và hệ thống camera zoom quang 5x ấn tượng.",
        isFavorite: false,
        categoryId: "1"
    )
    
    static let products: [Product] = [
        product,
        Product(id: "preview_2", name: "Samsung Galaxy S24 Ultra", price: 33_990_000, originalPrice: 37_990_000, soldCount: 856, imageUrl: "candybarphone", description: "Galaxy AI đã ra mắt.", isFavorite: true, categoryId: "1")
    ]
    
    static let category = Category(id: "1", name: "Điện thoại", iconSystemName: "candybarphone")
    
    static let testimonial = Testimonial(id: "1", customerName: "Nguyễn Văn A", avatarUrl: "person.circle.fill", content: "Sản phẩm chất lượng, giao hàng cực kỳ nhanh chóng!", rating: 5)
}
