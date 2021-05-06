//
//  ZombieFamily.swift
//  appGame
//
//  Created by 侯彤 on 2020/12/7.
//

import Foundation
import SpriteKit
class ZombiesFamily
{
    static let Zombies:[String]=["普通僵尸","路障僵尸","铁桶僵尸"]
}
class ZombiesLine
{
    public var zombies:Array<Zombie?>=[Zombie]()
}
class Zombie
{
    fileprivate var row :Int
    fileprivate var xDistance:Int
    var SlowDate:Date
    var EatDate:Date
    var speed:Double
    var zombienode:SKSpriteNode?
    var lifeValue:Int = 10
    var isSlowed:Bool! = false
    var slowtime:Int = 0
    init(Row:Int , Distance:Int,date:Date,Speed:Double,Zombienode:SKSpriteNode)
    {
        self.xDistance=Distance
        self.row=Row
        self.SlowDate=date
        self.EatDate=date
        self.speed=Speed
        self.zombienode=Zombienode
        self.zombienode!.position.x=640
        self.zombienode!.position.y=CGFloat(185-92*row)
        if(row == 0)
        {
            self.zombienode!.zPosition = CGFloat(Z0)
            Z0 += 1
        }
        else if(row == 1)
        {
            self.zombienode!.zPosition = CGFloat(Z1)
            Z1 += 1
        }
        else if(row == 2)
        {
            self.zombienode!.zPosition = CGFloat(Z2)
            Z2 += 1
        }
        else if(row == 3)
        {
            self.zombienode!.zPosition = CGFloat(Z3)
            Z3 += 1
        }
        else if(row == 4)
        {
            self.zombienode!.zPosition = CGFloat(Z4)
            Z4 += 1
        }
    }
    func move( alllines:inout AllLines?)
    {
        //print(String(self.row)+"  "+String(self.lifeValue))
        ExamineHealth()
        ExamineToChangeTexture()
        if(zombienode != nil)
        {
            if(slowtime > 0)
            {
                let timeNow = Date()
                let components = NSCalendar.current.dateComponents([.second], from: SlowDate, to: timeNow)
                if(components.second == slowtime)
                {
                    speed *= 2
                    slowtime = 0
                    SlowDate = Date()
                    self.isSlowed = false
                }
            }
            let len=(alllines?.lines[row].plantsline.plants.count)!
            var isStopped:Bool = false
            if(len>0)
            {
                for i in 0..<len
                {
                    if(alllines?.lines[row].plantsline.plants[i] != nil && alllines?.lines[row].plantsline.plants[i]!.plantnode!.frame.contains((zombienode?.position)!) == true)
                    {
                        zombienode!.removeAllActions()
                        let timeNow = Date()
                        let components = NSCalendar.current.dateComponents([.second], from: EatDate, to: timeNow)
                        if(components.second! != 0 && components.second!%1 == 0)
                        {
                            EatDate=timeNow
                            alllines?.lines[row].plantsline.plants[i]!.lifeValue -= 1
                        }
                        isStopped = true
                        break
                    }
                }
            }
            if(isStopped == false)
            {
                let position = zombienode!.position.x
                let y = zombienode!.position.y
                if(position > -340)
                {
                    zombienode!.run(SKAction.move(to: CGPoint.init(x: -340, y: y), duration: Double(position+340)/speed))
                }
                else
                {
                    zombienode!.removeAllActions()
                    zombienode!.removeFromParent()
                    zombienode = nil
                }
            }
        }
    }
    func ExamineToChangeTexture()
    {
        
    }
    func ExamineHealth()
    {
        if(self.lifeValue <= 0 && zombienode != nil)
        {
            RemainingZombies -= 1
            zombienode!.removeAllActions()
            zombienode!.removeFromParent()
            zombienode = nil
        }
    }
}
class NormalZombie:Zombie//普通僵尸
{
    override init(Row: Int, Distance: Int, date: Date, Speed: Double, Zombienode: SKSpriteNode)
    {
        super.init(Row: Row, Distance: Distance, date: date, Speed: Speed, Zombienode: Zombienode)
        self.lifeValue=10
    }
}
class ConeHeadZombie: Zombie//路障僵尸
{
    override init(Row: Int, Distance: Int, date: Date, Speed: Double, Zombienode: SKSpriteNode)
    {
        super.init(Row: Row, Distance: Distance, date: date, Speed: Speed, Zombienode: Zombienode)
        self.zombienode!.position.y=CGFloat(195-92*row)
        self.lifeValue=30
    }
    override func ExamineToChangeTexture()
    {
        if(self.lifeValue <= 24 && self.lifeValue >= 19)
        {
            self.zombienode?.texture = SKTexture.init(imageNamed: "路障僵尸2.png")
        }
        else if(self.lifeValue < 19 && self.lifeValue >= 11)
        {
            self.zombienode?.texture = SKTexture.init(imageNamed: "路障僵尸3.png")
        }
        else if(self.lifeValue > 0 && self.lifeValue <= 10 && self.zombienode?.size != CGSize(width: 79, height: 115))
        {
            let position = zombienode!.position.x
            let y = zombienode!.position.y
            zombienode?.removeAllActions()
            self.zombienode?.texture = SKTexture.init(imageNamed: "普通僵尸.png")
            self.zombienode?.size = CGSize(width: 79, height: 115)
            self.zombienode!.position.y=CGFloat(185-92*row)
            zombienode!.run(SKAction.move(to: CGPoint.init(x: -340, y: y), duration: Double(position+340)/speed))
        }
    }
}
class BucketZombie: Zombie//铁桶僵尸
{
    override init(Row: Int, Distance: Int, date: Date, Speed: Double, Zombienode: SKSpriteNode)
    {
        super.init(Row: Row, Distance: Distance, date: date, Speed: Speed, Zombienode: Zombienode)
        self.zombienode!.position.y=CGFloat(200-92*row)
        self.lifeValue=60
    }
    override func ExamineToChangeTexture()
    {
        if(self.lifeValue <= 46 && self.lifeValue >= 29)
        {
            self.zombienode?.texture = SKTexture.init(imageNamed: "铁桶僵尸2.png")
        }
        else if(self.lifeValue < 29 && self.lifeValue >= 11)
        {
            
            self.zombienode?.texture = SKTexture.init(imageNamed: "铁桶僵尸3.png")
        }
        else if(self.lifeValue > 0 && self.lifeValue <= 10 && self.zombienode?.size != CGSize(width: 79, height: 115))
        {
            let position = zombienode!.position.x
            let y = zombienode!.position.y
            zombienode?.removeAllActions()
            self.zombienode?.texture = SKTexture.init(imageNamed: "普通僵尸.png")
            self.zombienode?.size = CGSize(width: 79, height: 115)
            self.zombienode!.position.y=CGFloat(185-92*row)
            zombienode!.run(SKAction.move(to: CGPoint.init(x: -340, y: y), duration: Double(position+340)/speed))
        }
    }
}
