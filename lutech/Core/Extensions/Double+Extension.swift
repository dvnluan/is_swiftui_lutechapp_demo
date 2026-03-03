import Foundation

// MARK: - Extension cho Double
extension Double {
    
    /// Format giá tiền sang định dạng tiền Việt Nam (VD: đ34,990,000)
    var vndFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let formatted = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "đ\(formatted)"
    }
    
    /// Format giá tiền rút gọn (VD: 34.9 triệu)
    var vndShortFormatted: String {
        if self >= 1_000_000 {
            let million = self / 1_000_000
            // Nếu là số nguyên thì không hiện số thập phân
            if million == million.rounded() {
                return "đ\(Int(million)) triệu"
            }
            return String(format: "đ%.1f triệu", million)
        }
        return vndFormatted
    }
}
