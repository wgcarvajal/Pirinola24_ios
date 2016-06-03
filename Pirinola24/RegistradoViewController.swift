//
//  RegistradoViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 1/06/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class RegistradoViewController: UIViewController
{
    var tituloLabel : UILabel!
    var backgroundTitulo: CAGradientLayer!
    var btnAtras : UIButton!
    var imagenBtnAtras : UIImage!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            HRToastFontSize = 12.0
            break
            
        case .Pad:
            HRToastFontSize = 20.0
            break
            
        default:
            break
        }
        
        crearVistas()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

    
    // MARK: - funciones de interfaz grafica
    
    func crearVistas()
    {
        crearTituloVista()
        crearBotonAtras()
        
    }
    
    func crearTituloVista()
    {
        backgroundTitulo = CAGradientLayer().rojoDegradado()
        backgroundTitulo.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40)
        
        tituloLabel = UILabel()
        tituloLabel.frame =  CGRect(x: 0,y: 20,width: self.view.frame.width , height: 40)
        
        tituloLabel.text = "Lista de ciudades"
        tituloLabel.textColor = UIColor.whiteColor()
        tituloLabel.textAlignment = NSTextAlignment.Center
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            tituloLabel.font = UIFont(name: "Matura MT Script Capitals",size: 21)
            break
            
        case .Pad:
            tituloLabel.font = UIFont(name: "Matura MT Script Capitals",size: 30)
            break
            
        default:
            break
        }
        
        self.view.layer.addSublayer(backgroundTitulo)
        self.view.addSubview(tituloLabel)
    }
    
    func crearBotonAtras()
    {
        btnAtras  = UIButton()
        btnAtras.frame = CGRect(x: 10, y: 20 + (self.tituloLabel.frame.height / 2) - 13, width: 24 , height: 26)
        imagenBtnAtras = UIImage(named : "flecha_atras")
        btnAtras.setBackgroundImage(imagenBtnAtras, forState: UIControlState.Normal)
        btnAtras.addTarget(nil, action: #selector(actionAtras), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(btnAtras!)
    }
    
    
    // MARK: - eventos Click
    
    func actionAtras(sender: AnyObject)
    {
        atras()
        
    }
    
    // MARK: - logica de negocio
    
    func atras()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - funcion dinit
    
    deinit
    {
        btnAtras.removeFromSuperview()
        backgroundTitulo.removeFromSuperlayer()
        tituloLabel.removeFromSuperview()
        
        
        
        imagenBtnAtras = nil
        btnAtras = nil
        backgroundTitulo = nil
        tituloLabel = nil
        self.view.removeFromSuperview()
        debugPrint("se va a dealloc registradoViewController")
    }

}
