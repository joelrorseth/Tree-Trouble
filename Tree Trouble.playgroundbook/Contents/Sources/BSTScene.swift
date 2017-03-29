import PlaygroundSupport
import SpriteKit
import UIKit

public class BSTScene: SKScene {
    
    var background = SKSpriteNode(imageNamed: "background.png")
    var game: Game!
    var nodePoints: [CGPoint] = []
    
    // =====================================
    // =====================================
    override public func didMove(to view: SKView) {
        
        // Add background image to scene as a node
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.scale(to: self.size)
        addChild(background)
    }
    
    // MARK: Possibly delete
    // =====================================
    // =====================================
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Possibly delete
    // =====================================
    // =====================================
    public override init(size: CGSize) {
        super.init(size: size)
    }
    
    // =====================================
    // =====================================
    func createTree(tree: BinarySearchTree<Int>) {
        
        // TODO: Current balancing algorithm only compiles for complete trees
        // Determine course of action for handling automatic balancing (or not)
        
        
        //        var arrayRepresentation = tree.arrayRepresentation()
        //        arrayRepresentation.sort()
        //
        //        // Reorder array to distribute as balanced / complete BST, copy back
        //        let newOrder = sortForCompleteTree(array: arrayRepresentation, index: 0)
        //        for (index, value) in newOrder {
        //            arrayRepresentation[index] = value
        //        }
        //
        //        // Create BST and insert sequentially with newly balanced array
        //        let newTree = BinarySearchTree<Int>(value: arrayRepresentation[0])
        //        for i in 1..<(arrayRepresentation.count-1) {
        //            newTree.insert(value: arrayRepresentation[i])
        //        }
        
        
        drawBST(tree: tree,
                within: CGSize(width: self.size.width,
                               height: self.size.height),
                at: CGPoint(x: self.size.width / 2, y: self.size.height - 30),
                offset: CGFloat(tree.height()),
                originalHeight: tree.height())
    }
    
    
    // =====================================
    // =====================================
    func createRandomBST(withCount count: Int) {
        
        let nodeCount = Int(NSDecimalNumber(decimal: pow(2, count + 1))) - 1
        var array: [Int] = []
        
        // Assign random numbers to a temp array
        for _ in 0..<nodeCount {
            var rand = Int(arc4random_uniform(100))
            
            // If array already has this value, remove duplicate node
            while (array.contains(rand)) {
                rand = Int(arc4random_uniform(100))
            }
            
            array.append(rand)
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
    
    
    
    // MARK: Drawing
    // =====================================
    // =====================================
    public func drawEdge(from pointA: CGPoint, to pointB: CGPoint, width: CGFloat) {
        
        let edgePath  = CGMutablePath()
        edgePath.move(to: CGPoint(x: pointA.x, y: pointA.y))
        edgePath.addLine(to: CGPoint(x: pointB.x, y: pointB.y))
        
        // Create a SKShapeNode to represent the edge as a straight line
        let shape = SKShapeNode()
        shape.path = edgePath
        shape.strokeColor = SKColor.black
        shape.lineWidth = width
        shape.zPosition = 4
        
        addChild(shape)
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
    public func drawBST(tree: BinarySearchTree<Int>, within size: CGSize, at point: CGPoint, offset: CGFloat, originalHeight: Int) {
        
        
        // Use temp placeholders for size and color
        let nodeColor = SKColor.white
        let temp = tree
        
        let nodeRadius = CGFloat(size.width / (2 * pow(2, CGFloat(originalHeight + 1))))
        let spacingWidth = CGFloat(size.width / (2 * pow(2, CGFloat(temp.depth() + 1))))
        let spacingHeight = size.height / CGFloat(originalHeight + 1)
        
        
        // Traverse left branch, decrement x and increment y positions
        if (temp.hasLeftChild) {
            
            // Calculate new point, draw edge between current and new nodes
            let newPoint = CGPoint(x: point.x - spacingWidth, y: point.y - spacingHeight)
            self.drawEdge(from: point, to: newPoint, width: CGFloat(6 - originalHeight))
            
            drawBST(tree: temp.left!,
                    within: size,
                    at: newPoint,
                    offset: (offset - 1),
                    originalHeight: originalHeight)
        }
        
        
        // Traverse right branch, increment x and y positions
        if (temp.hasRightChild) {
            
            // Calculate new point, draw edge between current and new nodes
            let newPoint = CGPoint(x: point.x + spacingWidth, y: point.y - spacingHeight)
            self.drawEdge(from: point, to: newPoint, width: CGFloat(6 - originalHeight))
            
            drawBST(tree: temp.right!,
                    within: size,
                    at: newPoint,
                    offset: (offset - 1),
                    originalHeight: originalHeight)
        }
        
        // Add node now that traversal has exhausted itself to this Node
        drawNode(at: point, value: temp.value, radius: nodeRadius, color: nodeColor)
    }
}

func += <K, V> ( left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
