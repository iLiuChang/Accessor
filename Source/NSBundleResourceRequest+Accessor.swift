//
//  NSBundleResourceRequest+Accessor.swift
//  Accessor
//
//  Created by LC on 2025/9/28.
//

import Foundation

public extension NSBundleResourceRequest {
    var `as`: AccessorWrapper {
        AccessorWrapper(self)
    }
}

public struct AccessorWrapper {
    let request: NSBundleResourceRequest
    init(_ request: NSBundleResourceRequest) {
        self.request = request
    }
    
    /// Load resources, support progress callbacks and completion callbacks
    /// - Parameters:
    ///   - progressHandler: Progress callback (0.0-1.0)
    ///   - completionHandler: Load the completion callback. An error of nil indicates success
    public func beginAccessingResources(progressHandler: ((Double) -> Void)? = nil,
                                        completionHandler: @escaping (Error?) -> Void) {
        
        request.conditionallyBeginAccessingResources { isAvailable in
            if isAvailable {
                progressHandler?(1.0)
                completionHandler(nil)
            } else {
                if progressHandler == nil {
                    request.beginAccessingResources(completionHandler: completionHandler)
                    return
                }
                let observation = request.progress.observe(\.fractionCompleted, options: [.new]) { progress, _ in
                    progressHandler?(progress.fractionCompleted)
                }
                request.beginAccessingResources { error in
                    observation.invalidate()
                    completionHandler(error)
                }
            }
        }
    }
    
    /// Support the resource loading method of `Task`
    /// - Parameter progressHandler: Progress callback (0.0-1.0)
    /// - Returns: An error of nil indicates success
    public func beginAccessingResources(progressHandler: ((Double) -> Void)? = nil) async -> Error? {
        await withCheckedContinuation { continuation in
            beginAccessingResources(progressHandler: progressHandler) { error in
                continuation.resume(returning: error)
            }
        }
    }
}
