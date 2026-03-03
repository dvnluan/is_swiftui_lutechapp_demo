import SwiftUI

/// Màn hình Đăng nhập
/// AuthViewModel được inject từ ContentView qua @EnvironmentObject
/// → state login đồng bộ với toàn bộ app
struct LoginView: View {
    @EnvironmentObject var router: AppRouter
    /// Dùng @EnvironmentObject thay vì @StateObject
    /// để share cùng instance với ContentView, ProfileView
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // MARK: Logo & Tên app
            VStack(spacing: 8) {
                Image(systemName: "applelogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundColor(AppTheme.primaryColor)
                
                Text("LU Tech")
                    .font(.largeTitle).fontWeight(.bold)
                    .foregroundColor(AppTheme.primaryColor)
                
                Text("Mua sắm công nghệ đỉnh cao")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 8)
            
            // MARK: Form đăng nhập
            VStack(spacing: 14) {
                // Email field - border đỏ mận khi có lỗi email
                TextField("Email", text: $authViewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(emailBorderColor, lineWidth: 1)
                    )
                
                // Password field
                SecureField("Mật khẩu", text: $authViewModel.password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                // Error message (dùng String extension để check)
                if let error = authViewModel.errorMessage, error.isNotEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                // Nút đăng nhập
                Button {
                    authViewModel.login()
                } label: {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView().tint(.white).padding(.trailing, 4)
                        }
                        Text(authViewModel.isLoading ? "Đang đăng nhập..." : "Đăng nhập")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.primaryColor)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(8)
                    .opacity(authViewModel.isLoading ? 0.7 : 1.0)
                }
                .disabled(authViewModel.isLoading)
                .animation(.easeInOut(duration: 0.2), value: authViewModel.isLoading)
            }
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.25), value: authViewModel.errorMessage)
            
            // MARK: Divider
            HStack {
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                Text("Hoặc đăng nhập với").font(.caption).foregroundColor(.gray)
                    .fixedSize()
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // MARK: Social Login
            HStack(spacing: 12) {
                // Google
                Button {
                    authViewModel.loginWithSocial(provider: "google")
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "globe")
                        Text("Google")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                }
                
                // Apple
                Button {
                    authViewModel.loginWithSocial(provider: "apple")
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "applelogo")
                        Text("Apple")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .disabled(authViewModel.isLoading)
            
            Spacer()
            
            // Gợi ý tài khoản test
            Text("Test: admin@lutech.com / 123456")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
        }
        .background(AppTheme.backgroundColor.edgesIgnoringSafeArea(.all))
        // Ẩn loading overlay toàn màn hình
        .overlay {
            if authViewModel.isLoading {
                Color.black.opacity(0.15)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(true)
            }
        }
    }
    
    // MARK: - Computed
    
    /// Border màu đỏ nếu email lỗi format, xám bình thường nếu ổn
    private var emailBorderColor: Color {
        if let error = authViewModel.errorMessage,
           error.contains("Email") {
            return AppTheme.primaryColor.opacity(0.7)
        }
        return Color.gray.opacity(0.3)
    }
}

#Preview {
    LoginView()
        .environmentObject(AppRouter())
        .environmentObject(AuthViewModel())
}
