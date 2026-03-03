import Foundation

/// Thực thể Bình luận từ Khách hàng (Khách hàng nói về chúng tôi)
struct Testimonial: Identifiable, Hashable {
    let id: String
    let customerName: String
    let avatarUrl: String?
    let content: String
    let rating: Int // 1 to 5
}
