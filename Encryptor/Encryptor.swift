import Foundation

class Encryptor: CustomStringConvertible {
    
    var key: Key
    var iv = randomBinaryData(16)
    
    init(_ input: Key) {
        self.key = input
    }
    
    var description : String {
        get {
            return "\(self.key)"
        }
    }
}
