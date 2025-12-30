// SPDX-License-Identifier: MIT
// Copyright © 2018-2023 WireGuard LLC. All Rights Reserved.

import Foundation
import Network

extension IPv4Address {
    init?(addrInfo: addrinfo) {
        guard addrInfo.ai_family == AF_INET else { return nil }

        // Copy the sockaddr data to a properly aligned sockaddr_in struct
        // This avoids alignment issues with withMemoryRebound on arm64e
        var sockaddrIn = sockaddr_in()
        memcpy(&sockaddrIn, addrInfo.ai_addr, MemoryLayout<sockaddr_in>.size)

        let addressData = withUnsafeBytes(of: &sockaddrIn.sin_addr) { Data($0) }
        self.init(addressData)
    }
}

extension IPv6Address {
    init?(addrInfo: addrinfo) {
        guard addrInfo.ai_family == AF_INET6 else { return nil }

        // Copy the sockaddr data to a properly aligned sockaddr_in6 struct
        // This avoids alignment issues with withMemoryRebound on arm64e
        var sockaddrIn6 = sockaddr_in6()
        memcpy(&sockaddrIn6, addrInfo.ai_addr, MemoryLayout<sockaddr_in6>.size)

        let addressData = withUnsafeBytes(of: &sockaddrIn6.sin6_addr) { Data($0) }
        self.init(addressData)
    }
}
