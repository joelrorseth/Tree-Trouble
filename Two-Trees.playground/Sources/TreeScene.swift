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
        
        // Test: create a binary tree
        let tree = BinarySearchTree<Int>(value: 7)
        tree.insert(value: 2)
        tree.insert(value: 5)
        tree.insert(value: 10)
        tree.insert(value: 9)
        tree.insert(value: 1)
        tree.insert(value: 11)

        // Testing: Draw binary tree created above
        self.drawBST(tree: tree, point: CGPoint(x: 150, y: 300), offset: CGFloat(tree.height()))
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
    public func drawBST(tree: BinarySearchTree<Int>, point: CGPoint, offset: CGFloat) {
        
        // Use temp placeholders for size and color
        let nodeRadius = CGFloat(18)
        let nodeColor = SKColor.white
        let temp = tree
        
        // Traverse left branch, decrement x and increment y positions
        if (temp.hasLeftChild) {
            drawBST(tree: temp.left!,
                    point: CGPoint(x: point.x - 30 - (30*offset), y: point.y - 60),
                    offset: (offset - 1))
        }
        
        // Traverse right branch, increment x and y positions
        if (temp.hasRightChild) {
            drawBST(tree: temp.right!,
                    point: CGPoint(x: point.x + 30 + (30*offset), y: point.y - 60),
                    offset: (offset - 1))
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
