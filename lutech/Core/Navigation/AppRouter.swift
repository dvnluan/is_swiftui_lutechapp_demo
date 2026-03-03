import Foundation
import SwiftUI
import Combine


/// Core Navigation Router
enum AppRoute: Hashable {
    case login
    case main
    case productDetail(Product)
}

class AppRouter: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    // Điều hướng tới một route mới
    func push(to route: AppRoute) {
        navigationPath.append(route)
    }
    
    // Quay lại màn hình trước
    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    // Quay lại màn hình gốc
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
