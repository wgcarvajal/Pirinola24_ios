//
//  CollectionViewCellPedido.swift
//  Pirinola24
//
//  Created by Aplimovil on 6/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

protocol ComunicacionControladorPedido
{
    func actualizarCollectionView()
    func actualizarTotal()
}

class CollectionViewCellPedido: UICollectionViewCell
{
    
    @IBOutlet var imagen: UIImageView!
    
    var comunicacionControladorPedido : ComunicacionControladorPedido?
    var urlimagen : NSURL?
    var objectId : String?
    
    var agregarBtn : UIButton?
    var conteo : UIButton?
    var disminuirBtn : UIButton?
    
    func iniciarBotones(widthBoton:CGFloat,ubicacionInicial:CGFloat , espacio: CGFloat)
    {
        
        var fontsize: CGFloat = 0.0
        var fontsizeconteo : CGFloat = 0.0
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            fontsize = 15.0
            fontsizeconteo = 12.0
            break
            
        case .Pad:
            fontsize = 30.0
            fontsizeconteo = 24.0
            break
            
        default:
            break
        }

        
        
        if self.agregarBtn == nil
        {
            self.agregarBtn = UIButton(type: .Custom)
            self.agregarBtn!.layer.cornerRadius = 0.5 * widthBoton
            self.agregarBtn!.frame = CGRectMake(0, ubicacionInicial, widthBoton, widthBoton)
            self.agregarBtn!.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 187/255)
            self.agregarBtn!.addTarget(self, action: #selector(clickAgregar), forControlEvents: .TouchUpInside)
            self.agregarBtn!.setTitle("+", forState: UIControlState.Normal)
            self.agregarBtn?.titleLabel?.font = UIFont(name: "Segoe Print", size: fontsize)
            self.agregarBtn!.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            
        }
        
        if self.conteo == nil
        {
            self.conteo = UIButton(type: .Custom)
            self.conteo!.setTitle("0", forState: UIControlState.Normal)
            self.conteo!.layer.cornerRadius = 0.5 * widthBoton
            self.conteo!.frame = CGRectMake(widthBoton + espacio, ubicacionInicial, widthBoton, widthBoton)
            self.conteo!.backgroundColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 187/255)
            self.conteo!.titleLabel?.font = UIFont(name: "Segoe Print", size: fontsizeconteo)
            self.conteo!.setTitleColor(UIColor.yellowColor(), forState:  UIControlState.Normal)
            
            
        }
        
        if self.disminuirBtn == nil
        {
            self.disminuirBtn = UIButton(type: .Custom)
            self.disminuirBtn!.layer.cornerRadius = 0.5 * widthBoton
            self.disminuirBtn!.frame = CGRectMake((widthBoton * 2) + (espacio * 2), ubicacionInicial, widthBoton, widthBoton)
            self.disminuirBtn!.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 187/255)
            self.disminuirBtn!.addTarget(self, action: #selector(clickDisminuir), forControlEvents: .TouchUpInside)
            self.disminuirBtn!.setTitle("-", forState: UIControlState.Normal)
            self.disminuirBtn!.titleLabel?.font = UIFont(name: "Segoe Print", size: fontsize)
            self.disminuirBtn!.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            
        }
        addSubview(self.disminuirBtn!)
        addSubview(self.conteo!)
        addSubview(self.agregarBtn!)
        self.inicializarContadores()
    }
    
    
    func clickAgregar(sender: AnyObject)
    {
        reproducirSonidoClick()
        for itemcarro in AppUtil.listaCarro
        {
            if(itemcarro.objectId == self.objectId)
            {
                itemcarro.cantidad += 1
                conteo!.setTitle(String(itemcarro.cantidad), forState: UIControlState.Normal)
                break
            }
        }
        self.comunicacionControladorPedido?.actualizarTotal() 
    }
    
    
    func clickDisminuir(sender: AnyObject)
    {
        reproducirSonidoClick()
        var contador : Int = 0
        for itemcarro in AppUtil.listaCarro
        {
            if itemcarro.objectId == self.objectId
            {
                itemcarro.cantidad -= 1
                conteo!.setTitle(String(itemcarro.cantidad), forState: UIControlState.Normal)
                conteo!.hidden = false
                disminuirBtn?.hidden = false
                if itemcarro.cantidad == 0
                {
                    AppUtil.listaCarro.removeAtIndex(contador)
                    self.comunicacionControladorPedido?.actualizarCollectionView()
                }
                break
            }
            contador += 1
        }
        self.comunicacionControladorPedido?.actualizarTotal()        
        
    }
    
    func inicializarContadores()
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            var cantidad : Int = 0
            for itemCarrito  in  AppUtil.listaCarro
            {
                if itemCarrito.objectId == self.objectId
                {
                    cantidad = itemCarrito.cantidad
                    break
                }
            }
            
            dispatch_async(dispatch_get_main_queue())
            {
                self.conteo?.setTitle(String(cantidad), forState: UIControlState.Normal)
            }
        }
        
    }
    
    func reproducirSonidoClick()
    {
        AppUtil.audioPlayer.numberOfLoops = 1
        AppUtil.audioPlayer.prepareToPlay()
        AppUtil.audioPlayer.play()
    }

    
}
