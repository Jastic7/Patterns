// Author: Andrey Morozov
// Date: 18 February 2018
//
// Pattern: Adapter.
// Description: The Adapter Pattern converts the interface of a class into another interface the clients expect.
//              Adapter lets classes work together that couldn’t otherwise because of incompatible interfaces.
//              (c) Eric Freeman - Head First Design Patterns

enum Connector: String {
    case aux = "3.5mm jack"
    case lightning = "8-pin lightning"
}

protocol Headset {
    var model: String { get }
    var specification: String { get }
    var outConnector: Connector { get }
    
    init(model: String)
}

class LightningHeadphones: Headset {
    let model: String
    var specification: String {
        return "\(model) headphones with \(outConnector.rawValue)"
    }
    
    final var outConnector: Connector {
        return .lightning
    }
    
    required init(model: String) {
        self.model = model
    }
}

//Will be adopted to use with iPhone X
class AuxHeadphones: Headset {
    let model: String
    var specification: String {
        return "\(model) headphones with \(outConnector.rawValue)"
    }
    
    final var outConnector: Connector {
        return .aux
    }
    
    required init(model: String) {
        self.model = model
    }
}

class Sony: AuxHeadphones {
    override var specification: String {
        return "Sony " + super.specification
    }
}

class Beats: LightningHeadphones {
    override var specification: String {
        return "Beats " + super.specification
    }
}


protocol Iphone {
    associatedtype HeadphonesType: Headset
    
    func connect(headset: HeadphonesType)
}

class Iphone6: Iphone {
    var inConnector: Connector {
        return .aux
    }
    
    func connect(headset: AuxHeadphones) {
        print("\(headset.specification) successfully connected to Iphone 6")
    }
}

//To this interface will be adopted aux headphones.
class IphoneX: Iphone {
    var inConnector: Connector {
        return .lightning
    }
    
    func connect(headset: LightningHeadphones) {
        print("\(headset.specification) successfully connected to Iphone X")
    }
}

class Person<I: Iphone, H> where I.HeadphonesType == H {
    let name: String
    var headphones: H
    var iphone: I
    
    init(name: String, headphones: H, iphone: I) {
        self.name = name
        self.headphones = headphones
        self.iphone = iphone
    }
    
    func listenMusic() {
        print("\(name) is trying connect headphones to iphone.")
        iphone.connect(headset: headphones)
    }
}

//Alex can listen music
let sonyC300 = Sony(model: "C-300")
let boy = Person(name: "Alex", headphones: sonyC300, iphone: Iphone6())
boy.listenMusic()

print("")

//Maria also can listen music
let beatsSoloHd = Beats(model: "Solo-Hd")
let girl = Person(name: "Maria", headphones: beatsSoloHd, iphone: IphoneX())
girl.listenMusic()

//But imagine, that Bob have aux hi-fi headphones with amazing characteristics
//And also Bob just bought newest iphone X.
//Damn... he can't listen music! Because iPhone X have only lightning in connector.
//No problems! Time for adapter!

let hifiHeadphones = Sony(model: "Hi-Fi")
let iphoneX = IphoneX()

/// Adapts aux headphones to lightning in connector.
class AuxAdapter: LightningHeadphones {
    var headphones: AuxHeadphones?
    
    convenience init(headphones: AuxHeadphones) {
        self.init(model: headphones.model)
        self.headphones = headphones
    }
    
    required init(model: String) {
        self.headphones = nil
        super.init(model: model)
    }
    
    override var specification: String {
        guard let headphones = headphones else { return "Aux Adapter haven't aux headphones." }
        return headphones.specification + " adopted to lightning"
    }
}

print("")
let lightningHifiHeadphones = AuxAdapter(headphones: hifiHeadphones)
let personBob = Person(name: "Bob", headphones: lightningHifiHeadphones, iphone: iphoneX)
personBob.listenMusic()

//Now, we wrap up aux headphones into adapter of and therefore Bob can listen music with their iphone x and sony aux headphones.
//It means, that we adopts aux interface to lightning interface.
