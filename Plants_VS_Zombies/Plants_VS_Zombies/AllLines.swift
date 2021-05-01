//
//  FiveLines.swift
//  appGame
//
//  Created by 侯彤 on 2020/12/13.
//

import Foundation
struct Rect
{
    var isCard:Bool
    var WhichCard:Int
    var Row:Int
    var Column:Int
    init(iscard:Bool, whichcard:Int, row:Int, column:Int)
    {
        self.isCard=iscard
        self.WhichCard=whichcard
        self.Row=row
        self.Column=column
    }
}
class PlantsBoard
{
    var Board:Array<Array<Plant?>>    //=[[Bool]]()
    init()
    {
        Board=Array(repeating: Array(repeating: nil, count: 9), count: 5)
    }
}
struct AllLines
{
    public var lines:Array<Line>
    init(_ numbers:Int)
    {
        lines=[Line]()
        for _ in 1...numbers
        {
            lines.append(Line())
        }
    }
}
struct Line
{
    public var plantsline:PlantsLine=PlantsLine()
    public var zombiesline:ZombiesLine=ZombiesLine()
}
