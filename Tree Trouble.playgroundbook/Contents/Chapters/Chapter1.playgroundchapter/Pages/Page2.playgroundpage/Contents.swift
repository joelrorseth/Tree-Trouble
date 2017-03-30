//: ## But What Makes It A BST?
//: The most important part of the Binary Search Tree is the ordering property. For every node, the value of each left child node is *less than* the value of itself, and the value of each right child node is *greater than* itself! Easy!

//: ## Insertion
//: To insert a node, start at the root (the topmost node). Determine if the value of the new node is less than or greater than this node, and follow the left edge or right edge respectively. If there is no edge in this direction, create a *new edge* here and connect it to the new node!

//: ## Can You Find the Missing Piece?
//: Drag the nodes at the bottom into the correct place!

//#-hidden-code

import PlaygroundSupport
PlaygroundPage.current.liveView = GameView()

//#-end-hidden-code
