//
//  MainGame.swift
//  appGame
//
//  Created by 侯彤 on 2020/12/19.
//

import Foundation
import SpriteKit
class ZombiesGenerator//僵尸产生器抽象类，通过继承该类来实现不同的关卡
{
    var begindate:Date
    init(date: Date)
    {
        self.begindate=date
    }
    func Execute(Scene:GameScene)
    {
        
    }
    func AddNormalZombie(row: Int,Scene:GameScene)
    {
        let zombienode : SKSpriteNode = SKSpriteNode.init(imageNamed: "普通僵尸.png")
        let zombie : NormalZombie=NormalZombie.init(Row: row, Distance: 0, date: Date(), Speed: 20, Zombienode: zombienode)
        Scene.allZombies?.append(zombie)
        zombie.move(alllines:&Scene.fivelines)
        Scene.addChild(zombienode)
        Scene.fivelines?.lines[row].zombiesline.zombies.append(zombie)
    }
    func AddConeHeadZombie(row: Int,Scene:GameScene)
    {
        let zombienode : SKSpriteNode = SKSpriteNode.init(imageNamed: "路障僵尸1.png")
        let zombie : ConeHeadZombie=ConeHeadZombie.init(Row: row, Distance: 0, date: Date(), Speed: 20, Zombienode: zombienode)
        Scene.allZombies?.append(zombie)
        zombie.move(alllines:&Scene.fivelines)
        Scene.addChild(zombienode)
        Scene.fivelines?.lines[row].zombiesline.zombies.append(zombie)
    }
    func AddBucketZombie(row: Int,Scene:GameScene)
    {
        let zombienode : SKSpriteNode = SKSpriteNode.init(imageNamed: "铁桶僵尸1.png")
        let zombie : BucketZombie=BucketZombie.init(Row: row, Distance: 0, date: Date(), Speed: 20, Zombienode: zombienode)
        Scene.allZombies?.append(zombie)
        zombie.move(alllines:&Scene.fivelines)
        Scene.addChild(zombienode)
        Scene.fivelines?.lines[row].zombiesline.zombies.append(zombie)
    }
}
class First_ZombiesGenerator: ZombiesGenerator//这里我只实现一个关卡了，再实现几个也是类似的(当然，分为三个难度)
{
    override func Execute(Scene:GameScene)
    {
        if(Scene.ZombiesToGenerate! > 0)
        {
            let timeNow = Date()
            let components = NSCalendar.current.dateComponents([.second], from: begindate, to: timeNow)
            if(components.second! > 0 && components.second! <= 17)
            {
                if(components.second!%8 == 0)
                {
                    let linenum=Int(arc4random()%5)
                    AddNormalZombie(row: linenum, Scene: Scene)
                    Scene.ZombiesToGenerate! -= 1
                }
            }
            else if(components.second! > 17 && components.second! <= 60)
            {
                if(components.second!%6 == 0)
                {
                    let linenum=Int(arc4random()%5)
                    let i=arc4random()%2
                    if(i == 0)
                    {
                        AddNormalZombie(row: linenum, Scene: Scene)
                    }
                    else if(i == 1)
                    {
                        AddConeHeadZombie(row: linenum, Scene: Scene)
                    }
                    Scene.ZombiesToGenerate! -= 1
                }
            }
            else if(components.second! > 60 && components.second! <= 90)
            {
                if(components.second!%4 == 0)
                {
                    let linenum=Int(arc4random()%5)
                    let i=arc4random()%3
                    if(i == 0)
                    {
                        AddNormalZombie(row: linenum, Scene: Scene)
                    }
                    else if(i == 1)
                    {
                        AddConeHeadZombie(row: linenum, Scene: Scene)
                    }
                    else
                    {
                        AddBucketZombie(row: linenum, Scene: Scene)
                    }
                    Scene.ZombiesToGenerate! -= 1
                }
            }
            else if(components.second! > 90)
            {
                if(components.second!%2 == 0)
                {
                    let linenum=Int(arc4random()%5)
                    let i=arc4random()%2
                    if(i == 0)
                    {
                        AddConeHeadZombie(row: linenum, Scene: Scene)
                    }
                    else if(i == 1)
                    {
                        AddBucketZombie(row: linenum, Scene: Scene)
                    }
                    Scene.ZombiesToGenerate! -= 1
                }
            }
        }
    }
}
//例如可以通过如下的继承方式多实现几个关卡
class Second_ZombiesGenerator: ZombiesGenerator
{
    override func Execute(Scene:GameScene)
    {
        
    }
}
class Third_ZombiesGenerator: ZombiesGenerator
{
    override func Execute(Scene:GameScene)
    {
        
    }
}
