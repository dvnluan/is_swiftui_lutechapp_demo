import Foundation
import Combine

// MARK: - FavoritesViewModel
@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [Product] = []
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository = ProductRepositoryImpl()) {
        self.productRepository = productRepository
    }
    
    func fetchFavorites() {
        isLoading = true
        Task {
            do {
                self.favoriteProducts = try await productRepository.getFavoriteProducts()
            } catch {
                print("❌ Lỗi tải yêu thích: \(error)")
            }
            self.isLoading = false
        }
    }
    
    /// Xoá sản phẩm khỏi yêu thích và hiển thị toast
    func removeFavorite(productId: String, productName: String) {
        Task {
            do {
                _ = try await productRepository.toggleFavorite(productId: productId)
                // Xoá khỏi list local ngay để UI cập nhật nhanh
                self.favoriteProducts.removeAll(where: { $0.id == productId })
                self.toastMessage = "Đã xoá \"\(productName)\" khỏi yêu thích"
            } catch {
                print("❌ Lỗi bỏ yêu thích: \(error)")
            }
        }
    }
}
