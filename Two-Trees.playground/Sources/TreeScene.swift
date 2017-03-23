import PlaygroundSupport
import SpriteKit
import UIKit

public class TreeScene: SKScene {
    
    var movableNode : SKNode?
    var background = SKSpriteNode(imageNamed: "background.jpg")
    
    // =====================================
    // =====================================
    override public func didMove(to view: SKView) {
        
        // TODO: Allow image to resize screen upon rotation
        // Add background image to scene as a node
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.scale(to: self.size)
        addChild(background)
    }
    
    // =====================================
    // =====================================
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =====================================
    // =====================================
    public override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.81)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.backgroundColor = SKColor.white
        
//        // Test: create a binary tree
//        let tree = BinarySearchTree<Int>(value: 7)
//        tree.insert(value: 2)
//        tree.insert(value: 5)
//        tree.insert(value: 10)
//        tree.insert(value: 9)
//        tree.insert(value: 1)
//        tree.insert(value: 11)
//        tree.insert(value: 13)
//        tree.insert(value: 6)
//        tree.insert(value: 3)
//        tree.insert(value: 8)
//        
//        // Test by displaying the tree in the top half of view
//        let topHalfView = CGSize(width: self.size.width, height: self.size.height / 2)
//        let treeHeight = tree.height()
//
//        // Testing: Draw binary tree created above
//        self.drawBST(tree: tree,
//                     within: topHalfView,
//                     at: CGPoint(x: topHalfView.width / 2, y: self.size.height - 30),
//                     offset: CGFloat(tree.height()),
//                     originalHeight: treeHeight)
        
        createRandomBST(withCount: 3)

    }
    
    // =====================================
    // =====================================
    public func drawNode(at point: CGPoint, value: Int, radius: CGFloat, color: SKColor, dynamic: Bool = false) {
        
        // Create Node and set position in scene
        let sprite = Node()
        sprite.setup(value: value, radius: radius, color: color, dynamic: dynamic)
        sprite.position = point
        
        self.addChild(sprite)
    }
    
    // =====================================
    // =====================================
    func createRandomBST(withCount count: Int) {
        
        let nodeCount = Int(NSDecimalNumber(decimal: pow(2, count + 1))) - 1
        var array: [Int] = []
        
        // Assign random numbers to a temp array
        for _ in 0..<nodeCount {
            array.append(Int(arc4random_uniform(100)))
        }
        
        // Sort the array in preparation for balancing algorithm
        array.sort()

        // Reorder array to distribute as balanced / complete BST, copy back
        let newOrder = sortForCompleteTree(array: array, index: 0)
        for (index, value) in newOrder {
            array[index] = value
        }
        
    
        // Create BST and insert sequentially with newly balanced array
        let tree = BinarySearchTree<Int>(value: array[0])
        for i in 1..<nodeCount {
            tree.insert(value: array[i])
        }
        
        let topHalfView = CGSize(width: self.size.width, height: self.size.height / 2)
        
        self.drawBST(tree: tree,
                     within: topHalfView,
                     at: CGPoint(x: topHalfView.width / 2, y: self.size.height - 30),
                     offset: CGFloat(tree.height()),
                     originalHeight: tree.height())
    }
    
    // =====================================
    // =====================================
    func sortForCompleteTree(array: [Int], index: Int) -> [Int : Int] {
        
        var array = array
        let midpoint = array.count / 2
        var result: [Int:Int] = [:]
        
        if (midpoint == 0) {
            return [index: array[midpoint]]
        }
        
        // Divide array in half and call recursively
        let firstHalf = Array(array.prefix(upTo: midpoint))
        let secondHalf = Array(array.suffix(from: midpoint + 1))
        
        // The index of the node must increment based on left and right
        result += sortForCompleteTree(array: firstHalf, index: (index*2) + 1)
        result += sortForCompleteTree(array: secondHalf, index: (2*index) + 2)
        
        // Result will hold key,value pairs corresponding to an array index
        result += [index:array[midpoint]]
        return result
    }
    
    
    // =====================================
    // =====================================
    public func drawBST(tree: BinarySearchTree<Int>, within size: CGSize, at point: CGPoint, offset: CGFloat, originalHeight: Int) {
        
        // Use temp placeholders for size and color
        let nodeColor = SKColor.white
        let temp = tree
            
        let nodeRadius = CGFloat(size.width / (2 * pow(2, CGFloat(originalHeight + 1))))
        let spacingWidth = CGFloat(size.width / (2 * pow(2, CGFloat(temp.depth() + 1))))
        let spacingHeight = size.height / CGFloat(originalHeight + 1)
        
        
        
        
        // Traverse left branch, decrement x and increment y positions
        if (temp.hasLeftChild) {
            drawBST(tree: temp.left!,
                    within: size,
                    at: CGPoint(x: point.x - spacingWidth, y: point.y - spacingHeight),
                    offset: (offset - 1),
                    originalHeight: originalHeight)
        }
        
        // Traverse right branch, increment x and y positions
        if (temp.hasRightChild) {
            drawBST(tree: temp.right!,
                    within: size,
                    at: CGPoint(x: point.x + spacingWidth, y: point.y - spacingHeight),
                    offset: (offset - 1),
                    originalHeight: originalHeight)
        }
        
        // Add node now that traversal has exhausted itself to this Node
        drawNode(at: point, value: temp.value, radius: nodeRadius, color: nodeColor)
    }
    
    // =====================================
    // =====================================
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                
        if let touch = touches.first {
            
            // Extract touch location and all nodes under this point
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            
            if (touchedNodes.isEmpty) { return }
            print("Touched x:\(location.x) y:\(location.y)")
            
            let parentNode = touchedNodes[touchedNodes.count - 1]
            if parentNode is Node {
                movableNode = parentNode as! SKSpriteNode
                movableNode!.position = location
            }
        }
    }
    
    // =====================================
    // =====================================
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
            movableNode?.physicsBody?.isDynamic = false
        }
    }
    
    // =====================================
    // =====================================
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
            movableNode?.physicsBody?.isDynamic = true
            movableNode = nil
        }
    }
    
    // =====================================
    // =====================================
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            movableNode = nil
        }
    }
}

func += <K, V> ( left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
