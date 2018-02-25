//
//  GameScene.swift
//  Move
//
//  Created by Bárbara Souza on 21/02/18.
//  Copyright © 2018 Bárbara Souza. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    private var ball: SKSpriteNode!
    let manager : CMMotionManager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        self.ball = self.childNode(withName: "firstNode") as! SKSpriteNode
        self.ball.texture = self.makeRoundedRectangle(color: .magenta, size: self.ball.frame.size, radius: self.ball.frame.size.width/2)
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width/2)
        self.ball.name = "ball"
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        run(SKAction.repeatForever( SKAction.sequence([SKAction.run(addObject), SKAction.wait(forDuration: 0.5)])
        ))
        
        run(SKAction.repeatForever( SKAction.sequence([SKAction.run(addLife), SKAction.wait(forDuration: 1.5)])
        ))
        
        self.startMove()
        self.newRainNode()
    }
    
    func startMove(){
        self.manager.startDeviceMotionUpdates()
        self.manager.deviceMotionUpdateInterval = 0.1
        self.manager.startDeviceMotionUpdates(to: .main){
            (data, error) in
            var moveX : CGFloat = 0.0 , moveY : CGFloat = 0.0
            if (self.ball.position.x+CGFloat((self.manager.deviceMotion?.attitude.roll)!*50) >= -360 && self.ball.position.x+CGFloat((self.manager.deviceMotion?.attitude.roll)!*50) <= 360){
                moveX = CGFloat((self.manager.deviceMotion?.attitude.roll)!*50)
            }
            
            if (self.ball.position.y+CGFloat(-((self.manager.deviceMotion?.attitude.pitch)!)*50) >= -650 && self.ball.position.y+CGFloat(-((self.manager.deviceMotion?.attitude.pitch)!)*50) <= 650){
                moveY = CGFloat(-((self.manager.deviceMotion?.attitude.pitch)!)*50)
            }
            self.ball.run(SKAction.move(to: CGPoint(x: self.ball.position.x+moveX, y: self.ball.position.y+moveY), duration: 0.1))
            
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let action : SKAction = SKAction.move(to: pos, duration: 0.5)
        self.ball.run(action)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func makeRoundedRectangle(color: UIColor, size: CGSize, radius: CGFloat) -> SKTexture{
        UIGraphicsBeginImageContext(size)
        color.setFill()
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path: UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.fill()
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return SKTexture(image: image)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addObject() {
        
        // Create sprite
        let object = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 20, height: 20), cornerRadius: 0.3)
        object.name = "object"
        object.lineWidth = 4.0
        object.fillColor = .green
        object.zPosition = 1
        
        // Determine where to spawn the monster along the X axis
        let actualX = random(min: -360, max: 360)
        
        // Determine where to spawn the monster along the X axis
        let newX = random(min: -360, max: 360)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        object.position = CGPoint(x: actualX + 10, y: -680)
        
        //Physics body of object
        object.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        object.physicsBody?.isDynamic = true
        object.physicsBody?.categoryBitMask = 2
        object.physicsBody?.contactTestBitMask = 1
        object.physicsBody?.collisionBitMask = 0
        object.physicsBody?.usesPreciseCollisionDetection = true
        object.physicsBody?.mass = 0.1
        
        
        // Add the monster to the scene
        addChild(object)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: newX, y: 2*680), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        object.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func addLife(){
        // Create sprite
        let life = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 20, height: 20), cornerRadius: 0.3)
        life.name = "life"
        life.lineWidth = 4.0
        life.fillColor = .red
        life.zPosition = 1
        
        // Determine where to spawn the monster along the X axis
        let actualX = random(min: -360, max: 360)
        
        // Determine where to spawn the monster along the X axis
        let newX = random(min: -360, max: 360)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        life.position = CGPoint(x: actualX + 10, y: -680)
        
        //Physics body of object
        life.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        life.physicsBody?.isDynamic = true
        life.physicsBody?.categoryBitMask = 2
        life.physicsBody?.contactTestBitMask = 1
        life.physicsBody?.collisionBitMask = 0
        life.physicsBody?.usesPreciseCollisionDetection = true
        life.physicsBody?.mass = 0.1
        
        
        // Add the monster to the scene
        addChild(life)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: newX, y: 2*680), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        life.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func ballDidCollideWithObject(){
        if(self.ball.size.width > 40){
            let action: SKAction = SKAction.scale(by: 0.5, duration:0.5)
            self.ball.run(action)
            self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width/2)
        }
    }
    
    func ballDidCollideWithLife(){
        if(self.ball.size.width < 140){
            let action: SKAction = SKAction.scale(by: 2, duration: 0.5)
            self.ball.run(action)
            self.ball.physicsBody = SKPhysicsBody(circleOfRadius: self.ball.size.width/2)
        }
    }
    
    func newRainNode() {
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            return
        }
        
        // Place the emitter at the rear of the ship.
        emitter.position = CGPoint(x: 0, y:600)
        emitter.name = "Rain"
        emitter.alpha = 1
        
        // Send the particles to the scene.
        self.addChild(emitter)
    }


}

extension GameScene : SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ball"  && contact.bodyB.node?.name == "object"){
            self.ballDidCollideWithObject()
            contact.bodyB.node?.removeFromParent()
        }else if (contact.bodyA.node?.name == "ball"  && contact.bodyB.node?.name == "life"){
            self.ballDidCollideWithLife()
            contact.bodyB.node?.removeFromParent()
            
        }
    }
    
}
