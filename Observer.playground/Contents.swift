// Author: Andrey Morozov
// Date: 08 February 2018
//
// Pattern: Observer.
// Description: The Observer Pattern defines a one-to-many dependency between objects
//              so that when one object changes state, all of its dependents are notified and updated automatically.
//              (c) Eric Freeman - Head First Design Patterns

import Foundation

protocol Observer {
    var id: String { get set }
    func update()
}

protocol Observable {
    func add(_ observer: Observer)
    func remove(_ observer: Observer)
    func notifyAll();
}

class Youtube: Observable {
    private var subscribers = [Observer]()
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func add(_ observer: Observer) {
        subscribers.append(observer)
    }
    
    func remove(_ observer: Observer) {
        subscribers = subscribers.filter({ observer.id != $0.id })
    }
    
    func notifyAll() {
        subscribers.forEach { $0.update() }
    }
}

class Subscriber: Observer {
    var id: String
    
    init(_ id: String) {
        self.id = id
    }
    
    func update() {
        print("\(id) receive notification")
    }
}

let subscribers = [Subscriber("Bob"), Subscriber("Alexa"), Subscriber("Jack"), Subscriber("Tim")]
let channel = Youtube(title: "Apple")
subscribers.forEach { channel.add($0) }
channel.notifyAll()


