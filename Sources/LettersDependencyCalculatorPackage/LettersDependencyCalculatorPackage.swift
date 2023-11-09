import Foundation

public class LettersDependencyCalculatorPackage {
    
    //MARK: Public Vars
    static public private(set) var new = LettersDependencyCalculatorPackage()
    
    //MARK: Private Vars
    private var dependencyData: [String: Set<String>] = [:] // I noticed the existence of Set while learning a little about Combine Framework that usually uses the Sets of AnyPublishers for the reactive programming.
    
    //MARK: - Init
    public init() {}
    
    //MARK: - Private methods
    private func deleteExtraContent(from text: String) -> String {
        var newString = text
        newString = newString
            .replacingOccurrences(of: "%w[", with: "")
            .replacingOccurrences(of: "]", with: "")
        return newString
    }
    
    private func getArrayFrom(string: String) -> [String] {
        let array = string
            .split(separator:" ")
            .joined()
            .map{ String($0) }
        return array
    }
    
    //MARK: - Public methods
    public func add_direct(_ letter: String, _ dependencies: [String]) {
        if dependencyData[letter] == nil {
            dependencyData[letter] = Set<String>()
        }
        dependencies.forEach({dependencyData[letter]?.insert($0)})
    }
    
    /// If you plan to use the Ruby strings like "%w[A B C]", this is your method
    public func add_direct(_ letter: String, _ rubyString: String) {
        let newString = deleteExtraContent(from: rubyString)
        let dependencies = getArrayFrom(string: newString)
        add_direct(letter, dependencies)
    }
    
    func dependencies_for(_ item: String) -> [String] {
        //deps.dependencies_for("A")
        var lettersViewed = Set<String>() // letters that already were "visited"
        var lettersPool = Set<String>()// [item] // deposites the first letter to search for dependencies
        var result = [String]() // example for the first loop
        var notFirstLoop = false // Tell us if its the first loop or not
        lettersPool.insert(item)
        
        while !lettersPool.isEmpty { // looking for empty array to finish loop
            let currentItem = lettersPool.removeFirst() // removes the current letter "A"
            if !lettersViewed.contains(currentItem) { // ask for the current letter "A" in lettersViewed
                lettersViewed.insert(currentItem) // inserts currentItem "A" in lettersViewed
                if let dependencies = dependencyData[currentItem] { // dependencies = ["B", "C"]
                    for dependency in dependencies { // "loop in" for dependencies array
                        if !lettersViewed.contains(dependency) { //if the letter "A" is not visitted
                            lettersPool.insert(dependency) // add it to the lettersPool
                        }
                    }
                }
                if notFirstLoop { //if it's NOT the first loop
                    result.append(currentItem) // add the currentItem. (in the second loop, this letter could be "B" or "C" )
                }
                notFirstLoop = true // set it to true after the first loop ends
            }
        }
        return result.sorted() // sort the array to conform the source array in the test
    }
    
}
