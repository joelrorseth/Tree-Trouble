//: # Binary Search Trees
//: In the world of computer science, a high level of efficiency is expected and demanded when designing an algorithm. One of the most famous data structures employed for this use is the [Binary Search Tree](https://en.wikipedia.org/wiki/Binary_search_tree). In this playground, you’ll learn how binary search trees work by making one yourself!

//: ## How Do They Work?
//: Each tree is made up of several *nodes* (represented as circles) that contain a value, each being connected to other nodes by one or more *edges* (represented as lines). Each node can have zero or one parent nodes (nodes connected above a node), and zero to two child nodes (connected below). The value of each left node is less than its parent's value, and each right child's value is greater.

//: [Next: The Ordering Property](@next)

// Run the code to see how the Binary Search Tree will insert the values!
var bst = BinarySearchTree(array: [4, 2, 6, 1, 3, 5, 7])

//#-hidden-code

import PlaygroundSupport
var bstView = BSTView(tree: bst)
PlaygroundPage.current.liveView = bstView

//#-end-hidden-code
