//
//  PlantsFamily.swift
//  appGame
//
//  Created by 侯彤 on 2020/12/7.
//


import Foundation
import SpriteKit
class PlantsFamily
{
    static let Plants:[String]=["向日葵","豌豆射手","寒冰射手","坚果","土豆雷","双发射手"]
}
class CardCost
{
    static let Plants:[Int]=[50,100,150,50,25,200]
}
class CardImg
{
    static let Plants:[String]=["向日葵卡.png","豌豆射手卡.png","寒冰射手卡.png","坚果卡.png","土豆地雷卡.png","双发射手卡.png"]
}
class PlantsImg
{
    static let Plants:[String]=["向日葵.png","豌豆射手.png","寒冰射手.png","坚果.png","土豆地雷1.png","双发射手.png"]
}
class PlantsLine
{
    public var plants:Array<Plant?>=[Plant]()
}
class Plant
{
    var row :Int
    var column:Int
    fileprivate var date:Date
    var plantnode : SKSpriteNode?
    var lifeValue:Int = 4
    init(Row:Int , Column:Int,date:Date,Plantnode:SKSpriteNode)
    {
        self.column=Column
        self.row=Row
        self.date=date
        self.plantnode=Plantnode
    }
    func execute(alllines: AllLines?,Scene:GameScene)
    {
        ExamineHealth()
        DoSelfTask(alllines: alllines,Scene:Scene)
    }
    func ExamineHealth()
    {
        if(self.lifeValue <= 0 && plantnode != nil)
        {
            plantnode!.texture = SKTexture.init(imageNamed: "草地块.png")
            plantnode = nil
        }
    }
    func DoSelfTask(alllines: AllLines?,Scene:GameScene)
    {
        
    }
}
class Pea : Plant //这里让豌豆也继承自植物类
{
    var speed : Double
    override init(Row: Int, Column: Int, date: Date, Plantnode: SKSpriteNode)
    {
        speed = 240
        super.init(Row: Row, Column: Column, date: date, Plantnode: Plantnode)
    }
    override func DoSelfTask(alllines: AllLines?,Scene:GameScene)
    {
        if(plantnode != nil)
        {
            let len=(alllines?.lines[row].zombiesline.zombies.count)!
            if(len>0)
            {
                for i in 0..<len
                {
                    if let zombienode=alllines?.lines[row].zombiesline.zombies[i]!.zombienode
                    {
                        if(zombienode.frame.contains(plantnode!.position) == true)
                        {
                            alllines?.lines[row].zombiesline.zombies[i]!.lifeValue -= 1
                            plantnode?.removeAllActions()
                            plantnode?.removeFromParent()
                            plantnode = nil
                            return
                        }
                    }
                }
            }
            let position = plantnode!.position.x
            if(position < 640)
            {
                plantnode!.run(SKAction.move(to: CGPoint.init(x: 640, y: 170-92*row+10), duration: Double(640-position)/speed))
            }
            else
            {
                plantnode!.removeAllActions()
                plantnode!.removeFromParent()
                plantnode = nil
            }
        }
    }
}
class IcePea : Plant
{
    var speed : Double
    override init(Row: Int, Column: Int, date: Date, Plantnode: SKSpriteNode)
    {
        speed = 240
        super.init(Row: Row, Column: Column, date: date, Plantnode: Plantnode)
    }
    override func DoSelfTask(alllines: AllLines?,Scene:GameScene)
    {
        if(plantnode != nil)
        {
            let len=(alllines?.lines[row].zombiesline.zombies.count)!
            if(len>0)
            {
                for i in 0..<len
                {
                    if let zombienode=alllines?.lines[row].zombiesline.zombies[i]!.zombienode
                    {
                        if(zombienode.frame.contains(plantnode!.position) == true)
                        {
                            alllines?.lines[row].zombiesline.zombies[i]!.SlowDate = Date()
                            alllines?.lines[row].zombiesline.zombies[i]!.slowtime = 8
                            if(alllines?.lines[row].zombiesline.zombies[i]!.isSlowed == false)
                            {
                                alllines?.lines[row].zombiesline.zombies[i]!.isSlowed = true
                                alllines?.lines[row].zombiesline.zombies[i]!.speed /= 2
                            }
                            alllines?.lines[row].zombiesline.zombies[i]!.lifeValue -= 1
                            plantnode?.removeAllActions()
                            plantnode?.removeFromParent()
                            plantnode = nil
                            return
                        }
                    }
                }
            }
            let position = plantnode!.position.x
            if(position < 640)
            {
                plantnode!.run(SKAction.move(to: CGPoint.init(x: 640, y: 170-92*row+10), duration: Double(640-position)/speed))
            }
            else
            {
                plantnode!.removeAllActions()
                plantnode!.removeFromParent()
                plantnode = nil
            }
        }
    }
}
class SunShape
{
    var speed : Double = 20
    var SunNode : SKSpriteNode?
    init(sunnode: SKSpriteNode)
    {
        SunNode = sunnode
    }
    func GenerateSunShape(Scene:GameScene)
    {
        Scene.addChild(SunNode!)
        SunNode?.run(SKAction.moveBy(x: 0, y: -50, duration: 50/speed))
        Scene.SunShapes?.append(SunNode)
    }
}
class SunFlower : Plant
{
    override func DoSelfTask(alllines: AllLines?,Scene:GameScene)
    {
        if(plantnode != nil)
        {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "ss"
            let timeNow = Date()
            let strpastTime = timeFormatter.string(from: date) as String
            let strNowTime = timeFormatter.string(from: timeNow) as String
            if(strpastTime != strNowTime)
            {
                let components = NSCalendar.current.dateComponents([.second], from: date, to: timeNow)
                if(components.second! != 0 && components.second!%10 == 0)
                {
                    let sunnode = SKSpriteNode.init(imageNamed: "阳光.png")
                    sunnode.position.x=(plantnode?.position.x)!+10
                    sunnode.position.y=(plantnode?.position.y)!+20
                    let sunshape = SunShape(sunnode: sunnode)
                    sunshape.GenerateSunShape(Scene: Scene)
                    date=timeNow
                    //TotalOfSun+=25
                }
            }
        }
    }
}
class PeaShooter: Plant
{
    override func DoSelfTask(alllines: AllLines?,Scene:GameScene)
    {
        if(plantnode != nil)
        {
            let timeNow = Date()
            let components = NSCalendar.current.dateComponents([.second], from: date, to: timeNow)
            if(components.second! != 0 && components.second!%1 == 0)
            {
                date=timeNow
                let len=(alllines?.lines[row].zombiesline.zombies.count)!
                if(len>0)
                {
                    for i in 0..<len
                    {
                        if let zombienode=alllines?.lines[row].zombiesline.zombies[i]!.zombienode
                        {
                            if(zombienode.position.x >= (plantnode?.position.x)!)
                            {
                                let peanode = SKSpriteNode.init(imageNamed: "豌豆.png")
                                peanode.position.x=plantnode!.position.x
                                peanode.position.y=plantnode!.position.y+10
                                Scene.addChild(peanode)
                                let pea = Pea.init(Row: row, Column: column, date: date, Plantnode: peanode)
                                Scene.AllPeas?.append(pea)
                                //alllines?.lines[row].zombiesline.zombies[i]!.lifeValue -= 1
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
class DoubleShooter: Plant
{
    var isSecond : Bool
    override init(Row: Int, Column: Int, date: Date, Plantnode: SKSpriteNode)
    {
        isSecond = false
        super.init(Row: Row, Column: Column, date: date, Plantnode: Plantnode)
    }
    override func DoSelfTask(alllines: AllLines?,Scene:GameScene)
    {
        if(plantnode != nil)
        {
            let timeNow = Date()
            let components = NSCalendar.current.dateComponents([.second], from: date, to: timeNow)
            let component2 = NSCalendar.current.dateComponents([.nanosecond], from: date, to: timeNow)
            //print(component2.nanosecond as Any)
            if(isSecond == true)
            {
                if(Decimal(component2.nanosecond!) >= 2*pow(10, 8))
                {
                    let peanode = SKSpriteNode.init(imageNamed: "豌豆.png")
                    peanode.position.x=plantnode!.position.x
                    peanode.position.y=plantnode!.position.y+10
                    Scene.addChild(peanode)
                    let pea = Pea.init(Row: row, Column: column, date: date, Plantnode: peanode)
                    Scene.AllPeas?.append(pea)
                    isSecond = false
                }
            }
            if(components.second! != 0 && components.second!%1 == 0)
            {
                date=timeNow
                let len=(alllines?.lines[row].zombiesline.zombies.count)!
                if(len>0)
                {
                    for i in 0..<len
                    {
                        if let zombienode=alllines?.lines[row].zombiesline.zombies[i]!.zombienode
                        {
                            if(zombienode.position.x >= (plantnode?.position.x)!)
                            {
                                let peanode = SKSpriteNode.init(imageNamed: "豌豆.png")
                                peanode.position.x=plantnode!.position.x
                                peanode.position.y=plantnode!.position.y+10
                                Scene.addChild(peanode)
                                let pea = Pea.init(Row: row, Column: column, date: date, Plantnode: peanode)
                                Scene.AllPeas?.append(pea)
                                isSecond = true
                                //alllines?.lines[row].zombiesline.zombies[i]!.lifeValue -= 2
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
class PotatoMine: Plant
{
    var isReady : Bool = false
    override func DoSelfTask(alllines: AllLines?,Scene:GameScene)
    {
        if(plantnode != nil)
        {
            if(isReady == false)
            {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "ss"
                let timeNow = Date()
                let strpastTime = timeFormatter.string(from: date) as String
                let strNowTime = timeFormatter.string(from: timeNow) as String
                if(strpastTime != strNowTime)
                {
                    let components = NSCalendar.current.dateComponents([.second], from: date, to: timeNow)
                    if(components.second! != 0 && components.second!%10 == 0)
                    {
                        date=timeNow
                        isReady = true
                        plantnode!.texture = SKTexture.init(imageNamed: "土豆地雷2.png")
                    }
                }
            }
            else
            {
                var isBoom = false
                let len=(alllines?.lines[row].zombiesline.zombies.count)!
                if(len>0)
                {
                    for i in 0..<len
                    {
                        if let zombienode=alllines?.lines[row].zombiesline.zombies[i]!.zombienode
                        {
                            if(self.plantnode!.frame.contains(zombienode.position))
                            {
                                alllines?.lines[row].zombiesline.zombies[i]!.lifeValue = 0
                                alllines?.lines[row].zombiesline.zombies[i]!.zombienode!.removeAllActions()
                                isBoom = true
                            }
                        }
                    }
                    if(isBoom)
                    {
                        plantnode!.texture = SKTexture.init(imageNamed: "草地块.png")
                        plantnode = nil
                    }
                }
            }
        }
    }
}
class Nut: Plant
{
    override init(Row: Int, Column: Int, date: Date, Plantnode: SKSpriteNode)
    {
        super.init(Row: Row, Column: Column, date: date, Plantnode: Plantnode)
        self.lifeValue = 50
    }
}
class IceShooter: Plant
{
    override func DoSelfTask(alllines: AllLines?,Scene:GameScene)
    {
        if(plantnode != nil)
        {
            let timeNow = Date()
            let components = NSCalendar.current.dateComponents([.second], from: date, to: timeNow)
            if(components.second! != 0 && components.second!%1 == 0)
            {
                date=timeNow
                let len=(alllines?.lines[row].zombiesline.zombies.count)!
                if(len>0)
                {
                    for i in 0..<len
                    {
                        if let zombienode=alllines?.lines[row].zombiesline.zombies[i]!.zombienode
                        {
                            if(zombienode.position.x >= (plantnode?.position.x)!)
                            {
                                let peanode = SKSpriteNode.init(imageNamed: "寒冰豌豆.png")
                                peanode.position.x=plantnode!.position.x
                                peanode.position.y=plantnode!.position.y+10
                                Scene.addChild(peanode)
                                let pea = IcePea.init(Row: row, Column: column, date: date, Plantnode: peanode)
                                Scene.AllPeas?.append(pea)
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
