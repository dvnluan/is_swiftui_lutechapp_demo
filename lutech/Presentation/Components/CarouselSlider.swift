import SwiftUI
import Combine

/// Component Slider hình ảnh có dot indicator
struct CarouselSlider: View {
    let images: [String]
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<images.count, id: \.self) { index in
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3))
                    .tag(index)
                    .overlay(
                        Text("Banner \(index + 1)")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                    )
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % max(1, images.count)
            }
        }
    }
}

#Preview {
    CarouselSlider(images: ["photo", "photo"])
}
