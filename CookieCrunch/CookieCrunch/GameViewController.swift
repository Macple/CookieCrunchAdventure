import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var level: Level!
    var scene: GameScene!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Create the level
        level = Level(filename: "Levels/Level_3")
        scene.level = level
        scene.swipeHandler = handleSwipe
        
        // Add tiles behind the cookies
        scene.addTiles()
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newCookies = level.shuffle()
        scene.addSprites(for: newCookies)
    }
    
    func handleSwipe(_ swap: Swap) {
        view.isUserInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animate(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
            self.view.isUserInteractionEnabled = true
        }}
    }
    
    func handleMatches() {
        let chains = level.removeMatches()
        scene.animateMatchedCookies(for: chains) {
            let columns = self.level.fillHoles()
            self.scene.animateFallingCookies(columns: columns) {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}
