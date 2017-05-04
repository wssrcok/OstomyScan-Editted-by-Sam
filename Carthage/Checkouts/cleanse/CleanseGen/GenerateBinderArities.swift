//
//  GenerateBinders.swift
//  Cleanse
//
//  Created by Mike Lewis on 4/22/16.
//  Copyright © 2016 Square, Inc. All rights reserved.
//

import Foundation
#if !swift(>=3.0)
    extension String {
        /// Backwards-compatible swift 2.2 shim
        @warn_unused_result
        func components(separatedBy separator: String) -> [String] {
            return self.componentsSeparatedByString(separator)
        }
    }
    
#endif


func makeBinder(arity: Int, swift3: Bool) {
    let paramIndexes = 1...arity
    
    let sourceInfoArguments: String
    
    if !swift3 {
        sourceInfoArguments = "file file: StaticString=#file, line: Int=#line, function: StaticString=#function"
    } else {
        sourceInfoArguments = "file: StaticString=#file, line: Int=#line, function: StaticString=#function"
    }
    
    
    print("/// \(arity)-arity `to(factory:)` function.")
    print("/// This completes the binding process for registering the provider for the type passed (or inferred) to `bind()`.")
    print("/// - parameter factory: Takes arguments required to construct `Element` passed to the `bind()` function")
    print("///")
    print("/// - Note: This method was generated by `\((#file as String).components(separatedBy: "/").last!)`")
    
    print("@discardableResult public func to<\(paramIndexes.map { "P_\($0)" }.joinWithSeparator(", "))>"
        + "(\(sourceInfoArguments), factory: @escaping (\(paramIndexes.map { "P_\($0)" }.joinWithSeparator(", "))) -> Input)  -> BindingReceipt<Input> {")
    print("    let binder = self.binder, finalBindingType = self._finalProviderType as! AnyProvider.Type")
    for i in paramIndexes {
        print("    let provider\(i) = binder.provider(P_\(i).self, file: file, line: line, function: function, providerRequiredFor: finalBindingType)")
    }
    print()
    print("    return _innerTo(file: file, line: line, function: function, provider: Provider {\n     factory(\n        \(paramIndexes.map { "provider\($0).get()" }.joinWithSeparator(",\n        "))\n    )\n   })")
    print("}")
}


print("extension BindToable {")

(1..<20).forEach { makeBinder($0, swift3: true ) }

print("}")
