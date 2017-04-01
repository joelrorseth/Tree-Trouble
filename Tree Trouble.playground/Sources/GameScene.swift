import SpriteKit
import Social
import GameplayKit

public class GameScene: SKScene {
    
    // Sound properties
    let correctSound = SKAction.playSoundFileNamed("correct.wav", waitForCompletion: false)
    let wrongSound = SKAction.playSoundFileNamed("wrong.wav", waitForCompletion: false)
    let backgroundLoop = SKAudioNode(fileNamed: "loop.wav")
    
    // Properties tracking the incorrect node
    var selectedNode : Node?
    var currentRandomSkewedValue: Int?
    var currentRandomOriginalValue: Int?
    
    // Properties tracking all visible BST sprites
    var currentNodes = [Node]()
    var currentEdges = [SKShapeNode]()
    
    // Properties referencing misc. game nodes
    var background = SKSpriteNode(imageNamed: "background.png")
    var countdownNode = SKLabelNode(fontNamed: "Arial")
    var scoreNode = SKLabelNode(fontNamed: "Arial")
    
    // Variables to track time, score, and update their nodes when changed
    var countdownValue: Int = 60 {
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
        
        // Load first level
        presentNextLevel()
        
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
        
        // Run game sound loop forever
        backgroundLoop.run(SKAction.changeVolume(to: Float(0.9), duration: 0))
        self.addChild(backgroundLoop)
        
        // Create SKAction to decrement the time remaining every second
        let wait = SKAction.wait(forDuration: 1.0)
        let block = SKAction.run({ [unowned self] in
            
            if self.countdownValue > 0 {
                self.countdownValue -= 1
            } else {
                self.gameOver(score: self.score)
            }
        })
        
        let sequence = SKAction.sequence([wait,block])
        run(SKAction.repeatForever(sequence), withKey: "countdown")
    }
    
    // =====================================
    // =====================================
    func createRandomBST(withCount count: Int) {
        
        let nodeCount = Int(NSDecimalNumber(decimal: pow(2, count + 1))) - 1
        
        // Choose position of node that will be randomly skewed
        let randomNodePosition = GKARC4RandomSource().nextInt(upperBound: nodeCount - 1) + 1
        
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
        
        
        // Set skewed value to the value of randomly selected node
        currentRandomOriginalValue = array[randomNodePosition]
        
        // Obtain the tree object for the selected incorrect node
        let nodeToSkew = tree.findNode(value: currentRandomOriginalValue!)
        let parentValue = (nodeToSkew?.parent?.value)!
        
        if (parentValue > currentRandomOriginalValue!) {
            
            // Chosen node it to the left of parent
            // For correctness, we must generate a skewed value greater than the parent
            currentRandomSkewedValue = GKARC4RandomSource().nextInt(upperBound: 99 - parentValue) + (parentValue + 1)
        } else {
            
            // Chosen node is to the right
            // Generate a skewed value that is less than parent to be incorrect
            currentRandomSkewedValue = GKARC4RandomSource().nextInt(upperBound: parentValue - 1) + 1
        }
        
        //print("DEBUG: Generated \(currentRandomSkewedValue!) as next incorrect node")

        
        let topHalfView = CGSize(width: self.size.width, height: self.size.height / 2)
        
        self.drawBST(tree: tree,
                     within: topHalfView,
                     at: CGPoint(x: topHalfView.width / 2, y: self.size.height - 80),
                     offset: CGFloat(tree.height()),
                     originalHeight: tree.height())
    }
    
    // =====================================
    // Balance trees with 2^h - 1 nodes
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
        
        self.currentEdges.append(shape)
        addChild(shape)
    }
    
    // =====================================
    // =====================================
    public func drawNode(at point: CGPoint, value: Int, radius: CGFloat, color: SKColor, dynamic: Bool = false) {
        
        // Create Node and set position in scene
        let sprite = Node()
        sprite.setup(value: value, radius: radius, color: color, dynamic: dynamic)
        sprite.position = point
        
        self.currentNodes.append(sprite)
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
        
        // If this is the randomly selected node, skew its value
        // Otherwise, add node to the tree
        if (tree.value == currentRandomOriginalValue) {
            
            drawNode(at: point, value: currentRandomSkewedValue!, radius: nodeRadius, color: nodeColor)
            
        } else {
            drawNode(at: point, value: temp.value, radius: nodeRadius, color: nodeColor)
        }
    }
    
    
    // MARK: Game Control
    // =====================================
    // =====================================
    private func gameOver(score: Int) {
        
        // Stop the countdown timer and background music
        self.removeAction(forKey: "countdown")
        self.backgroundLoop.removeFromParent()
        
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            vc.add(UIImage(named: "background")!)
            vc.setInitialText("I fixed \(score) Binary Search Trees in 60 seconds in the Tree Trouble Challenge!")
            
            // Extract rootViewController to present the SLComposeViewController (social media posting)
            self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    // =====================================
    // =====================================
    private func checkSelection(value: Int) {
        
        // If correct guess, increment score and load next level
        if (currentRandomSkewedValue == value) {
            score += 1
            playSound(sound: correctSound)
            
            // Correct, so load next level
            presentNextLevel()
            return
        }
        
        // At this point the guess was wrong; the challenge is over!
        playSound(sound: wrongSound)
        gameOver(score: score)
    }
    
    // =====================================
    // =====================================
    private func presentNextLevel() {
        
        // Generate random BST height between 2 and 4
        let randomHeight = GKARC4RandomSource().nextInt(upperBound: 3) + 2
        
        // Remove all node and edge sprites from the scene
        for node in currentNodes { node.removeFromParent() }
        for edge in currentEdges { edge.removeFromParent() }
        
        // Remove all references to nodes and edges from the past round
        currentNodes.removeAll()
        currentEdges.removeAll()
        
        createRandomBST(withCount: randomHeight)
    }
    
    // =====================================
    // =====================================
    func playSound(sound : SKAction) {
        run(sound)
    }
    
    // MARK: Touch Handling
    // =====================================
    // =====================================
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            // Extract touch location and all nodes under this point
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            
            if (touchedNodes.isEmpty) { return }
            
            // Check all nodes under point of contact just in case zPosition varies
            for nodeUnderTouch in touchedNodes {
                
                // If this is a Node, check its value to determine if correct!
                if nodeUnderTouch is Node {
                    selectedNode = (nodeUnderTouch as! Node)
                    checkSelection(value: (selectedNode?.value)!)
                }
            }
        }
    }
}

// ================================================
// Convenience function for adding dictionaries
// ================================================
func += <K, V> ( left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
