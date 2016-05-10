//
//  CollectionViewCell.swift
//  Pirinola24
//
//  Created by Aplimovil on 29/04/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell
{
        
    @IBOutlet weak var imagen: UIImageView!
    
    
    var objectId : String?
    var precio : Int = 0
    var urlimagen : NSURL?
    var nombreProducto : String?
    var agregarBtn : UIButton?
    var conteo : UIButton?
    var disminuirBtn : UIButton?
    var placeholder : UIImageView!
    
    
    func agregarPlaceholder(ph:UIImageView)
    {
        self.placeholder = ph
        self.addSubview(self.placeholder!)
    }
    
    func iniciarBotones(widthBoton:CGFloat,ubicacionInicial:CGFloat , espacio: CGFloat)
    {
        if self.agregarBtn == nil
        {
            self.agregarBtn = UIButton(type: .Custom)
            self.agregarBtn!.layer.cornerRadius = 0.5 * widthBoton
            self.agregarBtn!.frame = CGRectMake(0, ubicacionInicial, widthBoton, widthBoton)
            self.agregarBtn!.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 187/255)
            self.agregarBtn!.addTarget(self, action: #selector(clickAgregar), forControlEvents: .TouchUpInside)
            self.agregarBtn!.setTitle("+", forState: UIControlState.Normal)
            self.agregarBtn!.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            
        }
        
        if self.conteo == nil
        {
            self.conteo = UIButton(type: .Custom)
            self.conteo!.layer.cornerRadius = 0.5 * widthBoton
            self.conteo!.frame = CGRectMake(widthBoton + espacio, ubicacionInicial, widthBoton, widthBoton)
            self.conteo!.backgroundColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 187/255)
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
            self.disminuirBtn!.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            
        }
        self.conteo!.hidden = true
        self.disminuirBtn!.hidden = true
        addSubview(self.disminuirBtn!)
        addSubview(self.conteo!)
        addSubview(self.agregarBtn!)
        self.inicializarContadores()
        
    }
    
    func clickAgregar(sender: AnyObject)
    {
        reproducirSonidoClick()
        var bandera : Int = 0
        for itemcarro in AppUtil.listaCarro
        {
            if(itemcarro.objectId == self.objectId)
            {
                itemcarro.cantidad += 1
                bandera = 1
                conteo!.setTitle(String(itemcarro.cantidad), forState: UIControlState.Normal)
                conteo!.hidden = false
                disminuirBtn?.hidden = false
                break
            }
        }
        
        if(bandera == 0)
        {
            let ic : ItemCarrito = ItemCarrito()
            ic.objectId = self.objectId
            ic.cantidad = 1
            ic.precio = self.precio
            ic.imagen = self.urlimagen
            AppUtil.listaCarro.append(ic)
            conteo!.setTitle(String(ic.cantidad), forState: UIControlState.Normal)
            conteo!.hidden = false
            disminuirBtn?.hidden = false
        }
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
                    conteo!.hidden = true
                    disminuirBtn?.hidden = true
                }
                break
            }
            contador += 1
        }

        
    }
    
    func reproducirSonidoClick()
    {
        AppUtil.audioPlayer.numberOfLoops = 1
        AppUtil.audioPlayer.prepareToPlay()
        AppUtil.audioPlayer.play()
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
            
            dispatch_async(dispatch_get_main_queue()) {
                if cantidad > 0
                {
                    self.conteo?.setTitle(String(cantidad), forState: UIControlState.Normal)
                    self.disminuirBtn?.hidden = false
                    self.conteo?.hidden = false
                }
            }
        }

    }
    
    
    
    
}
