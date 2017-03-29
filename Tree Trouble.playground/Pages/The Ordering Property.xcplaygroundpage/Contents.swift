//: ## But What Makes It A BST?
//: The most important part of the Binary Search Tree is the ordering property. For every node, the value of each left child node is *less than* the value of itself, and the value of each right child node is *greater than* itself! Easy!

//: ## Insertion
//: To insert a node, start at the root (the topmost node). Determine if it is less than or greater than, and follow the left branch or right branch respectively. If there are no more branches, leave it!

//: ## Can You Find the Missing Piece?
//: Drag the nodes at the bottom into the correct place!

//: [Next](@next)

import PlaygroundSupport

PlaygroundPage.current.liveView = GameView()
