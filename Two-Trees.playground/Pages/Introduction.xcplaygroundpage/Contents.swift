//: # Binary Search Trees
//: In the world of computer science, a high level of efficiency is expected and demanded when designing an algorithm. One of the most famous data structures employed for this use is the [Binary Search Tree](https://en.wikipedia.org/wiki/Binary_search_tree). In this playground, you’ll learn how binary search trees work by making one yourself!

//: ## How Do They Work?
//: Each tree is made up of several interconnected nodes (represented as circles) that contain a value. Each node can have zero or one parent nodes (nodes connected above a node), and zero to two child nodes (connected below). 

//: ## But What Makes It A BST?
//: The most important part of the Binary Search Tree is the ordering property. For every node, the value of each left child node is *less than* the value of itself, and the value of each right child node is *greater than* itself! Easy!

//: [Next: How Do I Make One?](@next)

import PlaygroundSupport

PlaygroundPage.current.liveView = TreeView()
