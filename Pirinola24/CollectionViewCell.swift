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
    var urlimagen : String?
    var nombreProducto : String?
    var agregarBtn : UIButton?
    var conteo : UIButton?
    var disminuirBtn : UIButton?
    var audioPlayer = AVAudioPlayer()
    
    func iniciarBotones(widthBoton:CGFloat,ubicacionInicial:CGFloat , espacio: CGFloat)
    {
        if agregarBtn == nil
        {
            agregarBtn = UIButton(type: .Custom)
            agregarBtn!.layer.cornerRadius = 0.5 * widthBoton
            agregarBtn!.frame = CGRectMake(0, ubicacionInicial, widthBoton, widthBoton)
            agregarBtn!.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 187/255)
            agregarBtn!.addTarget(self, action: #selector(clickAgregar), forControlEvents: .TouchUpInside)
            agregarBtn!.setTitle("+", forState: UIControlState.Normal)
            agregarBtn!.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            addSubview(agregarBtn!)
        }
        
        if conteo == nil
        {
            conteo = UIButton(type: .Custom)
            conteo!.layer.cornerRadius = 0.5 * widthBoton
            conteo!.frame = CGRectMake(widthBoton + espacio, ubicacionInicial, widthBoton, widthBoton)
            conteo!.backgroundColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 187/255)
            conteo!.setTitleColor(UIColor.yellowColor(), forState:  UIControlState.Normal)
            conteo!.hidden = true
            addSubview(conteo!)
            
        }
        
        if disminuirBtn == nil
        {
            disminuirBtn = UIButton(type: .Custom)
            disminuirBtn!.layer.cornerRadius = 0.5 * widthBoton
            disminuirBtn!.frame = CGRectMake((widthBoton * 2) + (espacio * 2), ubicacionInicial, widthBoton, widthBoton)
            disminuirBtn!.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 187/255)
            disminuirBtn!.addTarget(self, action: #selector(clickDisminuir), forControlEvents: .TouchUpInside)
            disminuirBtn!.setTitle("-", forState: UIControlState.Normal)
            disminuirBtn!.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            disminuirBtn!.hidden = true
            addSubview(disminuirBtn!)
        }
        
        
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
        let pianoSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sonido_click", ofType: "mp3")!)
        
        do{
            
           try audioPlayer =  AVAudioPlayer(contentsOfURL: pianoSound)
        }
        catch
        {
            print("error archivo")
        }
        
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.play()
    }
    
    
    
    
}
