//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftOpenAPIGenerator open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftOpenAPIGenerator project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftOpenAPIGenerator project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation

/// A wrapper providing locked access to a value.
///
/// Marked as @unchecked Sendable due to the synchronization being
/// performed manually using locks.
///
/// Note: Use the `package` access modifier once min Swift version is increased.
@_spi(Locking)
public final class LockedValueBox<Value: Sendable>: @unchecked Sendable {
    private let lock: NSLock = {
        let lock = NSLock()
        lock.name = "com.apple.swift-openapi-urlsession.lock.LockedValueBox"
        return lock
    }()
    private var value: Value
    public init(_ value: Value) {
        self.value = value
    }
    public func withValue<R>(_ work: (inout Value) throws -> R) rethrows -> R {
        lock.lock()
        defer {
            lock.unlock()
        }
        return try work(&value)
    }
}
