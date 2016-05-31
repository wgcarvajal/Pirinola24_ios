//
//  RegistrarseViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 30/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

protocol ComunicacionLoginControllerRegistroController
{
    func seRegistro()
}

class RegistrarseViewController: UIViewController , UITextFieldDelegate{

    var tituloLabel : UILabel!
    var backgroundTitulo: CAGradientLayer!
    var btnAtras : UIButton!
    var imagenBtnAtras : UIImage!
    
    var contenidoheigth : CGFloat!
    var scrollview: UIScrollView!
    
    var imagenLogo : UIImage!
    var logoImageView : UIImageView!
    
    var backgroundNombreTextField: CAGradientLayer!
    var nombreTextField : UITextField!
    
    var backgroundCorreoTextField: CAGradientLayer!
    var correoTextField : UITextField!
    
    var backgroundClaveTextField: CAGradientLayer!
    var claveTextField : UITextField!
    
    var backgroundRepetirClaveTextField: CAGradientLayer!
    var repetirClaveTextField : UITextField!
    
    var backgroundButonRegistrarse : CAGradientLayer!
    var botonRegistrarse : UIButton!
    var imagenRegistrarse : UIImage!
    var iconoRegistrarse : UIImageView!
    
    var fondoTrasparenteAlertview : UIView!
    var presentWindow : UIWindow!
    
    var comunicacionLoginControllerRegistroController : ComunicacionLoginControllerRegistroController!

    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - logica de negocio
    
    func atras()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func registrarse()
    {
        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
        
        if nombreTextField.text!.isEmpty || correoTextField.text!.isEmpty  || claveTextField.text!.isEmpty || repetirClaveTextField.text!.isEmpty
        {
            
            self.view.makeToast(message: "Todos los campos son obligatorios.", duration: 2, position: HRToastPositionCenter)
        }
        else
        {
            if nombreTextField.text?.utf16.count < 3
            {
                self.view.makeToast(message: "Nombre mínimo tres caracteres.", duration: 2, position: HRToastPositionCenter)
            }
            else
            {
                if !isValidEmail(correoTextField.text!)
                {
                    self.view.makeToast(message: "Formato de correo electrónico no valido.", duration: 2, position: HRToastPositionCenter)
                }
                else
                {
                    if claveTextField.text?.utf16.count < 4
                    {
                        self.view.makeToast(message: "Clave entre 4 y 20 caracteres.", duration: 2, position: HRToastPositionCenter)
                    }
                    else
                    {
                        if claveTextField.text! != repetirClaveTextField.text!
                        {
                            self.view.makeToast(message: "Las claves no coinciden.", duration: 2, position: HRToastPositionCenter)
                        }
                        else
                        {
                            registroBackendless()
                        }
                    }
                }
            }
        }
        
    }
    
    func registroBackendless()
    {
        UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
        UIView.hr_setToastFontColor(color: UIColor.blackColor())
        presentWindow  = UIApplication.sharedApplication().keyWindow
        
        fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let user = BackendlessUser()
        user.email = correoTextField.text!
        user.password = claveTextField.text!
        user.name = nombreTextField.text!
        
        let backendless = Backendless.sharedInstance()
        self.view.addSubview(fondoTrasparenteAlertview)
        presentWindow.makeToastActivity(message: "Registrando ...")
        backendless.userService.registering(user,
                response: { (registeredUser : BackendlessUser!) -> () in
                    print("User has been registered (ASYNC): \(registeredUser)")
                    
                    self.presentWindow.hideToastActivity()
                    self.presentWindow = nil
                    self.fondoTrasparenteAlertview.removeFromSuperview()
                    self.fondoTrasparenteAlertview = nil
                    
                    self.comunicacionLoginControllerRegistroController.seRegistro()
                    self.atras()
                    
                    
            },
                error: { ( fault : Fault!) -> () in
                    print("Server reported an error: \(fault)")
                    
                    self.presentWindow.hideToastActivity()
                    self.presentWindow = nil
                    self.fondoTrasparenteAlertview.removeFromSuperview()
                    self.fondoTrasparenteAlertview = nil
                    
                    UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                    UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                    
                    if fault.faultCode == "3033"
                    {
                        self.view.makeToast(message: "Ya se encuentra el correo electrónico registrado.", duration: 2, position: HRToastPositionCenter)
                    }
                    else
                    {
                        self.view.makeToast(message: "Compruebe su conexión a internet.", duration: 2, position: HRToastPositionCenter)
                    }
            }
        )
    }
    
    // MARK: - eventos Click
    
    func actionAtras(sender: AnyObject)
    {
        atras()
        
    }
    
    func actionRegistrarse(sender: AnyObject)
    {
        registrarse()
    }
    
    
    // MARK: - funciones de interfaz grafica
    
