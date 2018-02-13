// Author: Andrey Morozov
// Date: 08 February 2018
//
// Pattern: Observer.
// Description: The Observer Pattern defines a one-to-many dependency between objects
//              so that when one object changes state, all of its dependents are notified and updated automatically.
//              (c) Eric Freeman - Head First Design Patterns


import Foundation

protocol MediaContent {
    var title: String { get set }
}

struct Video: MediaContent {
    var title: String
}

struct Photo: MediaContent {
    var title: String
}

// Declare two protocols to construct Observer pattern.

/// Define the contract for listeners of observable subject.
protocol Observer: class {
    var name: String { get set }
    var source: Observable? { get set }
   
    func update(with newContent: MediaContent)
    func unsubscribe()
}

/// Declare the behavior of subject to which other
/// listeners will subscribe.
protocol Observable {
    func add(_ observer: Observer)
    func remove(_ observer: Observer)
    func notifyAll();
}


class Youtube {
    private var subscribers = [Observer]()
    private var content = [MediaContent]()
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func createVideo() {
        let newTitle = "Cool clip №\(content.count) with <3"
        content.append(Video(title: newTitle))
        
        print("\n\(name): Hey fans, there are new clip: '\(newTitle)' !")
        notifyAll()
    }
    
    func createPhoto() {
        let newTitle = "Funny photo №\(content.count)"
        content.append(Photo(title: newTitle))
        
        print("\n\(name): Hey fans, there are new photo: '\(newTitle)' !")
        notifyAll()
    }
}

extension Youtube: Observable {
    func add(_ observer: Observer) {
        subscribers.append(observer)
        observer.source = self
        
        print("\(observer.name) has been subscribed to the '\(name)' channel.")
    }
    
    func remove(_ observer: Observer) {
        subscribers = subscribers.filter({ observer !== $0 })
        observer.source = nil
        
        print("\(observer.name) has been removed from subscribers.")
    }
    
    func notifyAll() {
        guard let hotContent = content.last else {
            print("\n!!! Channel '\(name)' doesn't have content to notifying.")
            return
        }
        
        if subscribers.isEmpty {
            print("\n!!! Channel '\(name)' doesn't have any subscribers.")
            return
        }
        
        print("\nNotifications:----------------------------------------------------------------")
        subscribers.forEach { $0.update(with: hotContent) }
        print("------------------------------------------------------------------------------")
    }
}


class Subscriber: Observer {
    var name: String
    var source: Observable?
    
    init(_ name: String) {
        self.name = name
    }
    
    func update(with newContent: MediaContent) {
        print("|\t\(name) receive notification about new content: '\(newContent.title)'")
    }
    
    func unsubscribe() {
        source?.remove(self)
    }
}


let channel = Youtube(name: "Imagine Dragons")
let hater = Subscriber("Jacke(hater)")
let anotherHater = Subscriber("Alexa(hater)")
let subscribers = [hater, Subscriber("Bob"), anotherHater, Subscriber("Jack"), Subscriber("Tim")]

subscribers.forEach { channel.add($0) }
channel.createVideo()

hater.unsubscribe()
channel.createVideo()

anotherHater.unsubscribe()
channel.createPhoto()



