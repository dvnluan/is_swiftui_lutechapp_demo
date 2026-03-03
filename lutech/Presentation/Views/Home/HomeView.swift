import SwiftUI

/// Màn hình Trang Chủ
struct HomeView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel = HomeViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                
                // Carousel Banner
                CarouselSlider(images: ["banner1", "banner2", "banner3"])
                    .frame(height: 180)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                categoriesSection
                
                // Grid điện thoại (dùng filteredPhoneProducts có search filter)
                productGridSection(title: "📱 Điện thoại nổi bật", products: viewModel.filteredPhoneProducts)
                
                // Grid máy tính bảng
                productGridSection(title: "💻 Máy tính bảng", products: viewModel.filteredTabletProducts)
                
                testimonialsSection
            }
            .padding(.bottom, 20)
        }
        .background(AppTheme.backgroundColor.edgesIgnoringSafeArea(.all))
        .onAppear { viewModel.fetchData() }
        // Toast bottom - hiển thị khi thêm/xoá favorite, tự ẩn sau 2s
        .toast(message: $viewModel.toastMessage)
    }
    
    // MARK: - Header & Search
    private var headerSection: some View {
        HStack(spacing: 8) {
            // Logo + tên app
            HStack(spacing: 4) {
                Image(systemName: "applelogo")
                    .foregroundColor(AppTheme.primaryColor)
                    .font(.title2)
                Text("LU Tech")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.primaryColor)
            }
            
            Spacer()
            
            // Search field (dùng .trimmed từ String extension để check)
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Tìm kiếm sản phẩm...", text: $viewModel.searchText)
                    .submitLabel(.search)
                // Nút xoá nếu có text
                if viewModel.searchText.isNotEmpty {
                    Button {
                        viewModel.searchText = ""
                        // Ẩn bàn phím dùng View extension
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    // MARK: - Danh mục
    private var categoriesSection: some View {
        VStack(alignment: .leading) {
            Text("Danh mục")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.categories) { category in
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3)
                                Image(systemName: category.iconSystemName)
                                    .resizable().scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(AppTheme.primaryColor)
                            }
                            Text(category.name)
                                .font(.caption)
                                .foregroundColor(AppTheme.textColor)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Grid sản phẩm
    private func productGridSection(title: String, products: [Product]) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Text("Xem tất cả")
                    .font(.footnote)
                    .foregroundColor(AppTheme.primaryColor)
            }
            .padding(.horizontal)
            
            if products.isEmpty {
                Text("Không tìm thấy sản phẩm phù hợp")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(products) { product in
                        ProductCard(product: product)
                            .onTapGesture {
                                router.push(to: .productDetail(product))
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Testimonials
    private var testimonialsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💬 Khách hàng nói về chúng tôi")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(viewModel.testimonials) { testimonial in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: testimonial.avatarUrl ?? "person.circle.fill")
                        .resizable().frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(testimonial.customerName)
                            .font(.subheadline).fontWeight(.medium)
                        
                        // Rating stars
                        HStack(spacing: 2) {
                            ForEach(0..<5) { i in
                                Image(systemName: i < testimonial.rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption2)
                            }
                        }
                        
                        Text(testimonial.content)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppRouter())
}