    func crearVistas()
    {
        crearTituloVista()
        crearBotonAtras()
        crearScrollView()
        crearImagenLogo()
        crearCajaTextoNombre()
        crearCajaTextoCorreo()
        crearCajaTextoClave()
        crearCajaTextoRepetirClave()
        crearBotonRegistrarse()
        if contenidoheigth > scrollview.frame.height
        {
            scrollview.contentSize = CGSize(width: scrollview.frame.width, height: contenidoheigth)
        }
        else
        {
            scrollview.contentSize = CGSize(width: scrollview.frame.width, height: scrollview.frame.height)
        }
        self.view.addSubview(scrollview)
    }
    
    func crearTituloVista()
    {
        backgroundTitulo = CAGradientLayer().rojoDegradado()
        backgroundTitulo.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40)
        
        tituloLabel = UILabel()
        tituloLabel.frame =  CGRect(x: 0,y: 20,width: self.view.frame.width , height: 40)
        
        tituloLabel.text = "Registro"
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
    
    func crearScrollView()
    {
        
        scrollview = UIScrollView()
        scrollview.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60)
    }
    
    func crearImagenLogo()
    {
        contenidoheigth = scrollview.frame.height * 0.04
        imagenLogo = UIImage(named: "pirinola_icono")
        logoImageView = UIImageView()
        logoImageView.frame = CGRect(x: (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.2) / 2) , y: contenidoheigth , width: scrollview.frame.width * 0.2, height: scrollview.frame.width * 0.16)
        logoImageView.image = imagenLogo
        contenidoheigth = contenidoheigth + scrollview.frame.width * 0.16
        
        scrollview.addSubview(logoImageView!)
    }
    
    
    func crearCajaTextoNombre()
    {
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.04
        nombreTextField = UITextField()
        nombreTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        backgroundNombreTextField = CAGradientLayer().amarilloDegradado()
        backgroundNombreTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: scrollview.frame.height * 0.06)
        nombreTextField.layer.insertSublayer(backgroundNombreTextField, atIndex: 0)
        nombreTextField.textAlignment = NSTextAlignment.Center
        
        
        nombreTextField.textColor = UIColor.redColor()
        nombreTextField.keyboardType = UIKeyboardType.Alphabet
        
        nombreTextField.delegate = self
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Nombre", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            nombreTextField.attributedPlaceholder = placeholderCorreo
            nombreTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Nombre", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            nombreTextField.attributedPlaceholder = placeholderCorreo
            nombreTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview.addSubview(nombreTextField)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.06
        
    }
    
    func crearCajaTextoCorreo()
    {
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.04
        correoTextField = UITextField()
        correoTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        backgroundCorreoTextField = CAGradientLayer().amarilloDegradado()
        backgroundCorreoTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: scrollview.frame.height * 0.06)
        correoTextField.layer.insertSublayer(backgroundCorreoTextField, atIndex: 0)
        correoTextField.textAlignment = NSTextAlignment.Center
        
        
        correoTextField.textColor = UIColor.redColor()
        correoTextField.keyboardType = UIKeyboardType.EmailAddress
        
        correoTextField.delegate = self
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Correo electrónico", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            correoTextField.attributedPlaceholder = placeholderCorreo
            correoTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Correo electrónico", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            correoTextField.attributedPlaceholder = placeholderCorreo
            correoTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview.addSubview(correoTextField)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.06
        
    }
    
    func crearCajaTextoClave()
    {
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.04
        claveTextField = UITextField()
        claveTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        backgroundClaveTextField = CAGradientLayer().amarilloDegradado()
        backgroundClaveTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: scrollview.frame.height * 0.06)
        claveTextField.layer.insertSublayer(backgroundClaveTextField, atIndex: 0)
        claveTextField.textAlignment = NSTextAlignment.Center
        
        
        claveTextField.textColor = UIColor.redColor()
        claveTextField.keyboardType = UIKeyboardType.Alphabet
        
        claveTextField.secureTextEntry = true
        
        claveTextField.delegate = self
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Clave", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            claveTextField.attributedPlaceholder = placeholderCorreo
            claveTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Clave", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            claveTextField.attributedPlaceholder = placeholderCorreo
            claveTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview.addSubview(claveTextField)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.06
        
    }
    
    func crearCajaTextoRepetirClave()
    {
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.04
        repetirClaveTextField = UITextField()
        repetirClaveTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview!.frame.height * 0.06)
        
        backgroundRepetirClaveTextField = CAGradientLayer().amarilloDegradado()
        backgroundRepetirClaveTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: scrollview.frame.height * 0.06)
        repetirClaveTextField.layer.insertSublayer(backgroundRepetirClaveTextField, atIndex: 0)
        repetirClaveTextField.textAlignment = NSTextAlignment.Center
        
        
        repetirClaveTextField.textColor = UIColor.redColor()
        repetirClaveTextField.keyboardType = UIKeyboardType.Alphabet
        
        repetirClaveTextField.secureTextEntry = true
        
        repetirClaveTextField.delegate = self
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Repetir clave", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            repetirClaveTextField.attributedPlaceholder = placeholderCorreo
            repetirClaveTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Repetir clave", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            repetirClaveTextField.attributedPlaceholder = placeholderCorreo
            repetirClaveTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview.addSubview(repetirClaveTextField)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.06
        
    }
    
    func crearBotonRegistrarse()
    {
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.04
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        botonRegistrarse = UIButton()
        botonRegistrarse.frame = CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview.frame.height * 0.06)
        botonRegistrarse.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        botonRegistrarse.setTitle("Registrarse", forState: UIControlState.Normal)
        
        backgroundButonRegistrarse = CAGradientLayer().rojoDegradado()
        backgroundButonRegistrarse.frame = CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview.frame.height * 0.06)
        
        
        imagenRegistrarse = UIImage(named: "icono_add_user")
        iconoRegistrarse = UIImageView()
        iconoRegistrarse.frame = CGRect(x: botonRegistrarse.frame.width - (botonRegistrarse.frame.height * 0.7) - (botonRegistrarse.frame.height * 0.1), y: botonRegistrarse.frame.height * 0.15, width: botonRegistrarse.frame.height * 0.6, height: botonRegistrarse.frame.height * 0.6)
        iconoRegistrarse.image = imagenRegistrarse
        
        
        
        botonRegistrarse.addSubview(iconoRegistrarse!)
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            botonRegistrarse.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 14)
            break
            
        case .Pad:
            botonRegistrarse.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 24)
            break
            
        default:
            break
        }
        
        
        scrollview.layer.addSublayer(backgroundButonRegistrarse)
        
        botonRegistrarse.addTarget(nil, action: #selector(actionRegistrarse), forControlEvents: .TouchUpInside)
        scrollview.addSubview(botonRegistrarse!)
        self.contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.06
        
        
        
    }
    
    //MARK: - funciones textfield delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let limite = scrollview.frame.height - 250
        let posicionYfinalCajatexto = textField.frame.origin.y + textField.frame.height
        
        if posicionYfinalCajatexto > limite
        {
            scrollview.setContentOffset(CGPointMake(0, posicionYfinalCajatexto  - limite),animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollview.setContentOffset(CGPointMake(0, 0),animated: true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = (textField.text!.utf16).count + (string.utf16).count - range.length
        
        if textField == claveTextField || textField == repetirClaveTextField
        {
            return length <= 20
        }
        
        return length <= 70
        
    }
    
    //MARK: - funciones helper
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"+"[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }

    
    //MARK: - funcion dinit
    
    deinit
    {
        btnAtras.removeFromSuperview()
        backgroundTitulo.removeFromSuperlayer()
        tituloLabel.removeFromSuperview()
        
        logoImageView.removeFromSuperview()
        backgroundNombreTextField.removeFromSuperlayer()
        nombreTextField.removeFromSuperview()
        
        backgroundCorreoTextField.removeFromSuperlayer()
        correoTextField.removeFromSuperview()
        
        backgroundClaveTextField.removeFromSuperlayer()
        claveTextField.removeFromSuperview()
        
        backgroundRepetirClaveTextField.removeFromSuperlayer()
        repetirClaveTextField.removeFromSuperview()
        
        backgroundButonRegistrarse.removeFromSuperlayer()
        iconoRegistrarse.removeFromSuperview()
        botonRegistrarse.removeFromSuperview()
        
        backgroundNombreTextField = nil
        nombreTextField.delegate = nil
        nombreTextField = nil
        
        backgroundCorreoTextField = nil
        correoTextField.delegate = nil
        correoTextField = nil
        
        backgroundClaveTextField = nil
        claveTextField.delegate = nil
        claveTextField = nil
        
        backgroundRepetirClaveTextField = nil
        repetirClaveTextField.delegate = nil
        repetirClaveTextField = nil
        
        backgroundButonRegistrarse = nil
        imagenRegistrarse = nil
        iconoRegistrarse = nil
        botonRegistrarse = nil

        
        scrollview.removeFromSuperview()
        
        imagenBtnAtras = nil
        btnAtras = nil
        backgroundTitulo = nil
        tituloLabel = nil
        logoImageView = nil
        imagenLogo = nil
        
        contenidoheigth = nil
        

        scrollview = nil
        comunicacionLoginControllerRegistroController = nil
        self.view.removeFromSuperview()
        debugPrint("se va a dealloc registrarseViewController")
    }
    

}
