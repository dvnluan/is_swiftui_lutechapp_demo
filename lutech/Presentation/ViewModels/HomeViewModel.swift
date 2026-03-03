import Foundation
import Combine

// MARK: - HomeViewModel
@MainActor
class HomeViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var phoneProducts: [Product] = []
    @Published var tabletProducts: [Product] = []
    @Published var testimonials: [Testimonial] = []
    @Published var isLoading = false
    @Published var searchText = ""
    
    /// Toast message hiển thị ở bottom (dùng chung View+Extension toast modifier)
    @Published var toastMessage: String?
    
    private let productRepository: ProductRepository
    
    init(productRepository: ProductRepository = ProductRepositoryImpl()) {
        self.productRepository = productRepository
    }
    
    // MARK: - Fetch tất cả dữ liệu trang chủ song song
    func fetchData() {
        isLoading = true
        
        Task {
            do {
                // async let: tất cả 4 request chạy song song, không chờ nhau → nhanh hơn
                async let catTask      = productRepository.getCategories()
                async let phoneTask    = productRepository.getPhoneProducts()
                async let tabletTask   = productRepository.getTabletProducts()
                async let testTask     = productRepository.getTestimonials()
                
                let (cats, phones, tablets, tests) = try await (catTask, phoneTask, tabletTask, testTask)
                
                self.categories    = cats
                self.phoneProducts = phones
                self.tabletProducts = tablets
                self.testimonials  = tests
                
            } catch {
                print("❌ Lỗi tải dữ liệu Home: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Toggle Favorite từ Home
    func toggleFavorite(for product: Product) {
        Task {
            do {
                let newStatus = try await productRepository.toggleFavorite(productId: product.id)
                
                // Cập nhật local state (tìm và update trong cả 2 list)
                updateFavoriteStatus(productId: product.id, newStatus: newStatus)
                
                // Hiển thị toast
                self.toastMessage = newStatus
                    ? "Đã thêm vào yêu thích ❤️"
                    : "Đã xoá khỏi yêu thích"
                
                // Gửi notification chạy background, không block UI thread
                if newStatus {
                    Task.detached(priority: .background) {
                        await NotificationManager.shared.sendFavoriteNotification(
                            productName: product.name
                        )
                    }
                }
            } catch {
                print("❌ Lỗi toggle favorite: \(error)")
            }
        }
    }
    
    // MARK: - Computed: lọc sản phẩm theo search (dùng extension String)
    var filteredPhoneProducts: [Product] {
        guard searchText.trimmed.isNotEmpty else { return phoneProducts }
        return phoneProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var filteredTabletProducts: [Product] {
        guard searchText.trimmed.isNotEmpty else { return tabletProducts }
        return tabletProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    // MARK: - Private helpers
    
    private func updateFavoriteStatus(productId: String, newStatus: Bool) {
        if let i = phoneProducts.firstIndex(where: { $0.id == productId }) {
            phoneProducts[i].isFavorite = newStatus
        }
        if let i = tabletProducts.firstIndex(where: { $0.id == productId }) {
            tabletProducts[i].isFavorite = newStatus
        }
    }
}
