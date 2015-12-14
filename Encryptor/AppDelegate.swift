import Cocoa
import CommonCrypto

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // testBinaryData()
        // testKey()
        // testEncrypt()
        // testEncryptorEncryptDecrypt()
        testMultiples()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

