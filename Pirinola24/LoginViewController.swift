//
//  LoginViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 17/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    var tituloLabel : UILabel?
    var backgroundTitulo: CAGradientLayer?
    var btnAtras : UIButton?
    var imagenBtnAtras : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        crearVistas()
        
    }
    // MARK: - Armando la interfaz
    
    func crearVistas()
    {
        crearTituloVista()
        crearBotonAtras()
    }
    
    func crearTituloVista()
    {
        backgroundTitulo = CAGradientLayer().rojoDegradado()
        backgroundTitulo!.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40)
        
        tituloLabel = UILabel()
        tituloLabel!.frame =  CGRect(x: 0,y: 20,width: self.view.frame.width , height: 40)
        
        tituloLabel!.text = "Ingrese"
        tituloLabel!.textColor = UIColor.whiteColor()
        tituloLabel!.textAlignment = NSTextAlignment.Center
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            tituloLabel!.font = UIFont(name: "Matura MT Script Capitals",size: 21)
            break
            
        case .Pad:
            tituloLabel!.font = UIFont(name: "Matura MT Script Capitals",size: 30)
            break
            
        default:
            break
        }
        
        self.view.layer.addSublayer(backgroundTitulo!)
        self.view.addSubview(tituloLabel!)
    }
    
    func crearBotonAtras()
    {
        btnAtras  = UIButton()
        btnAtras!.frame = CGRect(x: 10, y: 20 + (self.tituloLabel!.frame.height / 2) - 13, width: 24 , height: 26)
        imagenBtnAtras = UIImage(named : "flecha_atras")
        btnAtras!.setBackgroundImage(imagenBtnAtras, forState: UIControlState.Normal)
        btnAtras!.addTarget(nil, action: #selector(actionAtras), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(btnAtras!)
    }
    
    func eliminarVistas()
    {
        backgroundTitulo?.removeFromSuperlayer()
        tituloLabel?.removeFromSuperview()
        btnAtras?.removeFromSuperview()
        
        
        tituloLabel?.textColor = nil
        tituloLabel?.text = nil
        tituloLabel?.font = nil
        btnAtras?.setBackgroundImage(nil, forState: UIControlState.Normal)
        btnAtras?.removeTarget(nil, action: #selector(actionAtras), forControlEvents: .TouchUpInside)
        
        backgroundTitulo = nil
        tituloLabel = nil
        btnAtras = nil
        imagenBtnAtras = nil
        
        
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    

    deinit
    {
        debugPrint("Se va a dealloc loginview")
    }
    
    
    // MARK: - eventos Click
    
    
    func actionAtras(sender: AnyObject)
    {
        eliminarVistas()
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    

}
