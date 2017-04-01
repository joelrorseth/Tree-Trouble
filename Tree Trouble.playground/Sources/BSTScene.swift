import SpriteKit

public class BSTScene: SKScene {
    
    var background = SKSpriteNode(imageNamed: "background.png")
    var nodePoints: [CGPoint] = []
    
    // =====================================
    // =====================================
    override public func didMove(to view: SKView) {
        
        // Add background image to scene as a node
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.scale(to: self.size)
        addChild(background)
    }
    
    // =====================================
    // =====================================
    func createTree(tree: BinarySearchTree) {
 
        drawBST(tree: tree,
                within: CGSize(width: self.size.width,
                               height: self.size.height),
                at: CGPoint(x: self.size.width / 2, y: self.size.height - 80),
                offset: CGFloat(tree.height()),
                originalHeight: tree.height())
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
    public func drawBST(tree: BinarySearchTree, within size: CGSize, at point: CGPoint, offset: CGFloat, originalHeight: Int) {

        
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
            self.drawEdge(from: point, to: newPoint, width: 2)
            
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
            self.drawEdge(from: point, to: newPoint, width: 2)
            
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
