import PlaygroundSupport
import SpriteKit

class Node: SKSpriteNode {
    
    func setup(value: Int, radius: CGFloat, color: SKColor, dynamic: Bool = false) {
        
        // Draw a circle
        let circle = SKShapeNode(circleOfRadius: radius) // 18
        circle.strokeColor = SKColor.black
        circle.glowWidth = 1.0
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
        
        self.zPosition = 1.0
        
        // Layer the text and circle node into this NodeSprite
        self.addChild(circle)
        self.addChild(text)
    }
}

