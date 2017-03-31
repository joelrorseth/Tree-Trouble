import PlaygroundSupport
import SpriteKit

class Node: SKSpriteNode {
    
    public var value: Int!
    
    func setup(value: Int, radius: CGFloat, color: SKColor, dynamic: Bool = false) {
        
        self.value = value
        
        // Draw a circle
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.strokeColor = SKColor.black
        circle.lineWidth = 1.0
        circle.fillColor = color
        
        // Establish the text (number value) of the Node
        let text = SKLabelNode(text: String(value))
        text.position = circle.position
        text.horizontalAlignmentMode = .center
        text.verticalAlignmentMode = .center
        text.fontColor = SKColor.black
        text.fontName = "Arial"
        text.fontSize = CGFloat(radius)
        
        // Establish the physicsBody to determine how it reacts to gravity
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody!.allowsRotation = true
        self.physicsBody!.friction = 0
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.restitution = 0.7
        self.physicsBody!.affectedByGravity = dynamic
        
        self.zPosition = 5
        
        // Layer the text and circle node into this NodeSprite
        self.addChild(circle)
        self.addChild(text)
    }
}

