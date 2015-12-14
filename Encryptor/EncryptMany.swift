import Foundation
import CommonCrypto

extension Encryptor {

    func encryptMany(input: BinaryData) -> BinaryData {
        print("encryptMany")
        var i = 0
        var j = 0
        let n = 16
        var ret = BinaryData()
        var tmp = BinaryData()
        var currentIV = self.iv
        
        while i < input.count {
            j = min(input.count, i + n)
            print("encrypt round: \(i/16 + 1)")
            tmp = self.encryptOneChunk(
                input[i..<j],
                iv: currentIV)
            ret = ret + tmp
            currentIV = tmp
            i = i + n
        }
        return ret
    }
}
