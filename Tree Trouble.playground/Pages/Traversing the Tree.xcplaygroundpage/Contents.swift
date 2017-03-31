//: ## Traversal
//: One of the most notable features to the Binary Search Tree is the natural sorted nature of its elements. Using an [in-order traversal](https://en.wikipedia.org/wiki/Tree_traversal#In-order), a Binary Search Tree of any size can output its elements in ascending, sorted order!

//: ## In-Order Traversal
//: In a [tree traversal](https://en.wikipedia.org/wiki/Tree_traversal), we simply retrieve or process all tree nodes in a given order. To perform an *in-order traversal*, we will start at the root node, checking if it exists. The algorithm will then traverse the left subtree by recursively calling the traversal function again. It will then output the value of the current root node, followed by traversing the right subtree recursively.

//: Fill in the in order traversal below

extension BinarySearchTree {
    
    public func traverseInOrder(process: (Int) -> Void) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
}

var bst = BinarySearchTree(array: [21, 14, 27, 7, 16, 24, 32])
bst.traverseInOrder(process: { node in
    
    // Click the cube to the right to see your traversal results
    print(node)
})

//: [Challenge](@next)

//#-hidden-code

import PlaygroundSupport
var bstView = BSTView(tree: bst)
PlaygroundPage.current.liveView = bstView

//#-end-hidden-code
