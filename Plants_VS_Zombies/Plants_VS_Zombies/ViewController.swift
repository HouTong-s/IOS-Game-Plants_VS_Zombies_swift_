//
//  ViewController.swift
//  appGame
//
//  Created by 侯彤 on 2020/12/7.
//

import UIKit
import SpriteKit
class ViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "GameFinished")
        {
            gameScene.removeAllActions()
            gameScene.removeAllChildren()
            gameScene.removeFromParent()
            gameScene = nil
            if let view = self.view as! SKView?
            {
                view.presentScene(nil)
            }
        }
        if(segue.identifier == "Victory")
        {
            gameScene.removeAllActions()
            gameScene.removeAllChildren()
            gameScene.removeFromParent()
            gameScene = nil
            if let view = self.view as! SKView?
            {
                view.presentScene(nil)
            }
        }
        if(segue.identifier == "Resume")
        {
            gameScene.removeAllActions()
            gameScene.removeAllChildren()
            gameScene.removeFromParent()
            gameScene = nil
            if let view = self.view as! SKView?
            {
                view.presentScene(nil)
            }
        }
    }
    var gameScene:GameScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                gameScene = (scene as! GameScene)
                gameScene.viewController = self
                gameScene.zombiesgenerator = First_ZombiesGenerator.init(date: Date())
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        // Do any additional setup after loading the view.
        }
    }
}
class FailViewController: UIViewController
{
    @IBAction func Resume(_ sender: Any)
    {
        performSegue(withIdentifier: "Resume", sender: nil)
    }
}
class VictoryController: UIViewController
{
    @IBAction func Resume(_ sender: Any)
    {
        performSegue(withIdentifier: "Resume", sender: nil)
    }
}
class MenuController: UIViewController
{
    @IBAction func Start(_ sender: Any)
    {
        performSegue(withIdentifier: "Start", sender: nil)
    }
}
class ChooseDifficultyController:UIViewController
{
    @IBAction func Simply(_ sender: Any)
    {
        RemainingZombies = 20
        performSegue(withIdentifier: "ChooseDifficulty", sender: nil)
    }
    @IBAction func Medium(_ sender: Any)
    {
        RemainingZombies = 40
        performSegue(withIdentifier: "ChooseDifficulty", sender: nil)
    }
    @IBAction func Difficult(_ sender: Any)
    {
        RemainingZombies = 80
        performSegue(withIdentifier: "ChooseDifficulty", sender: nil)
    }
}
