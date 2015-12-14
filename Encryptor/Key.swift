import Foundation
import CommonCrypto

class Key: BinaryData {
    var pw: String = ""
    var salt: Salt = Salt()
    
    convenience init(_ input: String) {
        // print("Key.init(_: String): \(input)")
        self.init(input.utf8.map { UInt8($0) })
        pw = input
        data = []
    }
    
    func stretch(saltIn saltIn: Salt = Salt()) {
        // turn a password into a key with sufficient randomness
        // by key "stretching"
        let pw = self.pw
        let pwBytes = pw.utf8.map { Int8($0) }
        let pwLen = pwBytes.count
        
        // Int8 not UInt8!
        // let pwPointer = UnsafePointer<Int8>(pwBytes)
        
        var salt: Salt
        if saltIn.data.count == 0 {
            salt = randomBinaryData(6)
        } else{
            salt = saltIn
        }
        print("pw: \(pw)")
        print("salt: \(salt)")
        
        let saltLen = salt.data.count
        // UInt8 not Int8!
        let saltPointer = UnsafePointer<UInt8>(salt.data)
        
        let alg = CCPBKDFAlgorithm(kCCPBKDF2)
        let hmac = CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1)
        
        /*
        run with this to
        figure out how many rounds needed
        for 1000ms computation time
        
        let rounds = CCCalibratePBKDF(
        alg,
        pwLen,
        saltLen,
        hmac,
        Int(CC_SHA1_DIGEST_LENGTH),
        1000)
        
        found out the result is variable!!!
        
        */
        
        let rounds = UInt32(1500000)
        
        // Derive the key
        let key = Array<UInt8>(
            count:Int(CC_SHA1_DIGEST_LENGTH),
            repeatedValue:0)
        
        CCKeyDerivationPBKDF(
            alg,            // kCCPBKDF2
            pw,
            pwLen,
            saltPointer,
            saltLen,
            hmac,           // kCCPRFHmacAlgSHA1
            rounds,
            UnsafeMutablePointer<UInt8>(key),
            Int(CC_SHA1_DIGEST_LENGTH))
        
        self.salt = salt
        // CC_SHA1_DIGEST_LENGTH == 20
        //
        self.data = key
    }
    
    override var description : String {
        get {
            let s1 = "data: \(BinaryData(self.data))"
            let s2 = "salt: \(BinaryData(self.salt.data))"
            return "pw:   \(self.pw)\n\(s1)\n\(s2)"
        }
    }
}