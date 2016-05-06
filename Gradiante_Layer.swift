//
//  Gradiante_Layer.swift
//  Pirinola24
//
//  Created by Aplimovil on 30/04/16.
//  Copyright © 2016 WD. All rights reserved.
//red: 234/255, green: 28/255, blue: 36/255 , alpha: 1
import UIKit
extension CAGradientLayer
{
    func rojoDegradado() -> CAGradientLayer
    {
        let topColor = UIColor(red: 234/255, green: 28/255, blue: 36/255 , alpha: 1)
        let bottomColor = UIColor(red: 155/255, green: 3/255, blue: 16/255 , alpha: 1)
        let gradientColor:[CGColor] = [topColor.CGColor,bottomColor.CGColor]
        //let gradientLocation : [Float] = [0.5 , 0.0]
        
        let gradientLayer :CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.type = kCAGradientLayerAxial
        gradientLayer.startPoint = CGPointMake(1,1)
        gradientLayer.endPoint = CGPointZero
        
        return gradientLayer
    }
    
    
    func amarilloDegradado() -> CAGradientLayer
    {
        let topColor = UIColor(red: 1, green: 233, blue: 0 , alpha: 1)
        let bottomColor = UIColor(red: 252/255, green: 128/255, blue: 0 , alpha: 1)
        
        let gradientColor:[CGColor] = [topColor.CGColor,bottomColor.CGColor]
        //let gradientLocation : [Float] = [0.0 , 0.8]
        
        let gradientLayer :CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.type = kCAGradientLayerAxial
        gradientLayer.startPoint = CGPointMake(1,1)
        gradientLayer.endPoint = CGPointZero

        
        return gradientLayer
    }

}
