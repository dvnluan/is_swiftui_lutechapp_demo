import SwiftUI

/// Màn hình Cá nhân
/// Dùng @EnvironmentObject AuthViewModel được share từ ContentView
/// → gọi logout() sẽ cập nhật state toàn app, ContentView sẽ popToRoot
struct ProfileView: View {
    @EnvironmentObject var router: AppRouter
    /// Dùng @EnvironmentObject thay vì @StateObject để share cùng instance
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let user = authViewModel.currentUser {
                    
                    // MARK: Header Profile
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.primaryColor.opacity(0.1))
                                .frame(width: 90, height: 90)
                            Image(systemName: user.avatarUrl ?? "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(AppTheme.primaryColor)
                        }
                        
                        Text(user.name)
                            .font(.title2).fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.subheadline).foregroundColor(.secondary)
                        
                        // Badge xác thực
                        Label("Tài khoản đã xác thực", systemImage: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(20)
                    }
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    
                    // MARK: Menu
                    List {
                        Section {
                            menuRow(icon: "doc.text.fill", title: "Đơn mua của tôi")
                            menuRow(icon: "clock.fill",    title: "Đã xem gần đây")
                            menuRow(icon: "gift.fill",     title: "Voucher của tôi")
                        }
                        
                        Section {
                            menuRow(icon: "bell.fill",          title: "Thông báo")
                            menuRow(icon: "gearshape.fill",     title: "Thiết lập tài khoản")
                            menuRow(icon: "questionmark.circle.fill", title: "Trợ giúp & Hỗ trợ")
                        }
                        
                        // Logout section riêng
                        Section {
                            Button {
                                authViewModel.logout()
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.left.circle.fill")
                                        .foregroundColor(.red)
                                    Text("Đăng xuất")
                                        .foregroundColor(.red)
                                }
                                .padding(.vertical, 4)
                            }
                            .disabled(authViewModel.isLoading)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                } else {
                    // Fallback: chưa có user (không nên xảy ra nếu flow đúng)
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Đang tải thông tin...")
                            .font(.footnote).foregroundColor(.secondary)
                    }
                }
            }
            .background(AppTheme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("Cá nhân")
            .navigationBarTitleDisplayMode(.inline)
        }
        // Loading overlay khi đang logout
        .overlay {
            if authViewModel.isLoading {
                Color.black.opacity(0.15)
                    .edgesIgnoringSafeArea(.all)
                    .overlay { ProgressView("Đang đăng xuất...").tint(.white) }
            }
        }
        // Không cần onChange ở đây nữa vì ContentView đã xử lý navigation khi isLoggedOut = true
    }
    
    // MARK: - Helper Builder
    
    /// Tạo navigation row trong menu
    @ViewBuilder
    private func menuRow(icon: String, title: String) -> some View {
        NavigationLink(destination: Text(title).padding()) {
            Label(title, systemImage: icon)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    // Inject AuthViewModel với user giả để Preview hiển thị đúng
    let vm = AuthViewModel()
    vm.currentUser = User(id: "1", email: "admin@lutech.com", name: "Admin LU Tech", avatarUrl: "person.circle.fill")
    return ProfileView()
        .environmentObject(AppRouter())
        .environmentObject(vm)
}
