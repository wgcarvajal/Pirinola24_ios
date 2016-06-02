//
//  LoginViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 17/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

import FBSDKLoginKit

protocol ComunicacionPedidoControllerLoginController
{
    func seInicioSecion()
}

class LoginViewController: UIViewController ,UITextFieldDelegate , ComunicacionLoginControllerRegistroController
{
    var tituloLabel : UILabel?
    var backgroundTitulo: CAGradientLayer?
    var btnAtras : UIButton?
    var imagenBtnAtras : UIImage?
    
    var comunicacionPedidoControllerLoginController: ComunicacionPedidoControllerLoginController?
    
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

    
    var fondoTrasparenteAlertview : UIView!
    var enviarCorreoView : UIView!
    var correoEnviarCorreoTextField : UITextField!
    var backgroundCorreoEnviarCorreoTextField: CAGradientLayer!
    var aceptarEnviarCorreoBtn : UIButton!
    var backgroundAceptarEnviarCorreo: CAGradientLayer!
    var cancelarEnviarCorreoBtn : UIButton!
    var backgroundCancelarEnviarCorreo: CAGradientLayer!
    var presentWindow : UIWindow!
    
    let backendless = Backendless.sharedInstance()

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
    // MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "irRegistrarse"
        {
            let vc = segue.destinationViewController as! RegistrarseViewController
            vc.comunicacionLoginControllerRegistroController = self
        }
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
        crearBotonOlvidasteClave()
        crearBotonRegistrarse()
        crearBotonIniciarFacebook()
        crearBotonContinuarNoRegistrado()
        
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
            botonIniciarSession?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 14)
            break
            
        case .Pad:
            botonIniciarSession?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 24)
            break
            
        default:
            break
        }
        
       
        scrollview?.layer.addSublayer(backgroundButonIniciarSession!)
        
        botonIniciarSession!.addTarget(nil, action: #selector(actionIniciarSession), forControlEvents: .TouchUpInside)
        scrollview?.addSubview(botonIniciarSession!)
        self.contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.06
        
       
        
    }
    
    
    func crearBotonOlvidasteClave()
    {
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.03
        let puntoInicialX = (scrollview!.frame.width / 2) - ((scrollview!.frame.width * 0.6) / 2)
        botonOvildasteClave = UIButton()
        botonOvildasteClave?.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.6, height: scrollview!.frame.height * 0.04)
        botonOvildasteClave?.setTitleColor(UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), forState: UIControlState.Normal)
        botonOvildasteClave?.setTitle("¿Olvidaste tu clave?", forState: UIControlState.Normal)
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            botonOvildasteClave?.titleLabel?.font = UIFont(name: "Segoe Print", size: 10)
            break
            
        case .Pad:
            botonOvildasteClave?.titleLabel?.font = UIFont(name: "Segoe Print", size: 20)
            break
            
        default:
            break
        }
        
       
        
        botonOvildasteClave!.addTarget(nil, action: #selector(actionOlvidasteClave), forControlEvents: .TouchUpInside)
        scrollview?.addSubview(botonOvildasteClave!)
        self.contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.04
        
    }
    
    func crearBotonRegistrarse()
    {
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.04
        let puntoInicialX = (scrollview!.frame.width / 2) - ((scrollview!.frame.width * 0.9) / 2)
        botonRegistrarse = UIButton()
        botonRegistrarse?.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        botonRegistrarse?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        botonRegistrarse?.setTitle("Registrarse", forState: UIControlState.Normal)
        
        backgroundButonRegistrarse = CAGradientLayer().rojoDegradado()
        backgroundButonRegistrarse!.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        
        imagenRegistrarse = UIImage(named: "icono_add_user")
        iconoRegistrarse = UIImageView()
        iconoRegistrarse?.frame = CGRect(x: botonRegistrarse!.frame.width - (botonRegistrarse!.frame.height * 0.7) - (botonRegistrarse!.frame.height * 0.1), y: botonRegistrarse!.frame.height * 0.15, width: botonRegistrarse!.frame.height * 0.6, height: botonRegistrarse!.frame.height * 0.6)
        iconoRegistrarse?.image = imagenRegistrarse
        
        
        
        botonRegistrarse?.addSubview(iconoRegistrarse!)
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            botonRegistrarse?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 14)
            break
            
        case .Pad:
            botonRegistrarse?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 24)
            break
            
        default:
            break
        }
        
        
        scrollview?.layer.addSublayer(backgroundButonRegistrarse!)
        
        botonRegistrarse!.addTarget(nil, action: #selector(actionRegistrarse), forControlEvents: .TouchUpInside)
        scrollview?.addSubview(botonRegistrarse!)
        self.contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.06
        
        
        
    }
    
    func crearBotonIniciarFacebook()
    {
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.04
        let puntoInicialX = (scrollview!.frame.width / 2) - ((scrollview!.frame.width * 0.9) / 2)
        botonIniciarFacebook = UIButton()
        botonIniciarFacebook?.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        botonIniciarFacebook?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        botonIniciarFacebook?.setTitle("Autenticación con facebook", forState: UIControlState.Normal)
        
        backgroundButonIniciarFacebook = CAGradientLayer().rojoDegradado()
        backgroundButonIniciarFacebook!.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        
        imagenIniciarFacebook = UIImage(named: "icono_facebook")
        iconoIniciarFacebook = UIImageView()
        iconoIniciarFacebook?.frame = CGRect(x: botonIniciarFacebook!.frame.width - (botonIniciarFacebook!.frame.height * 0.7) - (botonIniciarFacebook!.frame.height * 0.1), y: botonIniciarFacebook!.frame.height * 0.15, width: botonIniciarFacebook!.frame.height * 0.6, height: botonIniciarFacebook!.frame.height * 0.6)
        iconoIniciarFacebook?.image = imagenIniciarFacebook
        
        
        
        botonIniciarFacebook?.addSubview(iconoIniciarFacebook!)
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            botonIniciarFacebook?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 14)
            break
            
        case .Pad:
            botonIniciarFacebook?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 24)
            break
            
        default:
            break
        }
        
        
        scrollview?.layer.addSublayer(backgroundButonIniciarFacebook!)
        
        botonIniciarFacebook!.addTarget(nil, action: #selector(actionIniciarFacebook), forControlEvents: .TouchUpInside)
        scrollview?.addSubview(botonIniciarFacebook!)
        self.contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.06
        
        
        
    }
    
    func crearBotonContinuarNoRegistrado()
    {
        contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.04
        let puntoInicialX = (scrollview!.frame.width / 2) - ((scrollview!.frame.width * 0.9) / 2)
        botonContinuarNoRegistrado = UIButton()
        botonContinuarNoRegistrado?.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        botonContinuarNoRegistrado?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        botonContinuarNoRegistrado?.setTitle("Continuar como no registrado", forState: UIControlState.Normal)
        
        backgroundButonContinuarNoRegistrado = CAGradientLayer().rojoDegradado()
        backgroundButonContinuarNoRegistrado!.frame = CGRect(x: puntoInicialX, y: contenidoheigth!, width: scrollview!.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        
        imagenContinuarNoRegistrado = UIImage(named: "icono_continuar_no_registrado")
        iconoContinuarNoRegistrado = UIImageView()
        iconoContinuarNoRegistrado?.frame = CGRect(x: botonContinuarNoRegistrado!.frame.width - (botonContinuarNoRegistrado!.frame.height * 0.7) - (botonContinuarNoRegistrado!.frame.height * 0.1), y: botonContinuarNoRegistrado!.frame.height * 0.15, width: botonContinuarNoRegistrado!.frame.height * 0.6, height: botonContinuarNoRegistrado!.frame.height * 0.6)
        iconoContinuarNoRegistrado?.image = imagenContinuarNoRegistrado
        
        
        
        botonContinuarNoRegistrado?.addSubview(iconoContinuarNoRegistrado!)
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            botonContinuarNoRegistrado?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 14)
            break
            
        case .Pad:
            botonContinuarNoRegistrado?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 24)
            break
            
        default:
            break
        }
        
        
        scrollview?.layer.addSublayer(backgroundButonContinuarNoRegistrado!)
        
        botonContinuarNoRegistrado!.addTarget(nil, action: #selector(actionContinuarNoRegistrado), forControlEvents: .TouchUpInside)
        scrollview?.addSubview(botonContinuarNoRegistrado!)
        self.contenidoheigth = self.contenidoheigth! + scrollview!.frame.height * 0.06
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
        
        backgroundButonIniciarSession?.removeFromSuperlayer()
        botonIniciarSession?.removeFromSuperview()
        botonIniciarSession?.removeTarget(nil, action: #selector(actionIniciarSession), forControlEvents: .TouchUpInside)
        iconoIniciarSession?.removeFromSuperview()
        iconoIniciarSession?.image = nil
        imagenIniciarSession = nil
        backgroundButonIniciarSession = nil
        botonIniciarSession = nil
        iconoIniciarSession=nil
        
        
        
        
        
        botonOvildasteClave?.removeFromSuperview()
        botonOvildasteClave?.removeTarget(nil, action: #selector(actionIniciarSession), forControlEvents: .TouchUpInside)
        
        botonOvildasteClave = nil
        
        backgroundButonRegistrarse?.removeFromSuperlayer()
        botonRegistrarse?.removeFromSuperview()
        botonRegistrarse?.removeTarget(nil, action: #selector(actionRegistrarse), forControlEvents: .TouchUpInside)
        iconoRegistrarse?.removeFromSuperview()
        iconoRegistrarse?.image = nil
        imagenRegistrarse = nil
        backgroundButonRegistrarse = nil
        botonRegistrarse = nil
        iconoRegistrarse=nil
        
        
        backgroundButonIniciarFacebook?.removeFromSuperlayer()
        botonIniciarFacebook?.removeFromSuperview()
        botonIniciarFacebook?.removeTarget(nil, action: #selector(actionIniciarFacebook), forControlEvents: .TouchUpInside)
        iconoIniciarFacebook?.removeFromSuperview()
        iconoIniciarFacebook?.image = nil
        imagenIniciarFacebook = nil
        backgroundButonIniciarFacebook = nil
        botonIniciarFacebook = nil
        iconoIniciarFacebook=nil
        
        backgroundButonContinuarNoRegistrado?.removeFromSuperlayer()
        botonContinuarNoRegistrado?.removeFromSuperview()
        botonContinuarNoRegistrado?.removeTarget(nil, action: #selector(actionContinuarNoRegistrado), forControlEvents: .TouchUpInside)
        iconoContinuarNoRegistrado?.removeFromSuperview()
        iconoContinuarNoRegistrado?.image = nil
        imagenContinuarNoRegistrado = nil
        backgroundButonContinuarNoRegistrado = nil
        botonContinuarNoRegistrado = nil
        iconoContinuarNoRegistrado=nil
        
        backgroundTitulo = nil
        tituloLabel = nil
        btnAtras = nil
        imagenBtnAtras = nil
        
        comunicacionPedidoControllerLoginController = nil
    }
    
    func abrirVentanaOlvidarClave()
    {
        fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        enviarCorreoView = UIView(frame: CGRect(x: 0, y: (self.view.frame.height / 2) - 20 - (self.view.frame.height * 0.2)/2, width: self.view.frame.width, height: self.view.frame.height * 0.2))
        
        
        enviarCorreoView.backgroundColor = UIColor.whiteColor()
        enviarCorreoView.layer.cornerRadius = enviarCorreoView.frame.height * 0.1
        
        correoEnviarCorreoTextField = UITextField()
        correoEnviarCorreoTextField.frame = CGRect(x: self.view.frame.width * 0.05, y: enviarCorreoView.frame.height * 0.15, width: self.view.frame.width * 0.9 , height: enviarCorreoView.frame.height * 0.3)
        
        backgroundCorreoEnviarCorreoTextField = CAGradientLayer().amarilloDegradado()
        backgroundCorreoEnviarCorreoTextField.frame = CGRect(x:0 , y: 0 , width: correoEnviarCorreoTextField.frame.width , height: correoEnviarCorreoTextField.frame.height)
        correoEnviarCorreoTextField.layer.insertSublayer(backgroundCorreoEnviarCorreoTextField, atIndex: 0)
        correoEnviarCorreoTextField.textAlignment = NSTextAlignment.Center
        
        
        correoEnviarCorreoTextField.textColor = UIColor.redColor()
        correoEnviarCorreoTextField.keyboardType = UIKeyboardType.EmailAddress
        
        correoEnviarCorreoTextField.delegate = self
        
        
        
        cancelarEnviarCorreoBtn = UIButton()
        cancelarEnviarCorreoBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: enviarCorreoView.frame.height * 0.25 + enviarCorreoView.frame.height * 0.3 , width: self.view.frame.width * 0.4 , height: enviarCorreoView.frame.height * 0.4)
        cancelarEnviarCorreoBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelarEnviarCorreoBtn.setTitle("Cancelar", forState: UIControlState.Normal)
        
        backgroundCancelarEnviarCorreo = CAGradientLayer().rojoDegradado()
        backgroundCancelarEnviarCorreo!.frame = CGRect(x: self.view.frame.width * 0.05, y: enviarCorreoView.frame.height * 0.25 + enviarCorreoView.frame.height * 0.3 , width: self.view.frame.width * 0.4 , height: enviarCorreoView.frame.height * 0.4)
        
        
        aceptarEnviarCorreoBtn = UIButton()
        aceptarEnviarCorreoBtn.frame = CGRect(x: self.view.frame.width * 0.15 + self.view.frame.width * 0.4 , y: enviarCorreoView.frame.height * 0.25 + enviarCorreoView.frame.height * 0.3 , width: self.view.frame.width * 0.4 , height: enviarCorreoView.frame.height * 0.4)
        aceptarEnviarCorreoBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        aceptarEnviarCorreoBtn.setTitle("Enviar", forState: UIControlState.Normal)
        
        backgroundAceptarEnviarCorreo = CAGradientLayer().rojoDegradado()
        backgroundAceptarEnviarCorreo!.frame = CGRect(x: self.view.frame.width * 0.15 + self.view.frame.width * 0.4 , y: enviarCorreoView.frame.height * 0.25 + enviarCorreoView.frame.height * 0.3 , width: self.view.frame.width * 0.4 , height: enviarCorreoView.frame.height * 0.4)
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Correo electrónico", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            correoEnviarCorreoTextField.attributedPlaceholder = placeholderCorreo
            correoEnviarCorreoTextField.font = UIFont(name: "Segoe Print",size: 12)
            cancelarEnviarCorreoBtn.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 14)
            
            aceptarEnviarCorreoBtn.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 14)
            
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Correo electrónico", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            correoEnviarCorreoTextField.attributedPlaceholder = placeholderCorreo
            correoEnviarCorreoTextField.font = UIFont(name: "Segoe Print",size: 22)
        
            cancelarEnviarCorreoBtn.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 24)
            aceptarEnviarCorreoBtn.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 24)
            break
            
        default:
            break
        }

        cancelarEnviarCorreoBtn.addTarget(nil, action: #selector(actionCancelarEnviarCorreo), forControlEvents: .TouchUpInside)
        
        aceptarEnviarCorreoBtn.addTarget(nil, action: #selector(actionAceptarEnviarCorreo), forControlEvents: .TouchUpInside)
        
        enviarCorreoView.layer.addSublayer(backgroundCancelarEnviarCorreo)
        enviarCorreoView.addSubview(cancelarEnviarCorreoBtn)
        enviarCorreoView.layer.addSublayer(backgroundAceptarEnviarCorreo)
        enviarCorreoView.addSubview(aceptarEnviarCorreoBtn)
        enviarCorreoView.addSubview(correoEnviarCorreoTextField)
        self.view.addSubview(fondoTrasparenteAlertview)
        self.view.addSubview(enviarCorreoView)
        
    }
    
    func cerrarVentanaEnviarCorreo()
    {
        enviarCorreoView.removeFromSuperview()
        fondoTrasparenteAlertview.removeFromSuperview()
        correoEnviarCorreoTextField.removeFromSuperview()
        aceptarEnviarCorreoBtn.removeFromSuperview()
        backgroundAceptarEnviarCorreo.removeFromSuperlayer()
        cancelarEnviarCorreoBtn.removeFromSuperview()
        backgroundCancelarEnviarCorreo.removeFromSuperlayer()
        
        backgroundCancelarEnviarCorreo = nil
        cancelarEnviarCorreoBtn = nil
        backgroundAceptarEnviarCorreo = nil
        aceptarEnviarCorreoBtn = nil
        correoEnviarCorreoTextField.delegate = nil
        correoEnviarCorreoTextField = nil
        fondoTrasparenteAlertview = nil
        enviarCorreoView = nil
        
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
    
    func actionCancelarEnviarCorreo(sender : AnyObject)
    {
        cerrarVentanaEnviarCorreo()
    }
    
    func actionAceptarEnviarCorreo(sender : AnyObject)
    {
        
        enviarCorreo()
        
    }
    
    func actionAtras(sender: AnyObject)
    {
       atras()
        
    }
    
    func actionIniciarSession(sender: AnyObject)
    {
        iniciarSesion()
    }
    
    func actionOlvidasteClave(sender: AnyObject)
    {
        abrirVentanaOlvidarClave()
    }
    
    func actionRegistrarse(sender: AnyObject)
    {
        irRegistrarse()
    }
    
    func actionIniciarFacebook(sender: AnyObject)
    {
        iniciarFacebook()
    }
    
    func actionContinuarNoRegistrado(sender : AnyObject)
    {
        irNoRegistrado()
    }
    
    // MARK: - fuciones texfield delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = (textField.text!.utf16).count + (string.utf16).count - range.length
        if textField == correoTextField || (correoEnviarCorreoTextField != nil && textField == correoEnviarCorreoTextField)
        {
            return length <= 100
        }
        
        return length <= 20
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    
    
    // MARK: - funciones logicaNegocio
    
    func iniciarFacebook()
    {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile","email"], fromViewController: self) { (result, error) -> Void in
            if (error == nil){
                
                if FBSDKAccessToken.currentAccessToken() != nil
                {
                    self.autenticacionFacebookBackendless()
                }
                
                
            }
        }
    }
    
    func autenticacionFacebookBackendless()
    {
        UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
        UIView.hr_setToastFontColor(color: UIColor.blackColor())
        presentWindow  = UIApplication.sharedApplication().keyWindow
        
        fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let backendless = Backendless.sharedInstance()
        let token = FBSDKAccessToken.currentAccessToken()
        let fieldsMapping = [
            "name": "name",
            "email": "emailFacebook"
        ]
        self.view.addSubview(fondoTrasparenteAlertview)
        presentWindow.makeToastActivity(message: "Iniciando ...")
        
        backendless.userService.loginWithFacebookSDK(
            token,
            fieldsMapping: fieldsMapping,
            response: { (user: BackendlessUser!) -> Void in
                print("user: \(user)")
                
                self.presentWindow.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertview.removeFromSuperview()
                self.fondoTrasparenteAlertview = nil
                self.comunicacionPedidoControllerLoginController?.seInicioSecion()
                backendless.userService.setStayLoggedIn(true)
                FBSDKLoginManager().logOut()
                self.atras()
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
                
                UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                self.presentWindow.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertview.removeFromSuperview()
                self.fondoTrasparenteAlertview = nil
                
                self.view.makeToast(message: "Compruebe su conexiòn a internet", duration: 2, position: HRToastPositionCenter)
                
                FBSDKLoginManager().logOut()
        })
    }
    
    func irRegistrarse()
    {
        self.performSegueWithIdentifier("irRegistrarse", sender: nil)
    }
    
    func irNoRegistrado()
    {
        self.performSegueWithIdentifier("irNoRegistrado", sender: nil)
    }
    
    func enviarCorreo()
    {
        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
        
        if correoEnviarCorreoTextField.text?.isEmpty == true
        {
            self.view.makeToast(message: "Ingrese correo", duration: 2, position: HRToastPositionCenter)
        }
        else
        {
            if !isValidEmail(correoEnviarCorreoTextField.text!)
            {
                self.view.makeToast(message: "Formato de correo electrónico no valido.", duration: 2, position: HRToastPositionCenter)
            }
            else
            {
                UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
                UIView.hr_setToastFontColor(color: UIColor.blackColor())
                presentWindow  = UIApplication.sharedApplication().keyWindow
                
                var backgroundCargandoEnviadoCorreo : UIView! = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                
                backgroundCargandoEnviadoCorreo!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                
                self.view.addSubview(backgroundCargandoEnviadoCorreo!)
                presentWindow.makeToastActivity(message: "Enviando ...")
                
                
                
                let backendless = Backendless.sharedInstance()
                
                backendless.userService.restorePassword( correoEnviarCorreoTextField.text,
                     response:{ ( result : AnyObject!) -> () in
                        print("Check your email address! result = \(result)")
                        
                        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                        
                        self.presentWindow.hideToastActivity()
                        self.presentWindow = nil
                        backgroundCargandoEnviadoCorreo!.removeFromSuperview()
                        backgroundCargandoEnviadoCorreo = nil
                        self.cerrarVentanaEnviarCorreo()
                        
                        self.view.makeToast(message: "Solicitud enviada, revise su correo electrónico.", duration: 2, position: HRToastPositionCenter)
                        
                    },
                      error: { ( fault : Fault!) -> () in
                        print("Server reported an error: \(fault)")
                        
                        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                        self.presentWindow.hideToastActivity()
                        self.presentWindow = nil
                        backgroundCargandoEnviadoCorreo!.removeFromSuperview()
                        backgroundCargandoEnviadoCorreo = nil
                        self.cerrarVentanaEnviarCorreo()
                        
                        if fault.faultCode == "3020"
                        {
                            
                            self.view.makeToast(message: "Correo no se encuentra registrado.", duration: 2, position: HRToastPositionCenter)
                        }
                        else
                        {
                            if fault.faultCode == "3075"
                            {
                                self.view.makeToast(message: "El correo electrónico se registro bajo la autenticación por facebook.", duration: 2, position: HRToastPositionCenter)
                            }
                            else
                            {
                                self.view.makeToast(message: "Compruebe su conexión a internet.", duration: 2, position: HRToastPositionCenter)
                            }
                        }
                    }
                )
            }
        }
    }
    
    func iniciarSesion()
    {
        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
        if correoTextField!.text!.isEmpty || claveTextField!.text!.isEmpty
        {
            self.view.makeToast(message: "Ingrese correo y clave.", duration: 2, position: HRToastPositionCenter)
        }
        else
        {
            if !isValidEmail(correoTextField!.text!)
            {
                self.view.makeToast(message: "Formato de correo electrónico no valido.", duration: 2, position: HRToastPositionCenter)
            }
            else
            {
                
                if claveTextField!.text!.utf16.count < 4
                {
                    self.view.makeToast(message: "clave entre 4 y 20 caracteres.", duration: 2, position: HRToastPositionCenter)
                }
                else
                {
                    UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
                    UIView.hr_setToastFontColor(color: UIColor.blackColor())
                    presentWindow  = UIApplication.sharedApplication().keyWindow
                    
                    fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    
                    fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                    
                    
                    let backendless = Backendless.sharedInstance()
                    
                    
                    self.view.addSubview(fondoTrasparenteAlertview)
                    presentWindow.makeToastActivity(message: "Iniciando ...")
                    backendless.userService.login(
                        correoTextField?.text, password: claveTextField?.text,
                        response: { ( user : BackendlessUser!) -> () in
                            
                            print("User has been logged in (ASYNC): \(user)")
                            self.presentWindow.hideToastActivity()
                            self.presentWindow = nil
                            self.fondoTrasparenteAlertview.removeFromSuperview()
                            self.fondoTrasparenteAlertview = nil
                            
                            backendless.userService.setStayLoggedIn(true)
                            self.comunicacionPedidoControllerLoginController?.seInicioSecion()
                            self.atras()                           
                            
                            
                        },
                        error: { ( fault : Fault!) -> () in
                            
                            UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                            UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                            self.presentWindow.hideToastActivity()
                            self.presentWindow = nil
                            self.fondoTrasparenteAlertview.removeFromSuperview()
                            self.fondoTrasparenteAlertview = nil
                            if fault.faultCode == "3003"
                            {
                                 self.view.makeToast(message: "Email o clave incorrectos.", duration: 2, position: HRToastPositionCenter)
                            }
                            else
                            {
                                if fault.faultCode == "3000"
                                {
                                    self.view.makeToast(message: "El correo electrónico se registro bajo la autenticación por facebook", duration: 2, position: HRToastPositionCenter)
                                }
                                else
                                {
                                    self.view.makeToast(message: "Compruebe su conexiòn a internet", duration: 2, position: HRToastPositionCenter)
                                }
                            }
                        }
                    )
                }
                
            }
        }
        
    }
    
    func atras()
    {
        eliminarVistas()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - funciones helpers
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"+"[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    // MARK: - funciones comunicacionRegistroController
    
    func seRegistro()
    {
        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
        
        self.view.makeToast(message: "Gracias por registrarse, ya puedes iniciar sesión con tu cuenta.", duration: 4, position: HRToastPositionCenter)
    }
    
   

}
