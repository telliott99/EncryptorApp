import Foundation

func randomBinaryData(n: Int = 1) -> BinaryData {
    var buffer = [UInt8](
        count:n, repeatedValue: 0)
    SecRandomCopyBytes(
        kSecRandomDefault, n, &buffer)
    return BinaryData(buffer)
}

