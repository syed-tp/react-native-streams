import React
import TPStreamsSDK


@objcMembers
public class SDKModuleImpl: NSObject {
    
    // Singleton instance
    public static let shared = SDKModuleImpl()
    private var isInitialized = false
    
    // Private initializer to prevent external instantiation
    private override init() {
        super.init()
    }

    public func initialize(_ orgId: String) {
        if !self.isInitialized {
            DispatchQueue.main.async {
                TPStreamsSDK.initialize(withOrgCode: orgId)
                self.isInitialized = true
            }
        }
    }
}
