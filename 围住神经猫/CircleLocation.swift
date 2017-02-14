//
//  ViewController.swift
//  围住神经猫
//  Created by 夏祥全 on 17/02/03.
//  Copyright © 2017年 围住神经猫. All rights reserved.
//

import Foundation
import UIKit
class CircleLocation {
    
    var row: Int //存每个点的行
    var col: Int //存每个点的列
    var path: Int = -100 //存每个点的最短路径数
    var cost: Int = -100 //存每个点的连接数
    
    init(row:Int, col:Int) {
        self.row = row
        self.col = col
    }
    func printLocation() {
        print(" \(path) ")
    }
    
    // TODO: 获取六个方向上的点
    
    /*
     * o  o  o  o
     *  ❤️ 🐱 o
     * o  o  o  o
     * 当前的点 行不变  列 -1 即为左边的点
     */
    func getLeft() -> CircleLocation? {
        var newp : CircleLocation?
        if (col > 0) {
            newp = allCircleLocations[row][col-1]
        }
        return newp
    }
    
    /*
     * o  o  o  o
     *   o 🐱 ❤️
     * o  o  o  o
     * 当前的点 行不变  列 +1 即为右边的点
     */
    func getRight() -> CircleLocation? {
        var newp : CircleLocation? = nil
        if (col < 8) {
            newp = allCircleLocations[row][col+1]
        }
        return newp
    }
    func getLeftDown() -> CircleLocation? {
        var newp : CircleLocation? = nil
        if (row < 8) {
            let p = allCircleLocations[row+1][col]
            if (row % 2 == 0) {
                if (col == 0) {
                    newp = nil
                }
                else {
                    newp = allCircleLocations[row+1][col-1]
                }
            }
            else {
                newp = p
            }
        }
        return newp
    }
    func getRightDown() -> CircleLocation? {
        var newp : CircleLocation? = nil
        if (row < 8) {
            let p = allCircleLocations[row+1][col]
            if (row % 2 == 0) {
                newp = p
            } else {
                if col == 8 {
                    newp = nil
                }
                else {
                    newp = allCircleLocations[row+1][col+1]
                }
            }
        }
        return newp
    }
    func getRightUp() -> CircleLocation? {
        var newp : CircleLocation? = nil
        if (row < 8) {
            let p = allCircleLocations[row-1][col]
            if (row % 2 == 0) {
                newp = p
            } else {
                if col == 8 {
                    newp = nil
                }
                else {
                    newp = allCircleLocations[row-1][col+1]
                }
            }
        }
        return newp
    }
    func getLeftUp() -> CircleLocation? {
        var newp : CircleLocation? = nil
        if (row < 8) {
            let p = allCircleLocations[row-1][col]
            if (row % 2 == 0) {
                if (col == 0) {
                    newp = nil
                } else {
                    newp = allCircleLocations[row-1][col-1]
                }
            }
            else {
                newp = p
            }
        }
        return newp
    }
    // TODO: 获取 某个点周围 六个方向的点
    func getAllConnectLocation() -> [CircleLocation] {
        var arr = [CircleLocation]()
        var cl = getLeftUp()
        if let temp = cl {
            if map[temp.row][temp.col] == 0 {
                arr.append(temp)
            }
        }
        cl = getLeft()
        if let temp = cl {
            if map[temp.row][temp.col] == 0 {
                arr.append(temp)
            }
        }        
        cl = getLeftDown()
        if let temp = cl {
            if map[temp.row][temp.col] == 0 {
                arr.append(temp)
            }
        }
        cl = getRightDown()
        if let temp = cl {
            if map[temp.row][temp.col] == 0 {
                arr.append(temp)
            }
        }
        cl = getRight()
        if let temp = cl {
            if map[temp.row][temp.col] == 0 {
                arr.append(temp)
            }
        }
        cl = getRightUp()
        if let temp = cl {
            if map[temp.row][temp.col] == 0 {
                arr.append(temp)
            }
        }
        return arr
    }
    
    // TODO: 是否为边界
    func isBoundary() -> Bool {
        if (row == 0 || row == 8 ||
            col == 0 || col == 8) {
                return true;
        }
        else {
            return false;
        }
    }
    /*
     * Objective-C中调用一个方法，没有使用其返回值不会警告。并且一个变量未被上下文使用到的时候可以用__unused修饰符修饰。
     * Swift中，不用变量来接收返回值会爆出警告“result of call to ‘XXX’ is unused ”相比Objective-C，Swift更加严谨。
     * 如果我们不想使用返回值，在 func 定义的上方，加上 @discardableResult 修饰符即可
     */
    // TODO: 计算每个点的连接数
    @discardableResult func calculateCost() -> Int {
        if map[row][col] == 1 {
            cost = 100
            return cost
        }
        
        if isBoundary() {
            cost = 0
            return cost
        }
        
        let allConnectLocation = getAllConnectLocation()
        cost = allConnectLocation.count
        return cost
    }
    // 计算路径
    @discardableResult func calculatePath() -> Int {
        let i = self.row
        let j = self.col
        if (map[i][j] == 1) {
            // 9 * 9 = 81 最多  100是最大值 不可能超过
            self.path = 100
            return self.path
        }
        if self.isBoundary() {
            self.path = 0
            return self.path
        }
        let allConnectLocation = self.getAllConnectLocation()
        var min = 100
        for obj in allConnectLocation {
            print(obj.path)
            if obj.path > -100 {
                var tmp = obj.path;
                if obj.path < 0 {
                    tmp = -tmp;
                }
                if (min > tmp) {
                    min = tmp;
                }
            }
        }
        if min < 100 {
            self.path = min + 1;
        } else {
            self.path += 1;
        }
        return self.path;
    }
    
    func compare(_ cl:CircleLocation) -> Bool {
        // 判断是否在圆圈中
        if hasCircle == false {
            return self.isMoreThan(cl)
        } else {
            return self.isLessThan(cl)
        }
    }
    
    func isMoreThan(_ cl:CircleLocation) -> Bool {
        var spath = self.path
        var cpath = cl.path;
        if spath < 0 {
            spath = -spath
        }
        if cpath < 0 {
            cpath = -cpath
        }
        if spath > cpath {
            return true
        }
        else {
            return false
        }
    }
    
    func isLessThan(_ cl:CircleLocation) -> Bool {
        if self.cost < cl.cost {
            return true
        }
        else {
            return false
        }
    }
    
    // TODO: 是否在圆圈里
    func isInCircle() -> Bool {
        //遍历这周围的点，看看他们是否是墙或者是圈内点（它的值是负数，但大于－100.
        let allConnectLocation = self.getAllConnectLocation()
        var num = 0;
        for obj in allConnectLocation {
            //它是圈内点
            if (obj.path > -100 && obj.path < 0) ||
                obj.path == 100 {
                //它是墙
                    num += 1;
            }
        }
        if (num == allConnectLocation.count) {
            return true;
        }
        else {
            return false;
        }
    }
}
