import SwiftUI

// MARK: - Extension cho View
extension View {
    
    /// Áp dụng toast overlay vào bất kỳ View nào
    /// Dùng: view.toast(message: $toastMsg)
    func toast(message: Binding<String?>) -> some View {
        self.modifier(ToastModifier(message: message))
    }
    
    /// Ẩn bàn phím
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Bao bọc view trong một điều kiện
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Toast ViewModifier (kiểu Shopee)
struct ToastModifier: ViewModifier {
    @Binding var message: String?
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            // Toast hiển thị khi có message
            if let msg = message {
                ToastView(message: msg)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: message)
                    .padding(.bottom, 80) // Tránh đè lên bottom bar
                    .onAppear {
                        // Tự ẩn sau 2 giây giống Shopee
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                message = nil
                            }
                        }
                    }
            }
        }
    }
}

// MARK: - Toast UI Component
struct ToastView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.8))
        .cornerRadius(24)
        .shadow(radius: 8)
    }
}

#Preview {
    ToastView(message: "Đã thêm vào yêu thích ❤️")
}
