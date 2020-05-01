//
//  SerialOperation.swift
//  WhiteFlowerFactory
//
//  Created by Stephen Bodnar on 8/15/19.
//  Copyright © 2019 Stephen Bodnar. All rights reserved.
//

import Foundation

// Thanks to Rob from this stackoverflow question: https://stackoverflow.com/questions/43561169/trying-to-understand-asynchronous-operation-subclass
// The code from AsynchronousOperation and NetworkOperation is from his answer
internal class AsynchronousOperation: Operation {
    
    @objc enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    
    /// Concurrent queue for synchronizing access to `state`.
    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)
    
    /// Private backing stored property for `state`.
    private var rawState: OperationState = .ready
    
    /// The state of the operation
    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { rawState } }
        set { stateQueue.sync(flags: .barrier) { rawState = newValue } }
    }
    
    /// Override default so we can decide when it is finished
    override var isReady: Bool {
        return state == .ready && super.isReady
    }
    override var isExecuting: Bool {
        return state == .executing
    }
    override var isFinished: Bool {
        return state == .finished
    }
    
    /// KVN for dependent properties
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }
        
        return super.keyPathsForValuesAffectingValue(forKey: key)
    }
    
    /// Start
    final override func start() {
        if isCancelled {
            finish()
            return
        }
        
        state = .executing
        main()
    }
    
    override func main() {
        fatalError("subclass must implement")
    }
    
    final func finish() {
        if !isFinished { state = .finished }
    }
}
