//
//  CompasView.swift
//  Compass
//
//  Created by Alina Kovtunovich on 4/10/24.
//

import UIKit

class CompasView: UIView {
    
    var halfFrameWidth: CGFloat = 0
    var fullFrameWidth: CGFloat = 0
    let needleBottomWith: CGFloat = 10.0
    var needleLength: CGFloat = 0
    
    var centerPoint: CGPoint?

    override func draw(_ rect: CGRect) {
        
        // размеры выбираются, исходя из размеров рамки
        halfFrameWidth = self.bounds.width * 0.5
        fullFrameWidth = self.bounds.width
        needleLength = halfFrameWidth / 2
        
        // создаем центральную точку
        centerPoint = CGPoint(x: halfFrameWidth, y: halfFrameWidth)
        
        drawNeedle()
        createMarks()
    }
    
    // функция, создающая иглу компаса и окружности
    func drawNeedle() {
        
        // отрисовка верхней части иглы
        let uppNeedle = UIBezierPath()
        uppNeedle.move(to: CGPoint(x: halfFrameWidth - needleBottomWith, y: halfFrameWidth))
        uppNeedle.addLine(to: CGPoint(x: halfFrameWidth, y: needleLength))
        uppNeedle.addLine(to: CGPoint(x: halfFrameWidth + needleBottomWith, y: halfFrameWidth))
        uppNeedle.close()
        UIColor.systemBackground.setFill()
        uppNeedle.fill()
        
        // отрисовка нижней части иглы
        let dowNeedle = UIBezierPath()
        dowNeedle.move(to: CGPoint(x: halfFrameWidth - needleBottomWith, y: halfFrameWidth))
        dowNeedle.addLine(to: CGPoint(x: halfFrameWidth, y: fullFrameWidth - needleLength))
        dowNeedle.addLine(to: CGPoint(x: halfFrameWidth + needleBottomWith, y: halfFrameWidth))
        dowNeedle.close()
        UIColor.black.setFill()
        dowNeedle.fill()
        
        // создаем центральный "гвоздик" нашей стрелки
        let centerPin = UIBezierPath(arcCenter: centerPoint!, radius: 6.0, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        UIColor.red.setFill()
        centerPin.fill()
        
        // внутреннее кольцо
        let innRing = UIBezierPath(arcCenter: centerPoint!, radius: halfFrameWidth * 0.9, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        UIColor.black.setStroke()
        innRing.lineWidth = 1
        innRing.stroke()
        
        // внешнее кольцо
        let outRing = UIBezierPath(arcCenter: centerPoint!, radius: halfFrameWidth * 0.95, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        UIColor.black.setStroke()
        outRing.lineWidth = 2
        outRing.stroke()
        
    }
    
    // функция создания меток с градусами
    func createMarks() {
        
        for degree in stride(from: 0, to: 365, by: 2) {
            
            var innDistance: CGFloat = 0.9
            
            let outPoint = foundPointLocation(degrees: CGFloat(degree), distance: innDistance)!

            if degree % 90 == 0 {
                innDistance = 0.7
            } else if degree % 10 == 0 {
                innDistance = 0.8
            } else {
                innDistance = 0.85
            }
            
            let innPoint = foundPointLocation(degrees: CGFloat(degree), distance: innDistance)!
            
            let line = UIBezierPath()
            line.move(to: outPoint)
            line.addLine(to: innPoint)
            line.close()
            UIColor.darkGray.setStroke()
            line.lineWidth = 1
            if degree % 90 == 0 {
                line.lineWidth = 2
            }
            line.stroke()
        }
        
        var degree = 0
        
        for direction in ["В", "Ю", "З", "С"] {
            createDirection(direcion: direction, degree: degree, location: foundPointLocation(degrees: CGFloat(degree), distance: 0.60)!)
            degree += 90
        }
    }
    
    // функция определения местоположения точки
    func foundPointLocation(degrees: CGFloat, distance: CGFloat) -> CGPoint? {
        
        var location : CGPoint?
        let radian: CGFloat = degrees * .pi / 180
        let path = UIBezierPath(arcCenter: centerPoint!, radius: halfFrameWidth * distance, startAngle: 0, endAngle: radian, clockwise: false)
        // текущая точка
        location = path.currentPoint
        return location
        
    }
    
    func createDirection(direcion: String,degree: Int, location: CGPoint) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: location.x - 15, y: location.y - 10, width: 30, height: 20)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.fontSize = CGFloat(20)
        textLayer.font = "ArialMT" as CFString
        textLayer.string = direcion
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
    }
    
}
