import Foundation

public enum ProductType: String, CaseIterable, Codable {
    case refined
    case crude
    
    var displayName: String {
        switch self {
        case .refined: return "productType.refined".localized()
        case .crude: return "productType.crude".localized()
        }
    }
}
