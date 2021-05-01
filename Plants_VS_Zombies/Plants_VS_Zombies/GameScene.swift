//
//  GameScene.swift
//  game1
//
//  Created by 侯彤 on 2020/12/1.
//
//if(!(self.label?.frame.contains(pos))!) 点击位置是否在label内，用于判断SKnode的框是否包含某个CGPoint
import SpriteKit
import Foundation
import AVFoundation
var TotalOfSun:Int = 0
var RemainingZombies:Int = 10
var Z0:Int = 1
var Z1:Int = 101
var Z2:Int = 201
var Z3:Int = 301
var Z4:Int = 401
class GameScene: SKScene, AVAudioPlayerDelegate
{
    var viewController : ViewController?
    private var plantsboard : PlantsBoard?
    private var AllCards : Array<SKSpriteNode?>?//意图用一个一维数组来管理所有的卡片
    private var AllPieces : Array<Array<SKSpriteNode?>>?//意图用一个二维数组来管理每一块绿地，是一个方格状结构
    var SunShapes : Array<SKSpriteNode?>?
    var AllPeas : Array<Plant?>?
    private let Rows : Int = 5
    private let Columns : Int = 9
    private var PaueseBt: SKSpriteNode?
    private var ResumeBt: SKLabelNode?
    private var Remaining: SKLabelNode?
    private var shovel : SKSpriteNode?
    private var SunNum : SKLabelNode?
    private var Whichplant : Int? = -1
    private var begintime : Date?
    private var pasttime : Date?
    private var VictoryTime : Date?
    private var player:AVAudioPlayer?
    var zombiesgenerator:First_ZombiesGenerator?
    var ZombiesToGenerate:Int?
    var fivelines : AllLines?//以五条线的每条线为单位，分别管理其对应的僵尸和植物序列，便于分别处理
    var IsVictory:Bool?
    private var allPlants : Array<Plant>?//所有植物组成的集合
    var allZombies : Array<Zombie>?//所有僵尸组成的集合
    //上述两个集合是为了能够只遍历已存在的僵尸和植物，并使它们分别执行任务
    override func didMove(to view: SKView) {
        //zombiesgenerator = First_ZombiesGenerator.init(date: begintime!)
        Z0 = 1
        Z1 = 101
        Z2 = 201
        Z3 = 301
        Z4 = 401
        IsVictory = false
        do
        {
            let bundlePath = Bundle.main.path(forResource: "BackGroundMusic", ofType: "mp3")
            player = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: bundlePath!))
            player!.prepareToPlay()
            player!.play()
            //播放背景音乐
        }
        catch
        {
            
        }
        ZombiesToGenerate = RemainingZombies
        TotalOfSun = 300
        AllPeas=[Plant?]()
        SunShapes=[SKSpriteNode?]()
        allPlants=[Plant]()
        allZombies = [Zombie]()
        fivelines = AllLines(5)
        plantsboard = PlantsBoard()
        begintime = Date()
        pasttime = begintime
        VictoryTime = begintime
        AllCards=[SKSpriteNode?]()
        AllCards?.append(self.childNode(withName: "//Sunflower") as? SKSpriteNode)
        AllCards?.append(self.childNode(withName: "//PeaShooter") as? SKSpriteNode)
        AllCards?.append(self.childNode(withName: "//IceShooter") as? SKSpriteNode)
        AllCards?.append(self.childNode(withName: "//Nut") as? SKSpriteNode)
        AllCards?.append(self.childNode(withName: "//PotatoMine") as? SKSpriteNode)
        AllCards?.append(self.childNode(withName: "//DoubleShooter") as? SKSpriteNode)
        AllPieces=Array(repeating: Array(repeating: nil, count: Columns), count: Rows)//初始化每块绿地
        AllPieces![0][0] = self.childNode(withName: "//00") as? SKSpriteNode
        AllPieces![0][1] = self.childNode(withName: "//01") as? SKSpriteNode
        AllPieces![0][2] = self.childNode(withName: "//02") as? SKSpriteNode
        AllPieces![0][3] = self.childNode(withName: "//03") as? SKSpriteNode
        AllPieces![0][4] = self.childNode(withName: "//04") as? SKSpriteNode
        AllPieces![0][5] = self.childNode(withName: "//05") as? SKSpriteNode
        AllPieces![0][6] = self.childNode(withName: "//06") as? SKSpriteNode
        AllPieces![0][7] = self.childNode(withName: "//07") as? SKSpriteNode
        AllPieces![0][8] = self.childNode(withName: "//08") as? SKSpriteNode
        AllPieces![1][0] = self.childNode(withName: "//10") as? SKSpriteNode
        AllPieces![1][1] = self.childNode(withName: "//11") as? SKSpriteNode
        AllPieces![1][2] = self.childNode(withName: "//12") as? SKSpriteNode
        AllPieces![1][3] = self.childNode(withName: "//13") as? SKSpriteNode
        AllPieces![1][4] = self.childNode(withName: "//14") as? SKSpriteNode
        AllPieces![1][5] = self.childNode(withName: "//15") as? SKSpriteNode
        AllPieces![1][6] = self.childNode(withName: "//16") as? SKSpriteNode
        AllPieces![1][7] = self.childNode(withName: "//17") as? SKSpriteNode
        AllPieces![1][8] = self.childNode(withName: "//18") as? SKSpriteNode
        AllPieces![2][0] = self.childNode(withName: "//20") as? SKSpriteNode
        AllPieces![2][1] = self.childNode(withName: "//21") as? SKSpriteNode
        AllPieces![2][2] = self.childNode(withName: "//22") as? SKSpriteNode
        AllPieces![2][3] = self.childNode(withName: "//23") as? SKSpriteNode
        AllPieces![2][4] = self.childNode(withName: "//24") as? SKSpriteNode
        AllPieces![2][5] = self.childNode(withName: "//25") as? SKSpriteNode
        AllPieces![2][6] = self.childNode(withName: "//26") as? SKSpriteNode
        AllPieces![2][7] = self.childNode(withName: "//27") as? SKSpriteNode
        AllPieces![2][8] = self.childNode(withName: "//28") as? SKSpriteNode
        AllPieces![3][0] = self.childNode(withName: "//30") as? SKSpriteNode
        AllPieces![3][1] = self.childNode(withName: "//31") as? SKSpriteNode
        AllPieces![3][2] = self.childNode(withName: "//32") as? SKSpriteNode
        AllPieces![3][3] = self.childNode(withName: "//33") as? SKSpriteNode
        AllPieces![3][4] = self.childNode(withName: "//34") as? SKSpriteNode
        AllPieces![3][5] = self.childNode(withName: "//35") as? SKSpriteNode
        AllPieces![3][6] = self.childNode(withName: "//36") as? SKSpriteNode
        AllPieces![3][7] = self.childNode(withName: "//37") as? SKSpriteNode
        AllPieces![3][8] = self.childNode(withName: "//38") as? SKSpriteNode
        AllPieces![4][0] = self.childNode(withName: "//40") as? SKSpriteNode
        AllPieces![4][1] = self.childNode(withName: "//41") as? SKSpriteNode
        AllPieces![4][2] = self.childNode(withName: "//42") as? SKSpriteNode
        AllPieces![4][3] = self.childNode(withName: "//43") as? SKSpriteNode
        AllPieces![4][4] = self.childNode(withName: "//44") as? SKSpriteNode
        AllPieces![4][5] = self.childNode(withName: "//45") as? SKSpriteNode
        AllPieces![4][6] = self.childNode(withName: "//46") as? SKSpriteNode
        AllPieces![4][7] = self.childNode(withName: "//47") as? SKSpriteNode
        AllPieces![4][8] = self.childNode(withName: "//48") as? SKSpriteNode
        for i in 0..<Rows
        {
            for j in 0..<Columns
            {
                AllPieces![i][j]?.zPosition = -1 //zPosition越大则优先显示，默认值为0
            }
        }
        self.SunNum = self.childNode(withName: "//SunNum") as? SKLabelNode
        self.shovel = self.childNode(withName: "//shovel") as? SKSpriteNode
        self.PaueseBt = self.childNode(withName: "//Pause") as? SKSpriteNode
        self.ResumeBt = self.childNode(withName: "//Resume") as? SKLabelNode
        self.Remaining = self.childNode(withName: "//Remaining") as? SKLabelNode
    }
    override init()
    {
        super.init()
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    func FindPos(atPoint pos : CGPoint) -> Rect
    {
        if((shovel?.frame.contains(pos))!)
        {
            return Rect(iscard: true, whichcard: -10,row: 0, column: 0)
        }
        if((PaueseBt?.frame.contains(pos))!)
        {
            self.isPaused = !self.isPaused
            return Rect(iscard: true, whichcard: -1,row: 0, column: 0)
        }
        if((ResumeBt?.frame.contains(pos))!)
        {
            self.viewController?.performSegue(withIdentifier: "Resume", sender: nil)
            return Rect(iscard: true, whichcard: -1,row: 0, column: 0)
        }
        for i in 0..<SunShapes!.count
        {
            if(SunShapes![i]?.frame.contains(pos) == true)
            {
                return Rect(iscard: true, whichcard: -2,row: 0, column: 0)
            }
        }
        for i in 0..<Rows
        {
            for j in 0..<Columns
            {
                if((AllPieces![i][j]?.frame.contains(pos))!)
                {
                    return Rect(iscard: false, whichcard: 0,row: i, column: j)
                }
            }
        }
        for i in 0..<AllCards!.count
        {
            if((AllCards![i]?.contains(pos))!)
            {
                if(TotalOfSun >= CardCost.Plants[i])
                {
                    return Rect(iscard: true, whichcard: i,row: 0, column: 0)
                }
            }
        }
        return Rect(iscard: true, whichcard: -1,row: 0, column: 0)
    }
    func PosToPlant(atPoint pos : CGPoint) -> Rect
    {
        for i in 0..<Rows
        {
            for j in 0..<Columns
            {
                if((AllPieces![i][j]?.frame.contains(pos))!)
                {
                    return Rect(iscard: false, whichcard: 0,row: i, column: j)
                }
            }
        }
        return Rect(iscard: true, whichcard: -1,row: 0, column: 0)
    }
    func PlantPlants(rect: Rect)
    {
        if(self.Whichplant!>=0 && plantsboard?.Board[rect.Row][rect.Column]?.plantnode == nil)
        {
            AllPieces![rect.Row][rect.Column]?.texture = SKTexture.init(imageNamed: PlantsImg.Plants[Whichplant!])
            switch Whichplant
            {
            case 0:
                let plant = SunFlower(Row: rect.Row, Column: rect.Column, date: Date(), Plantnode: AllPieces![rect.Row][rect.Column]!)
                allPlants?.append(plant)
                fivelines?.lines[rect.Row].plantsline.plants.append(plant)
                plantsboard?.Board[rect.Row][rect.Column]=plant
                TotalOfSun -= CardCost.Plants[Whichplant!]
            case 1:
                let plant = Plants_VS_Zombies.PeaShooter(Row: rect.Row, Column: rect.Column, date: Date(), Plantnode: AllPieces![rect.Row][rect.Column]!)
                allPlants?.append(plant)
                fivelines?.lines[rect.Row].plantsline.plants.append(plant)
                plantsboard?.Board[rect.Row][rect.Column]=plant
                TotalOfSun -= CardCost.Plants[Whichplant!]
            case 2:
                let plant = Plants_VS_Zombies.IceShooter(Row: rect.Row, Column: rect.Column, date: Date(), Plantnode: AllPieces![rect.Row][rect.Column]!)
                allPlants?.append(plant)
                fivelines?.lines[rect.Row].plantsline.plants.append(plant)
                plantsboard?.Board[rect.Row][rect.Column]=plant
                TotalOfSun -= CardCost.Plants[Whichplant!]
            case 3:
                let plant = Plants_VS_Zombies.Nut(Row: rect.Row, Column: rect.Column, date: Date(), Plantnode: AllPieces![rect.Row][rect.Column]!)
                allPlants?.append(plant)
                fivelines?.lines[rect.Row].plantsline.plants.append(plant)
                plantsboard?.Board[rect.Row][rect.Column]=plant
                TotalOfSun -= CardCost.Plants[Whichplant!]
            case 4:
                let plant = Plants_VS_Zombies.PotatoMine(Row: rect.Row, Column: rect.Column, date: Date(), Plantnode: AllPieces![rect.Row][rect.Column]!)
                allPlants?.append(plant)
                fivelines?.lines[rect.Row].plantsline.plants.append(plant)
                plantsboard?.Board[rect.Row][rect.Column]=plant
                TotalOfSun -= CardCost.Plants[Whichplant!]
            case 5:
                let plant = Plants_VS_Zombies.DoubleShooter(Row: rect.Row, Column: rect.Column, date: Date(), Plantnode: AllPieces![rect.Row][rect.Column]!)
                allPlants?.append(plant)
                fivelines?.lines[rect.Row].plantsline.plants.append(plant)
                plantsboard?.Board[rect.Row][rect.Column]=plant
                TotalOfSun -= CardCost.Plants[Whichplant!]
            default:
                break
            }
            Whichplant = -1
        }
        else if(Whichplant! == -10)
        {
            if(plantsboard?.Board[rect.Row][rect.Column] != nil)
            {
                AllPieces![rect.Row][rect.Column]?.texture = SKTexture.init(imageNamed: "草地块.png")
                plantsboard?.Board[rect.Row][rect.Column]?.plantnode = nil
                plantsboard?.Board[rect.Row][rect.Column] = nil
            }
            Whichplant = -1
        }
    }
    func touchSun(atPoint pos : CGPoint)
    {
        for i in 0..<SunShapes!.count
        {
            if(SunShapes![i]?.frame.contains(pos) == true)
            {
                TotalOfSun += 25
                SunShapes![i]?.removeAllActions()
                SunShapes![i]?.removeFromParent()
                SunShapes?.remove(at: i)
                break
            }
        }
    }
    func touchDown(atPoint pos : CGPoint)
    {
        touchSun(atPoint: pos)
        let rect=FindPos(atPoint: pos)
        if(rect.isCard == true)
        {
            self.Whichplant=rect.WhichCard
        }
    }
    
    func touchMoved(toPoint pos : CGPoint)
    {
        touchSun(atPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint)
    {
        let rect=PosToPlant(atPoint: pos)
        if(rect.isCard == false)
        {
            PlantPlants(rect: rect)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    func removeNilPlants(plantsline: PlantsLine)
    {
        var i=plantsline.plants.count-1
        while(i>=0 && plantsline.plants[i]!.plantnode == nil)
        {
            plantsboard?.Board[plantsline.plants[i]!.row][plantsline.plants[i]!.column] = nil
            plantsline.plants[i] = nil
            plantsline.plants.removeLast()
            i -= 1
        }
    }
    func removeNilZombies(zombiesline: ZombiesLine)
    {
        var i=zombiesline.zombies.count-1
        while(i>=0 && zombiesline.zombies[i]!.zombienode == nil)
        {
            zombiesline.zombies[i] = nil
            zombiesline.zombies.removeLast()
            i -= 1
        }
    }
    func sortPlant(s1:Plant?,s2:Plant?) throws -> Bool
    {
        if(s1!.plantnode == nil)
        {
            return false
        }
        else
        {
            if(s2!.plantnode != nil)
            {
                return (s1!.plantnode?.position.x)! > (s2!.plantnode?.position.x)!
            }
            else
            {
                return true
            }
        }
    }
    func sortZombie(s1:Zombie?,s2:Zombie?) throws -> Bool
    {
        if(s1!.zombienode == nil)
        {
            return false
        }
        else
        {
            if(s2!.zombienode != nil)
            {
                return (s1!.zombienode?.position.x)! < (s2!.zombienode?.position.x)!
            }
            else
            {
                return true
            }
        }
    }
    func IsNilPlant(plant:Plant?) throws-> Bool
    {
        if(plant?.plantnode == nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
    func updateAllList_ExecuteAllActions()
    {
        do
        {
            try AllPeas?.removeAll(where: IsNilPlant(plant:))
        }
        catch
        {
            
        }
        for pea in AllPeas!
        {
            pea?.execute(alllines: fivelines, Scene: self)
        }
        do
        {
            for i in 0..<(fivelines?.lines.count)!
            {
                try fivelines?.lines[i].zombiesline.zombies.sort(by: sortZombie)
                removeNilZombies(zombiesline: (fivelines?.lines[i].zombiesline)!)
                try fivelines?.lines[i].plantsline.plants.sort(by: sortPlant)
                removeNilPlants(plantsline: (fivelines?.lines[i].plantsline)!)
            }
        }
        catch
        {
        
        }
        var i=0
        while(i<allZombies!.count)
        {
            allZombies![i].move(alllines:&fivelines)//僵尸执行行动
            if(allZombies![i].zombienode == nil)
            {
                allZombies?.remove(at: i)
            }
            else
            {
                i += 1
            }
        }
        i=0
        while(i < allPlants!.count)
        {
            allPlants![i].execute(alllines: fivelines,Scene:self)//植物执行行动
            if(allPlants![i].plantnode == nil)
            {
                allPlants?.remove(at: i)
            }
            else
            {
                i += 1
            }
        }
        Remaining?.text = String.init(RemainingZombies)
        SunNum?.text = String.init(TotalOfSun)
    }
    func JudgeIsFailed()
    {
        for i in 0..<allZombies!.count
        {
            if let zombienode = allZombies![i].zombienode
            {
                if(zombienode.position.x < -320)
                {
                    self.viewController!.performSegue(withIdentifier: "GameFinished", sender: nil)
                    break
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval)
    {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "ss"
        let timeNow = Date()
        let strpastTime = timeFormatter.string(from: pasttime!) as String
        let strNowTime = timeFormatter.string(from: timeNow) as String
        updateAllList_ExecuteAllActions()
        JudgeIsFailed()
        if(RemainingZombies <= 0)
        {
            IsVictory = true
            if(VictoryTime == begintime)
            {
                VictoryTime = timeNow
            }
        }
        if(strpastTime != strNowTime)//有些依据时间间隔的操作每秒执行一次就行了
        {
            let components = NSCalendar.current.dateComponents([.second], from: begintime!, to: timeNow)
            if(IsVictory == true)
            {
                if(NSCalendar.current.dateComponents([.second], from: VictoryTime!, to: timeNow).second! >= 3)
                {
                    self.viewController?.performSegue(withIdentifier: "Victory", sender: nil)
                }
            }
            if(components.second! != 0 && components.second!%4 == 0)
            {
                let sunnode = SKSpriteNode.init(imageNamed: "阳光.png")
                let x = CGFloat(Int(arc4random()%480) - 240)
                sunnode.position.x=x
                sunnode.position.y=290
                self.addChild(sunnode)
                let y = CGFloat(Int(arc4random()%240) - 480)
                sunnode.run(SKAction.moveBy(x: 0, y: y, duration: TimeInterval(-y/30)))
                self.SunShapes?.append(sunnode)
            }
            zombiesgenerator?.Execute(Scene: self)
        }
        pasttime=timeNow
    }
}
