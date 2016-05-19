//
//  LoginViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 17/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController ,UITextFieldDelegate
{
    var tituloLabel : UILabel?
    var backgroundTitulo: CAGradientLayer?
    var btnAtras : UIButton?
    var imagenBtnAtras : UIImage?
    
    
    var background : CAGradientLayer?
    var backgroundButonIniciarSession: CAGradientLayer?
    var backgroundCorreoTextField: CAGradientLayer?
    var backgroundClaveTextField : CAGradientLayer?
    var backgroundButonRegistrarse : CAGradientLayer?
    var backgroundButonIniciarFacebook : CAGradientLayer?
    var backgroundButonContinuarNoRegistrado : CAGradientLayer?
    var scrollview: UIScrollView?
    var imagenLogo : UIImage?
    var logoImageView : UIImageView?
    var correoTextField : UITextField?
    var claveTextField : UITextField?
    var contenidoheigth : CGFloat?
    
    var botonIniciarSession : UIButton?
    var botonRegistrarse : UIButton?
    var botonIniciarFacebook : UIButton?
    var botonContinuarNoRegistrado : UIButton?
    var botonOvildasteClave : UIButton?
    
    var imagenIniciarSession : UIImage?
    var imagenRegistrarse : UIImage?
    var imagenIniciarFacebook : UIImage?
    var imagenContinuarNoRegistrado : UIImage?
    var imagenCorreo : UIImage?
    var imagenClave : UIImage?
    
    var iconoIniciarSession : UIImageView?
    var iconoRegistrarse : UIImageView?
    var iconoIniciarFacebook : UIImageView?
    var iconoContinuarNoRegistrado : UIImageView?
    var iconoCorreo : UIImageView?
    var iconoClave : UIImageView?

    
    
    

    override func viewDidLoad() {
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
    // MARK: - Armando la interfaz
    
    func crearVistas()
    {
        crearTituloVista()
        crearBotonAtras()
        crearScrollView()
        crearImagenLogo()
        crearCajaTextoCorreo()
        crearCajaTextoClave()
        crearBotonIniciarSesion()
        
        self.view.addSubview(scrollview!)
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
    
    
    func crearScrollView()
    {
        
        scrollview = UIScrollView()
        scrollview!.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60)
    }
    
    func crearImagenLogo()
    {
        contenidoheigth = scrollview!.frame.height * 0.04
        imagenLogo = UIImage(named: "pirinola_icono")
        logoImageView = UIImageView()
        logoImageView?.frame = CGRect(x: (scrollview!.frame.width / 2) - ((scrollview!.frame.width * 0.2) / 2) , y: contenidoheigth! , width: scrollview!.frame.width * 0.2, height: scrollview!.frame.width * 0.16)
        logoImageView?.image = imagenLogo
        contenidoheigth = contenidoheigth! + scrollview!.frame.width * 0.16
        
        scrollview?.addSubview(logoImageView!)
    }
    
    
    func crearCajaTextoCorreo()
    {
        let puntoInicialX = (scrollview!.frame.width / 2) - ((scrollview!.frame.width * 0.9) / 2)
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.04
        correoTextField = UITextField()
        correoTextField!.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        backgroundCorreoTextField = CAGradientLayer().amarilloDegradado()
        backgroundCorreoTextField!.frame = CGRect(x:0 , y: 0 , width: scrollview!.frame.width * 0.9 , height: scrollview!.frame.height * 0.06)
        correoTextField!.layer.insertSublayer(backgroundCorreoTextField!, atIndex: 0)
        correoTextField!.textAlignment = NSTextAlignment.Center
        
        
        correoTextField!.textColor = UIColor.redColor()
        correoTextField!.keyboardType = UIKeyboardType.EmailAddress
        
        correoTextField!.delegate = self
        
        
        
        
        imagenCorreo = UIImage(named: "icono_usuario")
        iconoCorreo = UIImageView()
        iconoCorreo?.frame = CGRect(x: correoTextField!.frame.width - (correoTextField!.frame.height * 0.7) - (correoTextField!.frame.height * 0.1), y: correoTextField!.frame.height * 0.15, width: correoTextField!.frame.height * 0.6, height: correoTextField!.frame.height * 0.6)
        iconoCorreo?.image = imagenCorreo
        
        correoTextField?.addSubview(iconoCorreo!)
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Correo electrónico", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            correoTextField!.attributedPlaceholder = placeholderCorreo
            correoTextField!.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Correo electrónico", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            correoTextField!.attributedPlaceholder = placeholderCorreo
            correoTextField!.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview?.addSubview(correoTextField!)
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.06
        
    }
    
    func crearCajaTextoClave()
    {
        let puntoInicialX = (scrollview!.frame.width / 2) - ((scrollview!.frame.width * 0.9) / 2)
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.02
        claveTextField = UITextField()
        claveTextField!.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        backgroundClaveTextField = CAGradientLayer().amarilloDegradado()
        backgroundClaveTextField!.frame = CGRect(x:0 , y: 0 , width: scrollview!.frame.width * 0.9 , height: scrollview!.frame.height * 0.06)
        claveTextField!.layer.insertSublayer(backgroundClaveTextField!, atIndex: 0)
        claveTextField!.textAlignment = NSTextAlignment.Center
        
        
        claveTextField!.textColor = UIColor.redColor()
        claveTextField!.keyboardType = UIKeyboardType.Alphabet
        
        claveTextField!.delegate = self
        
        
        claveTextField?.secureTextEntry = true
        
        imagenClave = UIImage(named: "icono_password")
        iconoClave = UIImageView()
        iconoClave?.frame = CGRect(x: claveTextField!.frame.width - (claveTextField!.frame.height * 0.7) - (claveTextField!.frame.height * 0.1), y: claveTextField!.frame.height * 0.15, width: claveTextField!.frame.height * 0.6, height: claveTextField!.frame.height * 0.6)
        iconoClave?.image = imagenClave
        
        claveTextField?.addSubview(iconoClave!)
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderClave = NSAttributedString(string: "Clave", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            claveTextField!.attributedPlaceholder = placeholderClave
            claveTextField!.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderClave = NSAttributedString(string: "Clave", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            claveTextField!.attributedPlaceholder = placeholderClave
            claveTextField!.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview?.addSubview(claveTextField!)
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.06
        
    }
    
    func crearBotonIniciarSesion()
    {
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.04
        let puntoInicialX = (scrollview!.frame.width / 2) - ((scrollview!.frame.width * 0.9) / 2)
        botonIniciarSession = UIButton()
        botonIniciarSession?.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        botonIniciarSession?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        botonIniciarSession?.setTitle("Iniciar Sesión", forState: UIControlState.Normal)
        
        backgroundButonIniciarSession = CAGradientLayer().rojoDegradado()
        backgroundButonIniciarSession!.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        
        imagenIniciarSession = UIImage(named: "icono_ok")
        iconoIniciarSession = UIImageView()
        iconoIniciarSession?.frame = CGRect(x: botonIniciarSession!.frame.width - (botonIniciarSession!.frame.height * 0.7) - (botonIniciarSession!.frame.height * 0.1), y: botonIniciarSession!.frame.height * 0.15, width: botonIniciarSession!.frame.height * 0.6, height: botonIniciarSession!.frame.height * 0.6)
        iconoIniciarSession?.image = imagenIniciarSession
        
        botonIniciarSession?.addSubview(iconoIniciarSession!)
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            botonIniciarSession?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 12)
            break
            
        case .Pad:
            botonIniciarSession?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 22)
            break
            
        default:
            break
        }
        
       
        scrollview?.layer.addSublayer(backgroundButonIniciarSession!)
        scrollview?.addSubview(botonIniciarSession!)
        self.contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.06
        
        //botonIniciarSession!.addTarget(nil, action: #selector(actionEnviar), forControlEvents: .TouchUpInside)
        
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
        logoImageView?.removeFromSuperview()
        logoImageView?.image = nil
        logoImageView = nil
        correoTextField?.removeFromSuperview()
        correoTextField?.delegate = nil
        backgroundCorreoTextField?.removeFromSuperlayer()
        iconoCorreo?.removeFromSuperview()
        iconoCorreo?.image = nil
        imagenCorreo = nil
        iconoCorreo = nil
        backgroundCorreoTextField = nil
        correoTextField = nil
        
        
        claveTextField?.removeFromSuperview()
        claveTextField?.delegate = nil
        backgroundClaveTextField?.removeFromSuperlayer()
        iconoClave?.removeFromSuperview()
        iconoClave?.image = nil
        imagenClave = nil
        iconoClave = nil
        backgroundClaveTextField = nil
        claveTextField = nil
        
        
        
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
    
    // MARK: - fuciones texfield delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = (textField.text!.utf16).count + (string.utf16).count - range.length
        if(textField == correoTextField)
        {
            return length <= 100
        }
        
        return length <= 20
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    
    
    

}
