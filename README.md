# LettersDependencyCalculatorPackage

### The `add_direct(...)` method.
With each time we call the method `add_direct(...)`, the dictionary grows like in the following snippet printing the `dependencyData` variable at the end of the method (just for example purposes):
```Swift
let deps = LettersDependencyCalculatorPackage.new
deps.add_direct("A", ["B", "C"])
deps.add_direct("B", ["C", "E"])
deps.add_direct("C", ["G"])
deps.add_direct("D", ["A", "F"])
deps.add_direct("E", ["F"])
deps.add_direct("F", ["H"])
```
The prints:

    ["A": Set(["B", "C"])]
    ["B": Set(["E", "C"]), "A": Set(["B", "C"])]
    ["B": Set(["E", "C"]), "A": Set(["B", "C"]), "C": Set(["G"])]
    ["D": Set(["A", "F"]), "C": Set(["G"]), "A": Set(["B", "C"]), "B": Set(["E", "C"])]
    ["D": Set(["A", "F"]), "E": Set(["F"]), "C": Set(["G"]), "A": Set(["B", "C"]), "B": Set(["E","C"])]
    ["D": Set(["A", "F"]), "E": Set(["F"]), "C": Set(["G"]), "F": Set(["H"]), "A": Set(["B", "C"]), "B": Set(["E", "C"])]
    


### The `dependencies_for(...)` method.
**Q:** Why we use a `Set<String>` and not a simple `[String]`?
**A:** Because `Set` can only store one occurence of an item instead of an `Array` that can store multiple instances of the same item.

### First Loop:

``` Swift
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
                    print(result)
                }
                notFirstLoop = true // set it to true after the first loop ends
            }
        }
        return result.sorted() // sort the array to conform the source array in the test
    }

```

### Second Loop:

``` Swift
    func dependencies_for(_ item: String) -> [String] {
        //deps.dependencies_for("A")
        //(in the second loop, currentItem could be "B" or "C")
        var lettersViewed = Set<String>() // letters that already were "visited" lettersViewed=["A"]
        var lettersPool = Set<String>()// [item] // deposites the first letter to search for dependencies lettersPool=["B", "C"]
        var result = [String]() // example for the first loop result=["B", "C"]
        var notFirstLoop = false // Tell us if its the first loop or not notFirstLoop=true
        lettersPool.insert(item)
        
        while !lettersPool.isEmpty { // looking for empty array to finish loop. lettersPool.count=2
            let currentItem = lettersPool.removeFirst() // removes the current letter "B" lettersPool=["C"]
            if !lettersViewed.contains(currentItem) { // ask for the current letter "B" in lettersViewed (we have ["A"])
                lettersViewed.insert(currentItem) // inserts currentItem "B". lettersViewed=["A", "B"]
                if let dependencies = dependencyData[currentItem] { // dependencies = ["C", "E"]
                    for dependency in dependencies { // "loop in" for dependencies array
                        if !lettersViewed.contains(dependency) { //if the letter "C" is not visitted (currently lettersViewed=["A", "B"])
                            lettersPool.insert(dependency) // insert it to the lettersPool. lettersPool=["C", "E"] //because C is already in lettersPool, it is not inserted again, it's like magic.
                        }
                    }
                }
                if notFirstLoop { //if it's NOT the first loop
                    result.append(currentItem) // add the currentItem "B". result=["B"]
                }
                notFirstLoop = true // set it to true after the first loop ends
            }
        }
        return result.sorted() // sort the array to conform the source array in the test
    }

```

Currently we have a `lettersPool=["C","E"]`. 
If we try to insert the "C" letter again, we will get `(inserted: Bool, memberAfterInsert: String) $R1 = (inserted = false, memberAfterInsert = "C")`  **inserted = false**.
If we try to insert the "F" letter again, we will get `(inserted: Bool, memberAfterInsert: String) $R3 = (inserted = true, memberAfterInsert = "F")`  **inserted = true**.

There it is the magic of using `Set<String>` instead of `[String]` for the `lettersPool`
It can be seen in the Xcode Console as the example bellow:

```Python
(lldb) po lettersPool
▿ 2 elements
  - 0 : "E"
  - 1 : "C"

(lldb) exp lettersPool.insert("C")
(inserted: Bool, memberAfterInsert: String) $R1 = (inserted = false, memberAfterInsert = "C")
(lldb) po lettersPool
▿ 2 elements
  - 0 : "E"
  - 1 : "C"

(lldb) exp lettersPool.insert("F")
(inserted: Bool, memberAfterInsert: String) $R3 = (inserted = true, memberAfterInsert = "F")
(lldb) po lettersPool
▿ 3 elements
  - 0 : "E"
  - 1 : "C"
  - 2 : "F"

(lldb) 
```

### The nth Loop:

We will get all the letters from the variable `dependencyData`.

![The Tests run OK](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png/200px-Felis_silvestris_silvestris_small_gradual_decrease_of_quality.png)
