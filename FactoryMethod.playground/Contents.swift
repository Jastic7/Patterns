// Author: Andrey Morozov
// Date: 18 February 2018
//
// Pattern: Factory Method.
// Description: The Factory Method Pattern defines an interface for creating an object,
//              but lets subclasses decide which class to instantiate.
//              Factory Method lets a class defer instantiation to subclasses.
//              (c) Eric Freeman - Head First Design Patterns


import Foundation


class File {
    var title: String
    let creationDate: Date
    var description: String {
        return "File '\(title)' created at \(creationDate)"
    }
    
    init(title: String) {
        self.title = title
        self.creationDate = Date()
    }
}

class TextFile: File {
    var encoding: String
    
    init(title: String, encoding: String) {
        self.encoding = encoding
        super.init(title: title)
    }
}

class PDFFile: File {
    var compression: Int
    
    init(title: String, compression: Int) {
        self.compression = compression
        super.init(title: title)
    }
}

class AudioFile: File {
    let bitrate: Double
    
    init(title: String, bitrate: Double) {
        self.bitrate = bitrate
        super.init(title: title)
    }
}


protocol Program {
    func createFile(title:String, with fileExtension: String) -> File?
}

class Word: Program {
    func createFile(title: String, with fileExtension: String) -> File? {
        switch fileExtension {
        case "txt":
            return TextFile(title: title, encoding: "UTF-8")
        case "pdf":
            return PDFFile(title: title, compression: 20)
        default:
            return nil
        }
    }
}

class GarageBand: Program {
    func createFile(title: String, with fileExtension: String) -> File? {
        switch fileExtension {
        case "mp3":
            return AudioFile(title: title, bitrate: 128.0)
        case "aac":
            return AudioFile(title: title, bitrate: 320.0)
        default:
            return nil
        }
    }
}

class OperationSystem {
    var savedFiles = [File]()
    
    func save(file: File?) {
        guard let file = file else {
            print("File cannot be save")
            return
        }
        
        savedFiles.append(file)
        print("Successfully save: \(file.description)")
    }
}

// There are 3 type of files: text, pdf and audio files.
// Our operation system doesn't create files manually.
// All creation code incapsulates in classes, which implements Factory Method (Program)
// That approach allows to abstract at operation system level from concrete file classes and work only with
// base File class.

print("User is trying to create text file...")
let word = Word()
let letter = word.createFile(title: "My private message", with: "txt")
sleep(2) // simulate user interaction with system

print("User is trying to scan passport")
let passport = word.createFile(title: "International passport", with: "pdf")
sleep(3)

print("Use is trying to record song")
let garageBand = GarageBand()
let superHit = garageBand.createFile(title: "Despacito", with: "aac")
sleep(1)

print("User is trying to record melody")
let relaxMelody = garageBand.createFile(title: "Sound of Rain", with: "mp3")

var files = [letter, passport, superHit, relaxMelody]

let macOS = OperationSystem()
files.forEach { macOS.save(file: $0) }

// Another benefit from that approach (pattern) - we can easy add new type of file and program, which
// should be create files of that types without modifying code of any class. Because all creation code
// incapsulates in factory method (in our example 'createFile') in corresponding programs.

