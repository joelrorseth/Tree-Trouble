public class BinarySearchTree {
    
    fileprivate(set) public var value: Int
    fileprivate(set) public var parent: BinarySearchTree?
    fileprivate(set) public var left: BinarySearchTree?
    fileprivate(set) public var right: BinarySearchTree?
    
    // =====================================
    // =====================================
    public init(value: Int) {
        self.value = value
    }
    
    // =====================================
    // =====================================
    public convenience init(array: [Int]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        
        // Insert each value one by one using insert()
        for value in array.dropFirst() {
            insert(value: value)
        }
    }
    
    // =====================================
    // =====================================
    public func insert(value: Int) {
        
        // If less, insert into left branch recursively
        if value < self.value {
            if let left = left {
                left.insert(value: value)
            } else {
                left = BinarySearchTree(value: value)
                left?.parent = self
            }
            
        // Else insert into right branch recursively
        } else {
            if let right = right {
                right.insert(value: value)
            } else {
                right = BinarySearchTree(value: value)
                right?.parent = self
            }
        }
    }

    // =====================================
    // =====================================
    public var isRoot: Bool {
        return parent == nil
    }
    
    // =====================================
    // =====================================
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    // =====================================
    // =====================================
    public var hasLeftChild: Bool {
        return left != nil
    }
    
    // =====================================
    // =====================================
    public var hasRightChild: Bool {
        return right != nil
    }
    
    // =====================================
    // Nuber of nodes in subtree
    // =====================================
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
    
    // =====================================
    // =====================================
    public func depth() -> Int {
        var node = self
        var edges = 0
        while case let parent? = node.parent {
            node = parent
            edges += 1
        }
        return edges
    }
    
    // =====================================
    // =====================================
    public func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
        }
    }
    
    // =====================================
    // Important for the game (Validate correctness of BST)
    // =====================================
    public func isBST(minValue: Int, maxValue: Int) -> Bool {
        
        if (value < minValue || value > maxValue) { return false }
        let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
        let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
        return leftBST && rightBST
    }
    
    // =====================================
    // Search / Find node with value
    // =====================================
    public func findNode(value: Int) -> BinarySearchTree? {
        var nodeToCheck: BinarySearchTree? = self
        
        while case let currentNode? = nodeToCheck {
            if value < currentNode.value {
                nodeToCheck = currentNode.left
            } else if value > currentNode.value {
                nodeToCheck = currentNode.right
            } else {
                return nodeToCheck
            }
        }
        return nil
    }
}
