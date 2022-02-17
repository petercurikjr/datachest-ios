# About
A pure Swift implementation of <a href="https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing">Shamir's Secret Sharing</a> scheme. SwiftySSS is a library that exposes an API to split secret data buffers into a number of different shares. With the possession of some or all of these shares, the original secret can be restored. You can see demo app in the example project below

# Example

### How To Split

```swift
let message = Data([UInt8]("Hello World!".utf8))
let secret = try! Secret(data: message, threshold: 3, shares: 5)
let shares = try! secret.split()
        
shares.forEach { share in
    print(share.description)
}
//print
//1-8d736120eef1ca0b2b58971c
//2-1b46510ea3e09d828f9a217c
//3-de505c42223100e6d6aed241
//4-cb1f8a6d9544593ab4d53807
//5-0e0987211495c45eede1cb3a
```

### How To Combine

```swift
let share1 = "1-8d736120eef1ca0b2b58971c"
let share2 = "2-1b46510ea3e09d828f9a217c"
let share3 = "3-de505c42223100e6d6aed241"
let share4 = "4-cb1f8a6d9544593ab4d53807"
let share5 = "5-0e0987211495c45eede1cb3a"

let sharesStings = [share1, share2, share3, share4, share5]
let sharesObjects = sharesStings.compactMap { try? Secret.Share(string: $0) }
let someShares = [Secret.Share](sharesObjects[1...3])

let secretData = try!  Secret.combine(shares: someShares)
let secret = String(data: secretData, encoding: .utf8)

print(secret)
//print
//Hello World!
```

# Installation
## CocoaPods

```shell
pod 'SwiftySSS', '~> 0.0.1'
```

# Contributing and License
Distributed under the MIT license. See LICENSE for more information.