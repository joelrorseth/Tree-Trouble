import SpriteKit

public class TreeView: UIViewController {
    
    // A container view for the SKScene
    var gameView: SKView!
    
    // =====================================
    // =====================================
    public override func viewDidLoad() {
        
        let backgroundView = UIImageView(image: UIImage(named: "underlay.jpg"))
        backgroundView.isUserInteractionEnabled = true
        self.view = backgroundView
        
        gameView = SKView()
        gameView.showsFPS = true
        gameView.showsNodeCount = true
        
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.backgroundColor = UIColor.clear
        self.view.addSubview(gameView)
        
        // Create constraints for all edges of the gameview
        let leading = NSLayoutConstraint(item: gameView,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: 30.0)
        
        let trailing = NSLayoutConstraint(item: gameView,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self.view,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: -30.0)
        
        let top = NSLayoutConstraint(item: gameView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self.view,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 80.0)
        
        let bottom = NSLayoutConstraint(item: gameView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: self.view,
                                        attribute: .bottomMargin,
                                        multiplier: 1.0,
                                        constant: -80.0)
        
        let centerHorizontally = NSLayoutConstraint(item: gameView,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .centerX,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        let centerVertically = NSLayoutConstraint(item: gameView,
                                                  attribute: .centerY,
                                                  relatedBy: .equal,
                                                  toItem: self.view,
                                                  attribute: .centerY,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom, centerHorizontally, centerVertically])
    }
    
    // =====================================
    // =====================================
    public override func viewDidAppear(_ animated: Bool) {

        // Scene must be setup after gameView size has been determined
        let scene = TreeScene(size:
            CGSize(
                width: gameView.frame.size.width, height: gameView.frame.size.height
        ))
                
        // Scene will be identical in size to gameView
        scene.scaleMode = .aspectFit
        //scene.backgroundColor = UIColor.clear
                
        self.gameView.presentScene(scene)
    }
}
