import Foundation
import CommonCrypto

extension Encryptor {
    
    func encryptOneChunk(input: BinaryData, iv: BinaryData) -> BinaryData {
        
        print("encryptOneChunk")
        
        // AES128 block size is 16 bytes
        let AES128BlockSize = 16  // bytes, or 128 bits
        let stdBufferSize = AES128BlockSize
        
        var msg = input.data
        assert (msg.count <= stdBufferSize,
            "message chunk too large \(msg.count)")
        
        // pad if necessary
        while msg.count < 16 {
            msg.append(UInt8(0))
        }
        
        let msgLen = msg.count
        print("msgLen: \(msgLen)")
        print("msg:\n\(BinaryData(msg))")
        
        // Int(CC_SHA1_DIGEST_LENGTH))) == 20
        // that's what we get from stretching
        // truncate key to length 16
        
        // stretched self.key is 20 bytes, must truncate
        let key16Data = self.key.data[0..<stdBufferSize]
        
        // fix problem with "slice"
        // not required here, only in Decrypt, but why not?
        let keyData = Array<UInt8>(key16Data)
        
        let keyLen = keyData.count
        print("keyLen: \(keyLen)")
        
        print("iv:\n\(iv)")
        
        let algorithm = CCAlgorithm(kCCAlgorithmAES)
        let options = CCOptions(0)  // CBC
        
        let cipherData = [UInt8](   // not really constant!
            count: stdBufferSize,
            repeatedValue: 0)
        
        var status: Int32 = 0
        var resultLen = 0
        
        status = CCCrypt(
            CCOperation(kCCEncrypt),
            algorithm,
            options,
            self.key.data,
            keyLen,
            iv.data,
            msg,
            msgLen,
            UnsafeMutablePointer<Void>(cipherData),
            stdBufferSize,
            &resultLen)
        
        print("status: \(status)")
        // [UInt8] -> BinaryData
        let result = BinaryData(cipherData)
        print("result:\n\(result)\n")
        return result
    }
    
    func encryptMany(input: BinaryData) -> BinaryData {
        print("encryptMany")
        var i = 0
        var j = 0
        let n = 16
        var ret = BinaryData()
        var tmp = BinaryData()
        
        // Encryptor class initializes an iv upon instantiation
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