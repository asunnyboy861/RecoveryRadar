import StoreKit
import Observation

@Observable
@MainActor
final class StoreManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isLoading = false

    private var transactionListener: Task<Void, Never>?

    static let shared = StoreManager()

    let productIDs = [
        "com.zzoutuo.RecoveryRadar.pro.monthly",
        "com.zzoutuo.RecoveryRadar.pro.yearly",
        "com.zzoutuo.RecoveryRadar.pro.lifetime"
    ]

    init() {
        transactionListener = startTransactionListener()
    }

    var isProUser: Bool {
        !purchasedProductIDs.isEmpty
    }

    var monthlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.RecoveryRadar.pro.monthly" }
    }

    var yearlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.RecoveryRadar.pro.yearly" }
    }

    var lifetimeProduct: Product? {
        products.first { $0.id == "com.zzoutuo.RecoveryRadar.pro.lifetime" }
    }

    func loadProducts() async {
        isLoading = true
        do {
            let storeProducts = try await Product.products(for: productIDs)
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
        isLoading = false
    }

    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try Self.verifyTransaction(verification)
            purchasedProductIDs.insert(transaction.productID)
            await transaction.finish()
            return transaction
        case .userCancelled:
            return nil
        case .pending:
            return nil
        @unknown default:
            return nil
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if productIDs.contains(transaction.productID) {
                    purchasedProductIDs.insert(transaction.productID)
                }
            }
        }
    }

    private func startTransactionListener() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await self?.updatePurchasedProducts()
                }
            }
        }
    }

    private static func verifyTransaction<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
