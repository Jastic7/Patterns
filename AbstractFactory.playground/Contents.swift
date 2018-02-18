// Author: Andrey Morozov
// Date: 18 February 2018
//
// Pattern: Abstract Factory.
// Description: The Abstract Factory Pattern provides an interface for creating families of related
//              or dependent objects without specifying their concrete classes.
//              (c) Eric Freeman - Head First Design Patterns


class File {
    var title: String
    var fileExtension: String
    
    var fullName: String {
        return "\(title).\(fileExtension)"
    }
    
    init(title: String) {
        self.title = title
        fileExtension = ""
    }
}

//Microsoft office documents

class WordFile: File {
    override init(title: String) {
        super.init(title: title)
        fileExtension = "docx"
    }
}

class PowerPointFile: File {
    override init(title: String) {
        super.init(title: title)
        fileExtension = "pptx"
    }
}

class ExcelFile: File {
    override init(title: String) {
        super.init(title: title)
        fileExtension = "xlsx"
    }
}

//Apple office documents

class PagesFile: File {
    override init(title: String) {
        super.init(title: title)
        fileExtension = "pages"
    }
}

class NumbersFile: File {
    override init(title: String) {
        super.init(title: title)
        fileExtension = "numbers"
    }
}

class KeynoteFile: File {
    override init(title: String) {
        super.init(title: title)
        fileExtension = "keynote"
    }
}


protocol OfficeProgram {
    func createTextFile(title: String) -> File
    func createSheetFile(title: String) -> File
    func createPresentationFile(title: String) -> File
}

class AppleOffice: OfficeProgram {
    func createTextFile(title: String) -> File {
        return PagesFile(title: title)
    }
    
    func createSheetFile(title: String) -> File {
        return NumbersFile(title: title)
    }
    
    func createPresentationFile(title: String) -> File {
        return KeynoteFile(title: title)
    }
}

class MicrosoftOffice: OfficeProgram {
    func createTextFile(title: String) -> File {
        return WordFile(title: title)
    }
    
    func createSheetFile(title: String) -> File {
        return ExcelFile(title: title)
    }
    
    func createPresentationFile(title: String) -> File {
        return PowerPointFile(title: title)
    }
}

enum OperationSystem {
    case macOS
    case windows
}

class Computer {
    var office: OfficeProgram
    let operationSystem: OperationSystem
    var documents = [File]()
    
    init(operationSystem: OperationSystem) {
        self.operationSystem = operationSystem
        
        switch operationSystem {
        case .macOS:
            office = AppleOffice()
        case .windows:
            office = MicrosoftOffice()
        }
    }
    
    func createCourseWork() {
        documents.removeAll()
        
        let presentation = office.createPresentationFile(title: "Pitch demo")
        let calculations = office.createSheetFile(title: "Market analysis sheets")
        let documentation = office.createTextFile(title: "Student course work")
        
        documents.append(contentsOf: [presentation, calculations, documentation])
    }
    
    func presentCourseWork() {
        print("There are my course work:")
        documents.forEach { print("- " + $0.fullName) }
    }
}

print("MacBook")
let macBook = Computer(operationSystem: .macOS)
let surface = Computer(operationSystem: .windows)

macBook.createCourseWork()
macBook.presentCourseWork()

print("\nSurface")
surface.createCourseWork()
surface.presentCourseWork()
