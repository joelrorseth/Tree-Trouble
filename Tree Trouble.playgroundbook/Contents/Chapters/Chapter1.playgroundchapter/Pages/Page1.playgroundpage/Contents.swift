//: # Binary Search Trees
//: In the world of computer science, a high level of efficiency is expected and demanded when designing an algorithm. One of the most famous data structures employed for this use is the [Binary Search Tree](https://en.wikipedia.org/wiki/Binary_search_tree). In this playground, you’ll learn how binary search trees work by making one yourself!

//: ## How Do They Work?
//: Each tree is made up of several interconnected nodes (represented as circles) that contain a value. Each node can have zero or one parent nodes (nodes connected above a node), and zero to two child nodes (connected below). Each left child is less than its parent, and each right child is greater.

//: [Next: The Ordering Property](@next)

//#-hidden-code
import PlaygroundSupport
//#-end-hidden-code

//: Finish the code to create the tree
var bst = BinarySearchTree<Int>(value:/*#-editable-code root node*/<#T##node##Int#>/*#-end-editable-code*/)

//: Add nodes into the tree!
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)
bst.insert(value: /*#-editable-code number*/<#T##node##Int#>/*#-end-editable-code*/)

//#-hidden-code
var bstView = BSTView(tree: bst)
PlaygroundPage.current.liveView = bstView
//#-end-hidden-code
