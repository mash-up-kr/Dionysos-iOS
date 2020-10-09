//
//  ParticleEffectView.swift
//  Dionysos
//
//  Created by Jercy on 2020/10/09.
//  Copyright © 2020 Mashup. All rights reserved.
//

import UIKit

class ParticleEffectView: UIView {
    typealias CustomizeHandler = ([CAEmitterCell]) -> [CAEmitterCell]
    private let images: [UIImage] = [UIImage(named: "dot1")!, UIImage(named: "dot2")!, UIImage(named: "dot3")!, UIImage(named: "dot4")!, UIImage(named: "dot5")!]
    private var customizeHandler: CustomizeHandler?
    var multipler: Int = 5
    var isPreStart: Bool = true
    
    private var emitterLayer: CAEmitterLayer?
    private var emitterCells: [CAEmitterCell] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func start() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        setupParticleEffect()
    }
    
    func stop() {
        emitterLayer?.birthRate = 0
    }
    
    private func setupParticleEffect() {
        emitterLayer = CAEmitterLayer()
        guard let emitterLayer = emitterLayer else {
//            Log.msg("Emitter Layer Error.")
            return
        }
        
        emitterLayer.emitterPosition = CGPoint(x: frame.minX, y: frame.minY)
        emitterLayer.emitterShape = CAEmitterLayerEmitterShape.rectangle
        emitterLayer.emitterSize = CGSize(width: frame.width, height: frame.height)
        emitterCells = makeEmitterCells(count: images.count, multipler: multipler)
        emitterLayer.emitterCells = emitterCells
        emitterLayer.beginTime = isPreStart ? 0 : CACurrentMediaTime()
        
        layer.masksToBounds = true
        layer.zPosition = -1
        layer.addSublayer(emitterLayer)
    }
    
    private func makeEmitterCells(count: Int, multipler: Int) -> [CAEmitterCell] {
        if let customizeHandler = customizeHandler {
            let cells = Array(repeating: CAEmitterCell(), count: count * multipler)
            return customizeHandler(cells)
        }
        
        var cells: [CAEmitterCell] = []
        
        for index in 0..<count * multipler {
            let cell = CAEmitterCell()
            cell.birthRate = 0.05 + generateRandomValue()
            cell.lifetime = 10
            cell.velocity = 100
            cell.velocityRange = 40
            cell.spinRange = 4
            cell.scale = 0.7
            cell.scaleRange = 0.5
            cell.xAcceleration = CGFloat(generateRandomValue())
            cell.yAcceleration = CGFloat(generateRandomValue())
            cell.emissionRange = convertToRadian(degree: generateRandomRadian())
            cell.emissionLongitude = convertToRadian(degree: generateRandomRadian())
            cell.contents = fetchImage(index: index)
            
            cells.append(cell)
        }
        
        return cells
    }
    
    func customizeCells(_ handler: CustomizeHandler?) -> Self {
        customizeHandler = handler
        return self
    }
    
    private func generateRandomValue() -> Float {
        return Float(arc4random() % 3 + 1) / 10.0
    }
    
    private func generateRandomRadian() -> CGFloat {
        return CGFloat(arc4random() % 180)
    }
    private func convertToRadian(degree: CGFloat) -> CGFloat {
        return degree * CGFloat.pi / 180.0
    }
    
    private func fetchImage(index: Int) -> CGImage? {
        return images[index % images.count].cgImage
    }
}
