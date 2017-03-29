public class BinarySearchTree<T: Comparable> {
    
    fileprivate(set) public var value: T
    fileprivate(set) public var parent: BinarySearchTree?
    fileprivate(set) public var left: BinarySearchTree?
    fileprivate(set) public var right: BinarySearchTree?
    
    // =====================================
    // =====================================
    public init(value: T) {
        self.value = value
    }
    
    // =====================================
    // =====================================
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        
        // Insert each value one by one using insert()
        for value in array.dropFirst() {
            insert(value: value)
        }
    }
    
    // =====================================
    // =====================================
    public func insert(value: T) {
        
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
    public func traverseInOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
    
    // =====================================
    // =====================================
    public func traversePreOrder(process: (T) -> Void) {
        process(value)
        left?.traversePreOrder(process: process)
        right?.traversePreOrder(process: process)
    }
    
    // =====================================
    // =====================================
    public func traversePostOrder(process: (T) -> Void) {
        left?.traversePostOrder(process: process)
        right?.traversePostOrder(process: process)
        process(value)
    }
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    public var isLeftChild: Bool {
        return parent?.left === self
    }
    
    public var isRightChild: Bool {
        return parent?.right === self
    }
    
    public var hasLeftChild: Bool {
        return left != nil
    }
    
    public var hasRightChild: Bool {
        return right != nil
    }
    
    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    public var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
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
    public func isBST(minValue: T, maxValue: T) -> Bool {
        
        if (value < minValue || value > maxValue) { return false }
        let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
        let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
        return leftBST && rightBST
    }
    
    // =====================================
    // Return array representation (inorder trav)
    // =====================================
    public func arrayRepresentation() -> [T] {
        
        var array = [T]()
        
        // Left node
        if let leftNode = left {
            array += leftNode.arrayRepresentation()
        }
        
        // Root node
        array.append(value)
        
        // Right node
        if let rightNode = right {
            array += rightNode.arrayRepresentation()
        }
        
        return array
    }
}
