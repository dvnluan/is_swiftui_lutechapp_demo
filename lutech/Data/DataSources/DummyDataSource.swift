import Foundation

/// Actor đảm bảo thread-safe khi đọc/ghi dữ liệu giả
/// Trong app thật, đây sẽ là NetworkService hoặc DatabaseService
actor DummyDataSource {
    
    // Singleton thread-safe
    static let shared = DummyDataSource()
    
    private init() {}
    
    // MARK: - Dữ liệu danh mục
    let categories: [Category] = [
        Category(id: "1", name: "Điện thoại",    iconSystemName: "candybarphone"),
        Category(id: "2", name: "Máy tính bảng", iconSystemName: "ipad"),
        Category(id: "3", name: "Laptop",        iconSystemName: "laptopcomputer"),
        Category(id: "4", name: "Phụ kiện",      iconSystemName: "headphones"),
        Category(id: "5", name: "Đồng hồ",       iconSystemName: "applewatch")
    ]
    
    // MARK: - Dữ liệu sản phẩm (private để kiểm soát mutation)
    private var _products: [Product] = [
        // Điện thoại
        Product(id: "p1", name: "iPhone 15 Pro Max 256GB",  price: 34_990_000, originalPrice: 35_990_000, soldCount: 1542, imageUrl: "iphone",       description: "iPhone 15 Pro Max là siêu phẩm mới nhất của Apple với thiết kế titan đẳng cấp, vi xử lý A17 Pro mạnh mẽ và hệ thống camera zoom quang 5x ấn tượng.\n\nSản phẩm chính hãng VN/A, nguyên seal, bảo hành 12 tháng tại các trung tâm ủy quyền của Apple Việt Nam.", isFavorite: false, categoryId: "1"),
        Product(id: "p2", name: "Samsung Galaxy S24 Ultra",  price: 33_990_000, originalPrice: 37_990_000, soldCount: 856,  imageUrl: "candybarphone", description: "Galaxy AI đã ra mắt. Thiết kế khung titan bền bỉ. Bút S Pen tích hợp sẵn.", isFavorite: true,  categoryId: "1"),
        Product(id: "p3", name: "Oppo Find X7 Ultra",        price: 29_990_000, originalPrice: nil,         soldCount: 320,  imageUrl: "candybarphone", description: "Camera tele kép độc nhất. Hiệu năng đỉnh cao với chip Snapdragon 8 Gen 3.", isFavorite: false, categoryId: "1"),
        Product(id: "p4", name: "iPhone 14 Pro 128GB",       price: 24_990_000, originalPrice: 27_990_000, soldCount: 4210, imageUrl: "iphone",       description: "Camera 48MP sắc nét. Dynamic Island độc đáo.", isFavorite: false, categoryId: "1"),
        
        // Máy tính bảng
        Product(id: "t1", name: "iPad Pro 11 inch M2",     price: 21_990_000, originalPrice: 23_990_000, soldCount: 1120, imageUrl: "ipad",           description: "Hiệu năng M2 vô song. Màn hình Liquid Retina mượt mà. Hỗ trợ Apple Pencil 2.", isFavorite: true,  categoryId: "2"),
        Product(id: "t2", name: "Samsung Galaxy Tab S9",   price: 19_990_000, originalPrice: 22_990_000, soldCount: 650,  imageUrl: "ipad.landscape", description: "Chống nước IP68. Màn hình Dynamic AMOLED 2X rực rỡ.", isFavorite: false, categoryId: "2"),
        Product(id: "t3", name: "iPad Air 5 M1",           price: 14_990_000, originalPrice: 16_990_000, soldCount: 3200, imageUrl: "ipad",           description: "Hiệu năng cực đỉnh với chip M1. Màu sắc trẻ trung.", isFavorite: false, categoryId: "2"),
        Product(id: "t4", name: "Lenovo Tab P12 Pro",      price: 16_990_000, originalPrice: nil,         soldCount: 154,  imageUrl: "ipad.landscape", description: "Màn hình lớn 12.6 inch AMOLED. Kèm bút cảm ứng.", isFavorite: false, categoryId: "2")
    ]
    
    // MARK: - Dữ liệu testimonial
    let testimonials: [Testimonial] = [
        Testimonial(id: "1", customerName: "Nguyễn Văn A", avatarUrl: "person.circle.fill", content: "Sản phẩm chất lượng, giao hàng cực kỳ nhanh chóng. Rất hài lòng với LU Tech!", rating: 5),
        Testimonial(id: "2", customerName: "Trần Thị B",   avatarUrl: "person.circle.fill", content: "Giá tốt hơn nhiều so với các chỗ khác. Mua iPhone ở đây là yên tâm nhất. Vote 5 sao.", rating: 5),
        Testimonial(id: "3", customerName: "Lê Hoàng C",   avatarUrl: "person.circle.fill", content: "Nhân viên tư vấn nhiệt tình. Sẽ ủng hộ LU Tech lâu dài.", rating: 4)
    ]
    
    // MARK: - Read Methods (trả về copy để tránh data race)
    
    func getProducts() -> [Product] { _products }
    
    func getProducts(by categoryId: String) -> [Product] {
        _products.filter { $0.categoryId == categoryId }
    }
    
    func getFavorites() -> [Product] {
        _products.filter { $0.isFavorite }
    }
    
    // MARK: - Write Methods
    
    /// Toggle favourite và trả về trạng thái mới.
    /// Vì đây là `actor`, việc gọi method này an toàn từ mọi thread.
    @discardableResult
    func toggleFavorite(productId: String) -> Bool {
        guard let index = _products.firstIndex(where: { $0.id == productId }) else {
            return false
        }
        _products[index].isFavorite.toggle()
        return _products[index].isFavorite
    }
}
