import Foundation

extension String {
    func isValidByteString(spaces spaces: Bool = false) -> Bool {
        var validChars = "0123456789abcdef".characters
        if spaces {
            validChars = "0123456789abcdef ".characters
        }
        for c in self.characters {
            if !validChars.contains(c) {
                return false
            }
        }
        return true
    }
    
    /* split a String into [String] of chunk size n */
    /* no error checking */
    
    func divideIntoChunks(size n: Int) -> [String] {
        var ret: [String] = []
        var current = ""
        var i = 0
        for c in self.characters {
            if (i % n) == 0 {
                current += String(c)
            }
            else {
                current += String(c)
                ret.append(current)
                current = ""
            }
            i += 1
        }
        return ret
    }
    
    func splitOnStringCharacter(s: String) -> [String] {
        let c = Character(s)
        // let c = s.characters.first!
        let a = self.characters.split { $0 == c }
        return a.map { String($0) }
    }
    
    func stripCharactersInList(cL: CharacterView) -> String {
        /*
        the results are not Strings which joinWithSeparator requires,
        so do the conversion for each one with map
        */
        var a = [Character]()
        for c in self.characters {
            if cL.contains(c) {
                continue
            }
            a.append(c)
        }
        return a.map{String($0)}.joinWithSeparator("")
    }
    
    /* e.g. "ff" -> 255 */
    func singleHexByteStringToInt(h: String) -> UInt8 {
        let sL = h.characters.map { String($0) }
        assert (sL.count == 2, "not 2 character byte")
        func f(s: String) -> Int {
            let D = ["a":10,"b":11,"c":12,
                "d":13,"e":14,"f":15]
            if let v = D[s] { return v }
            return Int(s)!
        }
        let ret = f(sL.last!) + 16 * f(sL.first!)
        return UInt8(ret)
    }
    
    func hexByteStringToIntArray() -> [UInt8] {
        let cL = " ".characters
        let s = self.stripCharactersInList(cL)
        let sL = s.divideIntoChunks(size: 2)
        return sL.map { singleHexByteStringToInt($0) }
    }
}

// end of String extension

typealias ByteString = String

extension ByteString {
    
    func insertSeparator(sep: String, every n: Int) -> ByteString {
        /* e.g. put spaces every 2 characters */
        /* works with characters, not UTF8, so only for ByteString */
        
        let ret = self.divideIntoChunks(size: n)
        return ret.joinWithSeparator(sep)
    }
}

