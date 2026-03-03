import SwiftUI

/// Màn hình chính chứa Bottom Navigation
struct MainTabView: View {
    @State private var selectedTab = 0
    
    // Khởi tạo màu cho tab bar
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Trang chủ")
                }
                .tag(0)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Yêu thích")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Cá nhân")
                }
                .tag(2)
        }
        .accentColor(AppTheme.primaryColor) // Đổi màu tab đang chọn thành màu đỏ mận
        .navigationBarBackButtonHidden(true) // Ẩn nút back khi ở tab chính
    }
}

#Preview {
    let vm = AuthViewModel()
    vm.currentUser = User(id: "1", email: "admin@lutech.com", name: "Admin LU Tech", avatarUrl: "person.circle.fill")
    return MainTabView()
        .environmentObject(AppRouter())
        .environmentObject(vm)
}
