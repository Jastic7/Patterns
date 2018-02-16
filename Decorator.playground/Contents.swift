// Author: Andrey Morozov
// Date: 16 February 2018
//
// Pattern: Decorator.
// Description:  The Decorator Pattern attaches additional responsibilities to an object dynamically.
//               Decorators provide a flexible alternative to subclassing for extending functionality.
//              (c) Eric Freeman - Head First Design Patterns


enum MeatType: String {
    case pork = "pork"
    case beef = "beef"
    case chicken = "chicken"
}

enum MeatDone: String {
    case raw = "raw"
    case medium = "medium"
    case well = "well"
    case wellDone = "wellDone"
}

/// Protocol for concrete burgers
protocol Burger {
    var cost: Double { get }
    var description: String { get }
    var meat: MeatType { get }
}

/// First concrete burger
struct Cheeseburger: Burger {
    var cost: Double {
        return 1.5
    }
    
    var description: String {
        return "Cheeseburger for \(cost)$"
    }
    
    var meat: MeatType {
        return .beef
    }
}

/// Second concrete burger
struct BigMac: Burger {
    var cost: Double {
        return 3.0
    }

    var description: String {
        return "BigMac for \(cost)$"
    }

    var meat: MeatType {
        return .pork
    }
}

/// Third concrete burger
struct Hamburger: Burger {
    var cost: Double {
        return 1.0
    }
    
    var description: String {
        return "Hamburger for \(cost)$"
    }

    var meat: MeatType {
        return .chicken
    }
}

/// Base class for all decorators.
/// Initialization using a burger instance to be decorated.
class BurgerDecorator: Burger {
    private let burger: Burger

    init(burger: Burger) {
        self.burger = burger
    }
    
    var cost: Double {
        return burger.cost
    }

    var description: String {
        return burger.description
    }

    var meat: MeatType {
        return burger.meat
    }
}

/// Put additional piece of cheese into burger.
final class ExtraCheese: BurgerDecorator {
    private let ingredientCost = 0.3

    override var cost: Double {
        return super.cost + ingredientCost
    }
    
    override var description: String {
        return super.description + " with extra cheese (\(ingredientCost)$)"
    }
}

/// Put additional cutlet with some type of done into burger.
final class ExtraCutlet: BurgerDecorator {
    private var ingredientCost: Double {
        switch(meat) {
        case .pork: return 0.6
        case .beef: return 1.0
        case .chicken: return 0.8
        }
    }
    
    private var meatDoneCost: Double {
        switch meatDone {
        case .medium: return 0.3
        default: return 0.1
        }
    }
    
    let meatDone: MeatDone
    
    init(burger: Burger, meatDone: MeatDone) {
        self.meatDone = meatDone
        super.init(burger: burger)
    }

    override var cost: Double {
        return super.cost + ingredientCost + meatDoneCost
    }

    override var description: String {
        return super.description + " with extra \(meat.rawValue) \(meatDone.rawValue) cutlet (\(ingredientCost + meatDoneCost)$)"
    }
}


//Usage example

var cheeseBurger = Cheeseburger()
print("Normal cheese burger: \(cheeseBurger.description)")

var doubleCutletCheeseBurger = ExtraCutlet(burger: cheeseBurger, meatDone:.medium)
print("Added 1x cutlet: \(doubleCutletCheeseBurger.description) = \(doubleCutletCheeseBurger.cost)$")

var doubleCheeseAndCutletCheeseBurger = ExtraCheese(burger: doubleCutletCheeseBurger)
print("Added 1x cheese and 1x cutlet: \(doubleCheeseAndCutletCheeseBurger.description) = \(doubleCheeseAndCutletCheeseBurger.cost)$\n")


var bigMac = BigMac()
print("Normal bigmac burger: \(bigMac.description)")

var trippleCheeseBigMac = ExtraCheese(burger: ExtraCheese(burger: bigMac))
print("Added 2x cheese: \(trippleCheeseBigMac.description) = \(trippleCheeseBigMac.cost)$\n")


var hamBurger = Hamburger()
print("Normal hamburger: \(hamBurger.description)")

var superHamburger: Burger = ExtraCheese(burger: hamBurger)
superHamburger = ExtraCutlet(burger: superHamburger, meatDone: .wellDone)
superHamburger = ExtraCheese(burger: superHamburger)
print("Added 2x cheese, 1x cutlet: \(superHamburger.description) = \(superHamburger.cost)$")
