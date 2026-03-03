import SwiftUI

/// Thẻ sản phẩm dùng trong dạng Grid
struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Ảnh sản phẩm giả lập
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: product.imageUrl)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .foregroundColor(.gray.opacity(0.5))
                    )
                
                // Badge giảm giá (sử dụng optional binding sạch)
                if let oldPrice = product.originalPrice, oldPrice > product.price {
                    let discount = Int((1 - product.price / oldPrice) * 100)
                    Text("-\(discount)%")
                        .font(.caption2).fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 4).padding(.vertical, 2)
                        .background(AppTheme.primaryColor)
                        .cornerRadius(4)
                        .offset(x: -4, y: 4)
                }
            }
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer(minLength: 0)
                
                // Dùng Double extension thay vì format thủ công
                Text(product.price.vndFormatted)
                    .font(.headline)
                    .foregroundColor(AppTheme.primaryColor)
                
                HStack {
                    Text("Đã bán \(product.soldCount)")
                        .font(.caption2).foregroundColor(.gray)
                    Spacer()
                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(AppTheme.primaryColor)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ProductCard(product: SampleData.product)
}
