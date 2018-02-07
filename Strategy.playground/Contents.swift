// Author: Andrey Morozov
// Date: 07 February 2018
//
// Pattern: Strategy.
// Description: The Strategy Pattern defines a family of algorithms,
//              encapsulates each one, and makes them interchangeable.
//              Strategy lets the algorithm vary independently from clients that use it.
//              (c) Eric Freeman - Head First Design Patterns


// v1.0
//class Vehicle {
//    func makeNoise() {}
//}


// v2.0
class Vehicle {
    func makeNoise() {}
    func fly() {}
}

class Car: Vehicle {
    override func makeNoise() {
        print("Quiet Creak of wheels")
    }
}

class Train: Vehicle {
    override func makeNoise() {
        print("Loud rail knocking")
    }
}

class Bicycle: Vehicle {
    override func makeNoise() {
        print("*No sound*")
    }
}

print("-=First vehicles party=-\n")
var vehicles = [Car(), Train(), Bicycle()]
for vehicle in vehicles {
    vehicle.makeNoise()
    print("--------------")
}

// Now, it's look pretty. We use inheritence like OOP style and override super class behavior.
// But lets imagine, that we need new type of Vehicle, which can fly.
// Ok, now add new method - fly to our base class. (Vehicle v2.0)

class Airplane: Vehicle {
    override func makeNoise() {
        print("*Сreak sound*")
    }
    
    override func fly() {
        print("flying too slow")
    }
}

vehicles.append(Airplane())

print("\n\n-=Add Airplane to vehicles=-\n")
for vehicle in vehicles {
    vehicle.makeNoise()
    vehicle.fly()
    print("--------------")
}

// Damn, now, we got fly() method in all our subclasses of Vehicle.
// This architecture isn't good.

// For example, if we need to add another features or behavior to our vehicles,
// then we will accumulate all behaviors in the base class. Also, that approach
// doesn't allow change behavior at runtime. We must determine behavior at compile time :(

// Ok, time for pattern Strategy.
// Try use COMPOSITION instead of INHERITENCE

// Prepare for strategy pattern

protocol NoiseBehavior {
    func makeNoise()
}

protocol FlyBehavior {
    func fly()
}

class ModernizedVehicle {
    var noiseBehavior: NoiseBehavior!
    var flyBehavior: FlyBehavior!
    
    func makeNoise() {
        self.noiseBehavior.makeNoise()
    }
    
    func fly() {
        self.flyBehavior.fly()
    }
}

class RocketFly: FlyBehavior {
    func fly() {
        print("Amazing reactive speed of fly")
    }
}

class OldFly: FlyBehavior {
    func fly() {
        print("So sloooow fly, because it use propellers")
    }
}

class NoFly: FlyBehavior {
    func fly() {
        print("Cannot fly")
    }
}

class RailNoise: NoiseBehavior {
    func makeNoise() {
        print("Very loud rails sound.")
    }
}

class WheelNoise: NoiseBehavior {
    func makeNoise() {
        print("Normal noise level from wheel")
    }
}

class SilentNoise: NoiseBehavior {
    func makeNoise() {
        print("There aren't noise at all")
    }
}

class StrangeLoudNoise: NoiseBehavior {
    func makeNoise() {
        print("Some strange extremely loud noise")
    }
}

// Apply our strategy pattern

class ModernizedCar: ModernizedVehicle {
    override init() {
        super.init()
        self.flyBehavior = NoFly()
        self.noiseBehavior = WheelNoise()
    }
}

class ModernizedTrain: ModernizedVehicle {
    override init() {
        super.init()
        self.flyBehavior = NoFly()
        self.noiseBehavior = RailNoise()
    }
}

class ModernizedBicycle: ModernizedVehicle {
    override init() {
        super.init()
        self.flyBehavior = NoFly()
        self.noiseBehavior = SilentNoise()
    }
}

class PropellerAirplane: ModernizedVehicle {
    override init() {
        super.init()
        self.flyBehavior = OldFly()
        self.noiseBehavior = StrangeLoudNoise()
    }
}

print("\n\n-=Modernized vehicles=-\n")
var modernizedVehicles = [ModernizedCar(), ModernizedTrain(), ModernizedBicycle(), PropellerAirplane()]
for modernizedVehicle in modernizedVehicles {
    modernizedVehicle.makeNoise()
    modernizedVehicle.fly()
    print("--------------")
}

print("\n\n-=Airplane has been upgrated=-\n")
let rocketAirplane = modernizedVehicles.last!
rocketAirplane.noiseBehavior = SilentNoise()
rocketAirplane.flyBehavior = RocketFly()
rocketAirplane.fly()
rocketAirplane.makeNoise()


// There is one huge benefit from usage of strategy pattern:
// We can change behavior of our objects at runtime,
// just by setting another behavior to properties.
// And another cool feature - we can add many different behaviors later,
// without changing exist code. 
