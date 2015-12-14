import Foundation

func intToHexByte(n: UInt8) -> String {
    let s = NSString(format: "%x", n) as String
    if s.characters.count == 1 {
        return "0" + s
    }
    return s
}
