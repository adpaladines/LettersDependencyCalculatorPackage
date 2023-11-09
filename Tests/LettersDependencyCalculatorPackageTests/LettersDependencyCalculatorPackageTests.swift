import XCTest
@testable import LettersDependencyCalculatorPackage

final class LettersDependencyCalculatorPackageTests: XCTestCase {
    func testExample() throws {
        
        let deps = LettersDependencyCalculatorPackage.new
//        deps.add_direct("A", ["B", "C"])
        deps.add_direct("A", "%w[B C]")
        deps.add_direct("B", ["C", "E"])
        deps.add_direct("C", ["G"])
        deps.add_direct("D", ["A", "F"])
        deps.add_direct("E", ["F"])
        deps.add_direct("F", ["H"])
        
        XCTAssertEqual(["B","C","E","F","G","H"],    deps.dependencies_for("A"))
//        XCTAssertEqual(["C","E","F","G","H"],        deps.dependencies_for("B"))
//        XCTAssertEqual(["G"],                        deps.dependencies_for("C"))
//        XCTAssertEqual(["A","B","C","E","F","G","H"],deps.dependencies_for("D"))
//        XCTAssertEqual(["F","H"],                    deps.dependencies_for("E"))
//        XCTAssertEqual(["H"],                        deps.dependencies_for("F"))

//        XCTAssertEqual(["H"],                       deps.dependencies_for("F"))

    }
}


