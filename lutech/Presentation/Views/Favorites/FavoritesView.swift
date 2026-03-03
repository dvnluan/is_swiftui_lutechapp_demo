import SwiftUI

/// Màn hình Danh sách Yêu thích
struct FavoritesView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Đang tải...")
                } else if viewModel.favoriteProducts.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.4))
                        Text("Chưa có sản phẩm yêu thích")
                            .font(.headline).foregroundColor(.gray)
                        Text("Bấm ♥ trên sản phẩm để thêm vào đây")
                            .font(.footnote).foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.favoriteProducts) { product in
                            HStack(spacing: 12) {
                                Image(systemName: product.imageUrl)
                                    .resizable().scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray.opacity(0.5))
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.name)
                                        .font(.subheadline).lineLimit(2)
                                    // Dùng Double extension
                                    Text(product.price.vndFormatted)
                                        .font(.headline)
                                        .foregroundColor(AppTheme.primaryColor)
                                }
                                
                                Spacer()
                                
                                Button {
                                    viewModel.removeFavorite(productId: product.id, productName: product.name)
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(AppTheme.primaryColor)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                router.push(to: .productDetail(product))
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Yêu thích ❤️")
            .navigationBarTitleDisplayMode(.inline)
            .background(AppTheme.backgroundColor.edgesIgnoringSafeArea(.all))
            .onAppear { viewModel.fetchFavorites() }
            // Toast tự ẩn sau 2s
            .toast(message: $viewModel.toastMessage)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AppRouter())
}
