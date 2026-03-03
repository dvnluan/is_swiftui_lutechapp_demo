import Foundation
import Combine

// MARK: - ProductDetailViewModel
@MainActor
class ProductDetailViewModel: ObservableObject {
    @Published var product: Product
    
    /// Toast message hiển thị ở bottom giống Shopee, nil = ẩn
    @Published var toastMessage: String?
    
    private let productRepository: ProductRepository
    
    init(product: Product, productRepository: ProductRepository = ProductRepositoryImpl()) {
        self.product = product
        self.productRepository = productRepository
    }
    
    // MARK: - Toggle Favorite
    
    /// Toggle yêu thích, hiển thị toast ở bottom và gửi local notification
    func toggleFavorite() {
        Task {
            do {
                let newStatus = try await productRepository.toggleFavorite(productId: product.id)
                self.product.isFavorite = newStatus
                
                // Hiển thị toast message kiểu Shopee
                if newStatus {
                    self.toastMessage = "Đã thêm vào yêu thích ❤️"
                    // Gửi local notification (chạy trên actor riêng, không block UI)
                    Task.detached(priority: .background) {
                        await NotificationManager.shared.sendFavoriteNotification(
                            productName: self.product.name
                        )
                    }
                } else {
                    self.toastMessage = "Đã xoá khỏi yêu thích"
                }
            } catch {
                self.toastMessage = "Có lỗi xảy ra, vui lòng thử lại"
                print("❌ Lỗi toggle favorite: \(error)")
            }
        }
    }
}
