import SpriteKit
import Social

public class GameScene: SKScene {
    
    var movableNode : SKNode?
    var background = SKSpriteNode(imageNamed: "background.png")
    var countdownNode = SKLabelNode(fontNamed: "Arial")
    var scoreNode = SKLabelNode(fontNamed: "Arial")
    var game: Game!
    
    var countdownValue: Int = 30 {
        didSet {
            countdownNode.text = "Time left: \(countdownValue)"
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreNode.text = "Score: \(score)"
        }
    }
    
    // =====================================
    // =====================================
    override public func didMove(to view: SKView) {
        
        // Add background image to scene as a node
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.scale(to: self.size)
        addChild(background)
        
        // Add score label to the scene
        scoreNode.fontColor = SKColor.white
        scoreNode.fontSize = 20
        scoreNode.position = CGPoint(x: (self.scene?.size.width)! - 70, y: 20)
        scoreNode.text = "Score: \(score)"
        addChild(scoreNode)
        
        // Add countdown timer to the scene
        countdownNode.fontColor = SKColor.white
        countdownNode.fontSize = 20
        countdownNode.position = CGPoint(x: 70, y: 20)
        countdownNode.text = "Time left: \(countdownValue)"
        addChild(countdownNode)
        
        let wait = SKAction.wait(forDuration: 1.0)
        let block = SKAction.run({ [unowned self] in
            
            if self.countdownValue > 0 {
                self.countdownValue -= 1
            } else {
                self.gameOver(score: self.score)
                self.score = 0
                self.removeAction(forKey: "countdown")
            }
        })
        
        let sequence = SKAction.sequence([wait,block])
        run(SKAction.repeatForever(sequence), withKey: "countdown")
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
        
        // Create a new Game
        game = Game(heights: [1,1,2,2,2,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4])
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.81)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.backgroundColor = SKColor.white
        
        createRandomBST(withCount: 3)
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
        let tree = BinarySearchTree(value: array[0])
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
    
    // =====================================
    // =====================================
    private func gameOver(score: Int) {
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            vc.setInitialText("I fixed \(score) Binary Search Trees in 30 seconds in the Trouble in the Trees Challenge!")
            vc.add(UIImage(named: "background")!)
            self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
        }
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

