//: ## But What Makes It A BST?
//: The most important part of the Binary Search Tree is the ordering property. For every node, the value of each left child node is *less than* the value of itself, and the value of each right child node is *greater than* itself! Easy!

//: ## Insertion
//: To insert a node, start at the root (the topmost node). Determine if the value of the new node is less than or greater than this node, and follow the left edge or right edge respectively. If there is no edge in this direction, create a *new edge* here and connect it to the new node!

//: Finish the code to create the tree
var bst = BinarySearchTree(value:/*#-editable-code root node*/<#T##node##Int#>/*#-end-editable-code*/)

//: Add nodes into the tree!
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)

//: [Next: Traversal and Ordering](@next)

//#-hidden-code

import PlaygroundSupport
var bstView = BSTView(tree: bst)
PlaygroundPage.current.liveView = bstView

//#-end-hidden-code
