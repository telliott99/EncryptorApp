import Foundation
import CommonCrypto

extension Encryptor {
    
    func decryptMany(input: BinaryData) -> BinaryData {
        print("decryptMany")
        var i = 0
        var j = 0
        let n = 16
        var ret = BinaryData()
        var tmp = BinaryData()
        var currentIV = self.iv
        
        while i < input.count {
            j = min(input.count, i + n)
            tmp = self.decryptOneChunk(
                input[i..<j],
                iv: currentIV)
            ret = ret + tmp
            
            // crucial change:
            // currentIV = tmp
            currentIV = input[i..<j]
            i = i + n
        }
        return ret
    }
}

