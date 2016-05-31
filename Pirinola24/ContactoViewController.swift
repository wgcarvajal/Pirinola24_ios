//
//  ContactoViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 13/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class ContactoViewController: UIViewController , UITextFieldDelegate , UITextViewDelegate{
    
    
    var contactenosLabel: UILabel!
    var botonAtras: UIButton!
    var background : CAGradientLayer!
    var backgroundButonEnviar: CAGradientLayer!
    var backgroundCorreoTextField: CAGradientLayer!
    var backgroundNombreTextField : CAGradientLayer!
    var backgroundMensajeTextView : CAGradientLayer!
    var scrollview: UIScrollView!
    var logoImageView : UIImageView!
    var correoTextField : UITextField!
    var nombreTextField : UITextField!
    var mensajeTextView : UITextView!
    var contenidoheigth : CGFloat!
    var placeholderMensajeTextField : UILabel!
    var botonEnviar : UIButton!
    var imagenLogo : UIImage!
    
    var fondoTrasparenteAlertview : UIView!
    
    var presentWindow : UIWindow!
    
    var tuopinionLabel : UILabel!
    
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
        
        crearVistaAsyncronicamente()
        
        
        // Do any additional setup after loading the view.
    }
    
    func crearVistaAsyncronicamente()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            dispatch_async(dispatch_get_main_queue())
            {
               self.crearVista()
            }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func actionAtras(sender: AnyObject)
    {
        
        volverAtras()
    }
    
    // MARK: - Logica de negocio
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"+"[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        return result
    }
    
    func volverAtras()
    {
        
        if(AppUtil.contadorUpdateCollectionview > 0)
        {
            AppUtil.contadorUpdateCollectionview += 1
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func crearVista()
    {
        crearTituloPagina()
        crearBotonAtras()
        crearScrollView()
        crearImagenLogo()
        crearLabel()
        crearCajaTextoCorreo()
        crearCajaTextoNombre()
        crearCajaTextoMensaje()
        crearBotonEnviar()
        agregarVistas()
    }
    
    func crearTituloPagina()
    {
        contactenosLabel = UILabel()
        contactenosLabel.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40)
        contactenosLabel.text = "Contáctenos"
        contactenosLabel.textColor = UIColor.whiteColor()
        contactenosLabel.textAlignment = NSTextAlignment.Center
        background = CAGradientLayer().rojoDegradado()
        
        background.frame = CGRect(x:0, y: 20, width: self.view.frame.width, height: contactenosLabel!.frame.height)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            contactenosLabel.font = UIFont(name: "Matura MT Script Capitals",size: 21)
            break
            
        case .Pad:
            contactenosLabel.font = UIFont(name: "Matura MT Script Capitals",size: 30)
            break
            
        default:
            break
        }
        
    }
    
    func crearBotonAtras()
    {
        botonAtras  = UIButton()
        botonAtras.frame = CGRect(x: 10, y: 20 + (self.contactenosLabel!.frame.height / 2) - 13, width: 24 , height: 26)
        botonAtras.setBackgroundImage(UIImage(named : "flecha_atras"), forState: UIControlState.Normal)
        botonAtras.addTarget(nil, action: #selector(actionAtras), forControlEvents: .TouchUpInside)
    }
    func crearImagenLogo()
    {
        contenidoheigth = scrollview.frame.height * 0.04
        imagenLogo = UIImage(named: "pirinola_icono")
        logoImageView = UIImageView()
        logoImageView.frame = CGRect(x: (scrollview!.frame.width / 2) - ((scrollview.frame.width * 0.25) / 2) , y: contenidoheigth , width: scrollview.frame.width * 0.25, height: scrollview.frame.width * 0.2)
        logoImageView.image = imagenLogo
        contenidoheigth = contenidoheigth + scrollview.frame.width * 0.2
    }
    func crearLabel()
    {
        contenidoheigth =  self.contenidoheigth + scrollview.frame.height * 0.04
        tuopinionLabel = UILabel()
        tuopinionLabel!.frame = CGRect(x: (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2), y: self.contenidoheigth, width: (scrollview.frame.width * 0.9), height: scrollview.frame.height * 0.04)
        
        
        tuopinionLabel.textAlignment = NSTextAlignment.Center
        
        tuopinionLabel.text = "Tú opinión es muy importante para nosotros."
        tuopinionLabel.textColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        
        contenidoheigth =  self.contenidoheigth + scrollview!.frame.height * 0.04
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            tuopinionLabel.font = UIFont(name: "Segoe Print", size: 12)
            break
            
        case .Pad:
            tuopinionLabel.font = UIFont(name: "Segoe Print", size: 22)
            break
            
        default:
            break
        }
    }
    
    func crearCajaTextoCorreo()
    {
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.04
        correoTextField = UITextField()
        correoTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview.frame.height * 0.06)
        
        backgroundCorreoTextField = CAGradientLayer().amarilloDegradado()
        backgroundCorreoTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: scrollview.frame.height * 0.06)
        correoTextField.layer.insertSublayer(backgroundCorreoTextField, atIndex: 0)
        correoTextField.textAlignment = NSTextAlignment.Center
        
        
        correoTextField.textColor = UIColor.redColor()
        correoTextField.keyboardType = UIKeyboardType.EmailAddress
        
        correoTextField.delegate = self
        
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.06
        
        
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
    }
    
    func crearCajaTextoNombre()
    {
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        contenidoheigth = contenidoheigth + scrollview.frame.height * 0.04
        
        nombreTextField = UITextField()
        nombreTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth , width: scrollview.frame.width * 0.9, height: scrollview.frame.height * 0.06)
        backgroundNombreTextField = CAGradientLayer().amarilloDegradado()
        backgroundNombreTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: scrollview.frame.height * 0.06)
        nombreTextField.layer.insertSublayer(backgroundNombreTextField, atIndex: 0)
        nombreTextField.textAlignment = NSTextAlignment.Center
        
        
        nombreTextField.textColor = UIColor.redColor()
        
        nombreTextField.keyboardType = UIKeyboardType.Alphabet
        nombreTextField.delegate = self
        contenidoheigth = contenidoheigth + scrollview.frame.height * 0.06
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderNombre = NSAttributedString(string: "Nombre", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            nombreTextField.attributedPlaceholder = placeholderNombre
            nombreTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderNombre = NSAttributedString(string: "Nombre", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            nombreTextField.attributedPlaceholder = placeholderNombre
            nombreTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
    }
    
    func crearCajaTextoMensaje()
    {
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        contenidoheigth = contenidoheigth + scrollview.frame.height * 0.04
        mensajeTextView = UITextView()
        mensajeTextView.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview.frame.height * 0.2)
        
        mensajeTextView.contentSize.height = scrollview!.frame.height * 0.2
        
        backgroundMensajeTextView = CAGradientLayer().amarilloDegradado()
        backgroundMensajeTextView.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: scrollview.frame.height * 0.2 * 2)
        mensajeTextView.layer.insertSublayer(backgroundMensajeTextView, atIndex: 0)
        mensajeTextView.textAlignment = NSTextAlignment.Center
        
        mensajeTextView.textColor = UIColor.redColor()
        mensajeTextView.delegate = self
        
        
        placeholderMensajeTextField = UILabel()
        placeholderMensajeTextField.frame = CGRect(x: 0, y: 10, width: mensajeTextView.frame.width, height: mensajeTextView.frame.height * 0.1)
        
        
        placeholderMensajeTextField.textAlignment = NSTextAlignment.Center
        placeholderMensajeTextField.textColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        placeholderMensajeTextField.text = "Mensaje"
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            mensajeTextView.font = UIFont(name: "Segoe Print",size: 12)
            placeholderMensajeTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            mensajeTextView.font = UIFont(name: "Segoe Print",size: 22)
            placeholderMensajeTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        mensajeTextView.scrollToBotom()
        mensajeTextView.addSubview(self.placeholderMensajeTextField)
        contenidoheigth = contenidoheigth + scrollview.frame.height * 0.2
        
        
        
    }
    
    func crearBotonEnviar()
    {
        contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.04
        let puntoInicialX = (scrollview.frame.width / 2) - ((scrollview.frame.width * 0.9) / 2)
        botonEnviar = UIButton()
        botonEnviar.frame = CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview.frame.height * 0.06)
        botonEnviar.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        botonEnviar.setTitle("Enviar", forState: UIControlState.Normal)
        
        backgroundButonEnviar = CAGradientLayer().rojoDegradado()
        backgroundButonEnviar.frame = CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: scrollview.frame.height * 0.06)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            botonEnviar.titleLabel!.font = UIFont(name: "Matura MT Script Capitals", size: 12)
            break
            
        case .Pad:
            botonEnviar.titleLabel!.font = UIFont(name: "Matura MT Script Capitals", size: 22)
            break
            
        default:
            break
        }
        self.contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.06
        
        botonEnviar.addTarget(nil, action: #selector(actionEnviar), forControlEvents: .TouchUpInside)
        
    }
    
    func crearScrollView()
    {
        
        scrollview = UIScrollView()
        scrollview.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60)
    }
    
    
    
    func agregarVistas()
    {
        view.addSubview(contactenosLabel)
        view.layer.insertSublayer(background, atIndex: 0)
        view.addSubview(botonAtras)
        scrollview.addSubview(logoImageView)
        scrollview.addSubview(tuopinionLabel)
        scrollview.addSubview(correoTextField)
        scrollview.addSubview(nombreTextField)
        scrollview.addSubview(mensajeTextView)
        scrollview.layer.insertSublayer(backgroundButonEnviar , atIndex: 0)
        scrollview.addSubview(botonEnviar)
        
        if contenidoheigth > scrollview.frame.height
        {
            scrollview.contentSize = CGSize(width: self.view.frame.width, height: contenidoheigth)
        }
        else
        {
            scrollview.contentSize = CGSize(width: self.view.frame.width, height: scrollview.frame.height)
        }
        
        view.addSubview(scrollview)
        
    }
    
    func actionEnviar(sender: AnyObject)
    {
        correoTextField.resignFirstResponder()
        nombreTextField.resignFirstResponder()
        scrollview.setContentOffset(CGPointMake(0,0), animated: true)
        comprobarCampos()
        
    }
    
    func comprobarCampos()
    {
        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
        
        
        
        if nombreTextField.text!.isEmpty || correoTextField.text!.isEmpty || mensajeTextView.text!.isEmpty
        {
            self.view.makeToast(message: "Todos los campos son obligatorios", duration: 2, position: HRToastPositionCenter)
        }
        else
        {
            if !isValidEmail(correoTextField.text!)
            {
                self.view.makeToast(message: "Formato de correo electrónico no valido", duration: 2, position: HRToastPositionCenter)
            }
            else
            {
                UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
                UIView.hr_setToastFontColor(color: UIColor.blackColor())
                presentWindow  = UIApplication.sharedApplication().keyWindow
                
                fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                
                fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                
                let contacto = Contacto();
                contacto.email = correoTextField.text
                contacto.nombre = nombreTextField.text
                contacto.mensaje = mensajeTextView.text
                
                let backendless = Backendless.sharedInstance()
                self.view.addSubview(fondoTrasparenteAlertview)
                presentWindow.makeToastActivity(message: "Enviando ...")
                backendless.persistenceService.of(Contacto.ofClass()).save(contacto,response:{ (result: AnyObject!) -> Void in
                    
                    self.presentWindow.hideToastActivity()
                    self.presentWindow = nil
                    self.fondoTrasparenteAlertview.removeFromSuperview()
                    self.fondoTrasparenteAlertview = nil
                    UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                    UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                    
                    self.nombreTextField.text = ""
                    self.correoTextField.text = ""
                    self.mensajeTextView.text = ""
                    self.placeholderMensajeTextField.hidden = false
                    self.view.makeToast(message: "Mensaje enviado", duration: 2, position: HRToastPositionCenter)
                    
                    
                    
                    },
                                                                           error: { (fault: Fault!) -> Void in
                                                                            
                                                                            self.presentWindow.hideToastActivity()
                                                                            self.presentWindow = nil
                                                                            self.fondoTrasparenteAlertview.removeFromSuperview()
                                                                            self.fondoTrasparenteAlertview = nil
                                                                            UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                                                                            UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                                                                            
                                                                            self.view.makeToast(message: "Compruebe su conexión a internet..", duration: 2, position: HRToastPositionCenter)
                })
                
            }
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //MARK: - funciones TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
        if textField == nombreTextField
        {
            
            
            let desplazamientoY = nombreTextField.frame.height + 20
            scrollview.setContentOffset(CGPointMake(0, desplazamientoY),animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollview.setContentOffset(CGPointMake(0, 0),animated: true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = (textField.text!.utf16).count + (string.utf16).count - range.length
        
        return length <= 50
        
    }
    
    //MARK: - funciones TextView Delegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return true
        }
        
        let length = (textView.text!.utf16).count + (text.utf16).count - range.length
        
        return length <= 200
        
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        let desplazamientoY = 250 - ((self.scrollview.frame.height) - self.contenidoheigth)
        scrollview.setContentOffset(CGPointMake(0, desplazamientoY),animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        scrollview.setContentOffset(CGPointMake(0, 0),animated: true)
        
    }
    
    func textViewDidChange(textView: UITextView)
    {
        let espacing = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        if !mensajeTextView.text.stringByTrimmingCharactersInSet(espacing).isEmpty
        {
            placeholderMensajeTextField.hidden = true
        }
        else
        {
            placeholderMensajeTextField.hidden = false
        }
        
        
    }
    
    
    deinit
    {
        self.correoTextField.delegate = nil
        self.nombreTextField.delegate = nil
        self.mensajeTextView.delegate = nil
        self.botonAtras.removeFromSuperview()
        self.contactenosLabel.removeFromSuperview()
        self.background.removeFromSuperlayer()
        self.backgroundButonEnviar.removeFromSuperlayer()
        self.backgroundCorreoTextField.removeFromSuperlayer()
        self.backgroundNombreTextField.removeFromSuperlayer()
        self.backgroundMensajeTextView.removeFromSuperlayer()
        self.scrollview.removeFromSuperview()
        self.logoImageView.removeFromSuperview()
        self.correoTextField.removeFromSuperview()
        self.nombreTextField.removeFromSuperview()
        self.mensajeTextView.removeFromSuperview()
        self.tuopinionLabel.removeFromSuperview()
        self.botonEnviar.removeFromSuperview()
        
        self.botonAtras = nil
        self.contactenosLabel = nil
        self.background = nil
        self.backgroundMensajeTextView = nil
        self.backgroundNombreTextField = nil
        self.backgroundCorreoTextField = nil
        self.backgroundButonEnviar = nil
        self.logoImageView = nil
        self.imagenLogo = nil
        self.nombreTextField = nil
        self.mensajeTextView = nil
        self.contenidoheigth = nil
        self.tuopinionLabel = nil
        self.botonEnviar = nil
        self.scrollview = nil
        
        self.view.removeFromSuperview()

        debugPrint("se va a dealloc contactoViewController")
    }
    
}
