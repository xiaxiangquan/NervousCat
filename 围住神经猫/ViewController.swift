//
//  ViewController.swift
//  围住神经猫
//  Created by 夏祥全 on 17/02/03.
//  Copyright © 2017年 围住神经猫. All rights reserved.
//  test 2
import Foundation
import UIKit

var hasCircle = false
var allCircleLocations = [[CircleLocation]]()
var map = [[0,0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,0,0]]


func produceAllCircleLocations() {
    // 生成二维数组 初始值为0
    for i:Int in 0 ..< 9 {
        var rowCircles = [CircleLocation]()
        for j:Int in 0 ..< 9 {
            let cir = CircleLocation(row:i,col:j)
            rowCircles.append(cir)
        }
        allCircleLocations.append(rowCircles);
    }
}

class ViewController: UIViewController {
    
    var allButtons = [[UIButton]]()
    var catImageview = UIImageView()
    var gameLevel: Int = 10
    var pathNumber: Int = 0
    var clickPoint:CircleLocation? = nil
    var cat = CircleLocation(row: 4, col: 4)
    var isGameOver = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(map)
        produceAllButtons()
        produceAllCircleLocations()
        produceCat()
        initializeGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initializeGame() {
        for i:Int in 0 ..< 9 {
            for j:Int in 0 ..< 9 {
                map[i][j] = 0
                allButtons[i][j].setImage(UIImage(named:"gray.png"),for:UIControlState())
            }
        }
        print(map)
        catImageview.frame = CGRect(x: 28*4+20,y: 28*3+170,width: 30,height: 56)
        cat.row = 4; cat.col = 4
        map[4][4] = 1
        produceGameLevel()
        isGameOver = 0
    }
    func produceCat() {
        catImageview = UIImageView()
        catImageview.frame = CGRect(x: 28*4+20,y: 28*3+170,width: 30,height: 56)
        self.view.addSubview(catImageview)
        let cat = UIImage(named:"middle2.png")
        catImageview.image = cat;
    }
    func produceAllButtons() {
        
        for i:Int in 0 ..< 9 {
            var oneRowButtons = [UIButton]()
            for j:Int in 0 ..< 9 {
                let btn = UIButton()
                if i%2 == 0 {
                    btn.frame = CGRect(x: (CGFloat)(28 * j + 20), y: (CGFloat)(28 * i + 170), width: 28.0, height: 28.0)
                }
                else {
                    btn.frame = CGRect(x: (CGFloat)(28 * j + 34), y: (CGFloat)(28 * i + 170), width: 28.0, height: 28.0)
                }
                btn.setImage(UIImage(named:"gray.png"),for:UIControlState())
                self.view.addSubview(btn)
                btn.addTarget(self, action:#selector(ViewController.clickMe(aaa:)),for:.touchUpInside)
                oneRowButtons.append(btn)
            }
            allButtons.append(oneRowButtons)
        }
    }
    func clickMe(aaa button:UIButton) {
        button.setImage(UIImage(named:"yellow2.png"),for:UIControlState())
        // btn : btn
        let row = getButtonRow(aaaaa: button)
        let col = getButtonCol(button)
        updateCost(row, col:col)
        pathNumber += 1
        if (self.isGameOver == 1 && self.cat.row == row && self.cat.col == col) {
            showWinAlertView()
            return
        }
        else if (self.isGameOver == 1) {
            //只有一个点了，没选中则继续
        }
        else {
            isGameOver = catAutoGo()
            if isGameOver == -1 {
                showLoseAlertView()
                return
            }
            else if (self.isGameOver == 1 && self.cat.row == row && self.cat.col == col) {
                showWinAlertView()
                return
            }
            calAllCost()
        }
    }
    func showLoseAlertView() {
        let alert = UIAlertController(title: "亲，猫跑掉了！", message: "你失败了！加油啊！", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "退出游戏？", style: .default, handler: {act in exit(-1)})
        let actionNo = UIAlertAction(title: "再来一次？", style: .default, handler: {act in self.runAgain()})
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true, completion: nil)
    }
    func showWinAlertView() {
        let alert = UIAlertController(title: "亲，你的步数是：\(pathNumber)次", message: "你成功抓住猫了！", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "退出游戏？", style: .default, handler: {act in exit(-1)})
        let actionNo = UIAlertAction(title: "再来一次？", style: .default, handler: {act in self.runAgain()})
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true, completion: nil)
    }
    func runAgain() {
        initializeGame()
    }
    
    // TODO: 随机设置墙的点  1 为墙
    func produceGameLevel() {
        gameLevel = Int(arc4random() % 20) + 10
        var num = 0
        while num < gameLevel {
            let row:Int = (Int)(arc4random() % 9)
            let col:Int = (Int)(arc4random() % 9)
            
            if row != 4 && col != 4 && map[row][col] == 0 {
                map[row][col] = 1
                num += 1
                allButtons[row][col].setImage(UIImage(named:"yellow2.png"),for:UIControlState())
            }
        }
    }
    // _ 忽略外部参数
    func getButtonRow(aaaaa btn:UIButton) -> Int {
        let y = (Int)(btn.frame.origin.y)
        let row = (y - 170) / 28
        return row
    }
    func getButtonCol(_ btn:UIButton) -> Int {
        let x = (Int)(btn.frame.origin.x)
        let y = (Int)(btn.frame.origin.y)
        let row = (y - 170) / 28
        
        var col = 0
        if (row % 2 == 0) {
            col = (x - 20) / 28
        }
        else {
            col = (x - 34) / 28
        }
        return col
    }
    
    // TODO: 更新连接数
    func updateCost(_ row:Int, col:Int) {
        let loc = allCircleLocations[row][col]
        map[loc.row][loc.col] = 1
        clickPoint = loc;
        clearAllCost()
        calAllCost()
    }
    
    // TODO: 获取最优路径
    func getBestLocation() -> CircleLocation? {
        var catAllSelects = allCircleLocations[cat.row][cat.col].getAllConnectLocation()
        if catAllSelects.count > 0 {
            var best = catAllSelects[0]
            if best.isBoundary() {
                return best
            }
            // 为边界返回
            for i in 1 ..< catAllSelects.count {
                if catAllSelects[i].isBoundary() {
                    best = catAllSelects[i]
                    break
                }
                
                // 比较两个点
                if best.compare(catAllSelects[i]) {
                    best = catAllSelects[i]
                }
            }
            return best
        }
        return nil
    }
    func catAutoGo() -> Int {
        //找到新位置
        let bestS = getBestLocation()
        if let best = bestS {
            var i = self.cat.row;
            var j = self.cat.col;
            if (clickPoint!.row == allCircleLocations[i][j].row && clickPoint!.col == allCircleLocations[i][j].col) {
                //什么都不做
            }
            else {
                map[i][j] = 0;
            }
            self.cat.row = best.row;
            self.cat.col = best.col;
            i = self.cat.row;
            j = self.cat.col;
            map[i][j] = 1;
            
            if (i % 2 == 0) {
                catImageview.frame = CGRect(x: (CGFloat)(28*j+20), y: (CGFloat)(28*(i-1)+170), width: 30, height: 56)
            }
            else {
                catImageview.frame = CGRect(x: (CGFloat)(28*j+34), y: (CGFloat)(28*(i-1)+170), width: 30, height: 56);
            }
            
            if cat.isBoundary() {
                return -1 //到边界
            }
        }
        else {
            return 1 //Only one point
        }
        return 0
    }
    func clearAllCost() {
        for i:Int in 0 ..< 9 {
            for j:Int in 0 ..< 9 {
                allCircleLocations[i][j].path = -100;
                allCircleLocations[i][j].cost = -100;
            }
        }
    }
    // 计算每个点的路径数
    func calAllCost() {
        clearAllCost()
        //计算最短路径
        //按照从左右、上下四个方向进行搜索
        /*  OC 写法
        for (NSString *str in Array) {
            
        }*/
        for i:Int in 0 ..< 9 {
            for j:Int in 0 ..< 9 {
                // 左上角
                allCircleLocations[i][j].calculatePath()
                allCircleLocations[j][i].calculatePath()
                
                // 右上角
                allCircleLocations[i][8-j].calculatePath()
                allCircleLocations[j][8-i].calculatePath()

                // 左下角
                allCircleLocations[8-j][i].calculatePath()
                allCircleLocations[8-i][j].calculatePath()
                
                // 右下角
                allCircleLocations[8-j][8-i].calculatePath()
                allCircleLocations[8-i][8-j].calculatePath()
            }
        }
        // 计算每个点的连接数
        for i:Int in 0 ..< 9 {
            for j:Int in 0 ..< 9 {
                allCircleLocations[i][j].calculateCost()
            }
        }
        //判断猫是否在一个圈中
        hasCircle = self.cat.isInCircle()
    }

}
