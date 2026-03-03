import SwiftUI

/// Màn hình Chi tiết Sản phẩm (phong cách Shopee)
struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: ProductDetailViewModel
    @State private var showFullDescription = false
    
    init(product: Product) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(product: product))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: Carousel ảnh sản phẩm
                    CarouselSlider(images: [viewModel.product.imageUrl, "photo", "photo"])
                        .frame(height: 300)
                        .background(Color.white)
                    
                    // MARK: Thông tin cơ bản
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            Text(viewModel.product.name)
                                .font(.title3)
                                .fontWeight(.medium)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                            
                            // Nút yêu thích với animation
                            Button {
                                viewModel.toggleFavorite()
                            } label: {
                                Image(systemName: viewModel.product.isFavorite ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(AppTheme.primaryColor)
                                    // Animation khi toggle
                                    .symbolEffect(.bounce, value: viewModel.product.isFavorite)
                            }
                        }
                        
                        // Giá hiển thị dùng Double extension
                        HStack(alignment: .bottom, spacing: 8) {
                            Text(viewModel.product.price.vndFormatted)
                                .font(.title)
                                .foregroundColor(AppTheme.primaryColor)
                                .fontWeight(.bold)
                            
                            if let oldPrice = viewModel.product.originalPrice, oldPrice > viewModel.product.price {
                                Text(oldPrice.vndFormatted)
                                    .font(.subheadline)
                                    .strikethrough()
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("Đã bán \(viewModel.product.soldCount)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    
                    Color.gray.opacity(0.1).frame(height: 8)
                    
                    // MARK: Chi tiết sản phẩm - show more/hide
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Chi tiết sản phẩm")
                            .font(.headline)
                        
                        Text(viewModel.product.description)
                            .font(.body)
                            .foregroundColor(AppTheme.textColor)
                            .lineLimit(showFullDescription ? nil : 3)
                            .animation(.easeInOut, value: showFullDescription)
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                showFullDescription.toggle()
                            }
                        } label: {
                            Text(showFullDescription ? "Thu gọn ▲" : "Xem thêm ▼")
                                .font(.footnote)
                                .foregroundColor(AppTheme.primaryColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)
                    }
                    .padding()
                    .background(Color.white)
                    
                    Color.gray.opacity(0.1).frame(height: 8)
                }
            }
            
            // MARK: Bottom Action Bar (Shopee style)
            HStack(spacing: 0) {
                // Chat
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "message")
                        Text("Chat ngay").font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .background(Color.teal)
                }
                
                // Thêm vào giỏ hàng
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "cart.badge.plus")
                        Text("Thêm vào giỏ").font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                }
                
                // Mua ngay
                Button(action: {}) {
                    Text("Mua ngay")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(.white)
                        .background(AppTheme.primaryColor)
                }
            }
            .frame(height: 60)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { presentationMode.wrappedValue.dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppTheme.primaryColor)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Chi tiết").font(.headline)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "cart").foregroundColor(AppTheme.primaryColor)
                }
            }
        }
        // Toast bottom - dùng View extension, tự ẩn sau 2s
        .toast(message: $viewModel.toastMessage)
    }
}

#Preview {
    ProductDetailView(product: SampleData.product)
        .environmentObject(AppRouter())
}
