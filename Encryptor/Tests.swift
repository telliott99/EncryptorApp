import Foundation

func testBinaryData() {
    print("test BinaryData")
    
    let b = BinaryData([0,255])
    Swift.print(b[0..<1])

    let b6 = randomBinaryData(6)
    print(b6.data)
    print(b6)
    
    let bsd = BinaryData.init(byteString: "ff ae")
    print(bsd.data)
    print(bsd)
    
    let bid = BinaryData.init(byteString: "ffae01")
    print(bid.data)
    print(bid)
    
    let b10 = randomBinaryData(10)
    print(b10)
    
    // convert [UInt8] -> BinaryData -> String -> BinaryData
    print(BinaryData(byteString: "\(b10)"))
    
}

func testKey() {
    print("test Key")
    let password = "my secret"
    var key = Key(password)
    print("\(key)\n")
    
    key.stretch()
    print("\(key)\n")
    
    let salt = key.salt
    key = Key(password)
    key.stretch(saltIn: salt)
    print("\(key)\n")
}

func testEncrypt() {
    print("test Encryptor")
    
    let password = "my secret"
    var key = Key(password)
    print("\(Encryptor(key))\n")
    
    print("after stretching:")
    key = Key(password)
    key.stretch()
    print("\(Encryptor(key))\n")
    
    let b = "\(key.salt)"
    let data = key.salt.data
    
    print("init from byteString:")
    print("byteString: \(b)")
    key = Key(password)
    key.stretch(saltIn: Salt(byteString: b))
    print("\(Encryptor(key))\n")
    
    print("init from byteArray:")
    print("data: \(data)")
    key = Key(password)
    key.stretch(saltIn: Salt(data))
    print("\(Encryptor(key))")
}

func testEncryptorEncryptDecrypt() {
    let password = "my secret"
    let key = Key(password)
    key.stretch()
    let e = Encryptor(key)
    
    let msgText = "areallybigsecret"
    print("msgText: \(msgText)")
    print("\(msgText.utf8.map { UInt8($0) })")
    
    let msg = BinaryData(msgText.utf8.map { UInt8($0) })
    
    let iv = randomBinaryData(16)

    let cipherData = e.encryptOneChunk(msg, iv: iv)
    print("cipherData: \(cipherData)")
    print(cipherData.data)
    
    let decryptedData = e.decryptOneChunk(cipherData, iv: iv)
    print("decryptedData: \(decryptedData)")
    print(decryptedData.data)

    let sa = decryptedData.data.map {
        Character(UnicodeScalar(UInt32($0))) }
    print(String(sa))
}

func testMultiples() {
    let password = "my secret"
    let key = Key(password)
    key.stretch()
    let e = Encryptor(key)
    
    let msgText = "a much longer and still really big secret"
    print("msgText: \(msgText)")
    
    let msgData = BinaryData(msgText.utf8.map { UInt8($0) })
    print("\(msgData)")
    
    let cipherData = e.encryptMany(msgData)
    
    print("cipherData: \(cipherData)")
    print("")
    
    let decryptedData = e.decryptMany(cipherData)
    print("decryptedData: \(decryptedData)")
    
    let sa = decryptedData.data.map {
        Character(UnicodeScalar(UInt32($0))) }
    print(String(sa))
    
}