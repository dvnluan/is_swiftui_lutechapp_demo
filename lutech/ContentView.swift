import SwiftUI

/// Root View - Sở hữu AuthViewModel và inject xuống toàn bộ cây View
struct ContentView: View {
    @StateObject private var router = AppRouter()
    /// AuthViewModel được tạo một lần duy nhất ở đây và share qua environmentObject
    /// → LoginView, ProfileView đều dùng chung instance này, state luôn đồng bộ
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            LoginView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .login:
                        LoginView()
                    case .main:
                        MainTabView()
                    case .productDetail(let product):
                        ProductDetailView(product: product)
                    }
                }
        }
        // Inject cả Router và AuthViewModel xuống toàn bộ cây View
        .environmentObject(router)
        .environmentObject(authViewModel)
        
        // Lắng nghe thay đổi currentUser:
        // Khi login thành công → navigate vào MainTabView
        .onChange(of: authViewModel.currentUser) { _, user in
            if user != nil, router.navigationPath.isEmpty {
                router.push(to: .main)
            }
        }
        // Khi logout → pop về gốc (LoginView)
        .onChange(of: authViewModel.isLoggedOut) { _, didLogout in
            if didLogout {
                router.popToRoot()
                authViewModel.resetLogoutFlag()
            }
        }
        // Khi app khởi động: session đã restore → navigate ngay vào Main
        .onAppear {
            if authViewModel.currentUser != nil {
                router.push(to: .main)
            }
        }
    }
}

#Preview {
    ContentView()
}
