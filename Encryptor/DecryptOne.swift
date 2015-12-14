import Foundation
import CommonCrypto

extension Encryptor {
    
    func decryptOneChunk(input: BinaryData, iv: BinaryData = BinaryData())  -> BinaryData {
        
        print("decryptOneChunk")
        print("data:\n\(input)")
        
        let stdBufferSize = 16 // AES128BlockSize in bytes
        
        let cipherData = input.data
        
        let decryptedData = [UInt8](        // not really constant!
            count: stdBufferSize,
            repeatedValue: 0)
        
        let algorithm = CCAlgorithm(kCCAlgorithmAES)
        let options = CCOptions(0)  // CBC
        
        var keyData = [UInt8]()
        for i in 0..<stdBufferSize {
            keyData.append(key.data[i])
        }
        
        let keyLen = keyData.count
        print("keyLen: \(keyLen)")
        
        print("iv:\n\(iv)")
        
        var status: Int32 = 0
        var resultLen = 0
        
        status = CCCrypt(
            CCOperation(kCCDecrypt),
            algorithm,
            options,
            keyData,
            keyLen,
            iv.data,
            cipherData,
            stdBufferSize,
            UnsafeMutablePointer<Void>(decryptedData),
            stdBufferSize,
            &resultLen)
        
        print("status: \(status)")
        let result = BinaryData(decryptedData)
        print("result:\n\(result)\n")
        return result
    }
}