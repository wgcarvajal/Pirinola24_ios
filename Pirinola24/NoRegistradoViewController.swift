//
//  NoRegistradoViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 1/06/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

protocol ComunicacionLoginControllerNoRegistradoController
{
    func seRealizoPedido()
}

class NoRegistradoViewController: UIViewController , DKDropMenuDelegate , UITextFieldDelegate , UITextViewDelegate
{
    var fondoTrasparenteAlertview : UIView!
    var presentWindow : UIWindow!

    var tituloLabel : UILabel!
    var backgroundTitulo: CAGradientLayer!
    var btnAtras : UIButton!
    var imagenBtnAtras : UIImage!
    var imagenLogo : UIImage!
    var logoImageView : UIImageView!
    
    var backgroundSpinnerCiudad : CAGradientLayer!
    var spinnerCiudad : DKDropMenu!
    var imagenSpinnerCiudad : UIImage!
    var iconoSpinnerCiudad : UIImageView!
    
    var backgroundNombreTextField: CAGradientLayer!
    var nombreTextField : UITextField!
    
    var backgroundDireccionTextField: CAGradientLayer!
    var direccionTextField : UITextField!
    
    var backgroundBarrioTextField: CAGradientLayer!
    var barrioTextField : UITextField!
    
    var backgroundTelefonoTextField: CAGradientLayer!
    var telefonoTextField : UITextField!
    
    
    var backgroundSpinnerFormaPago : CAGradientLayer!
    var spinnerFormaPago : DKDropMenu!
    var imagenSpinnerFormaPago : UIImage!
    var iconoSpinnerFormaPago : UIImageView!
    
    
    var backgroundObservacionesTextView : CAGradientLayer!
    var observacionesTextView : UITextView!
    var placeholderObservacionesTextField : UILabel!
    
    var backgroundButonEnviarPedido : CAGradientLayer!
    var botonEnviarPedido : UIButton!
    
    var listaCiudades : Array<Ciudad>!
    var listaFormaPago : Array<Formapago>!
    
    var scrollview: UIScrollView!
    
    var contenidoheigth : CGFloat!
    
    
    var mensajeCompruebeConexionLabel : UILabel!
    var backgroundVolverCargarVistaBtn : CAGradientLayer!
    var volverCargarVistaBtn : UIButton!
    
    
    var comunicacionLoginControllerNoRegistradoController:ComunicacionLoginControllerNoRegistradoController!
    let backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func viewWillAppear(animated: Bool) {
        cargarCiudadesBackendless()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        crearImagenLogo()
        
        
    }
    
    func crearTituloVista()
    {
        backgroundTitulo = CAGradientLayer().rojoDegradado()
        backgroundTitulo.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40)
        
        tituloLabel = UILabel()
        tituloLabel.frame =  CGRect(x: 0,y: 20,width: self.view.frame.width , height: 40)
        
        tituloLabel.text = "Formulario de envio"
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
    
    func crearImagenLogo()
    {
        
        imagenLogo = UIImage(named: "pirinola_icono")
        logoImageView = UIImageView()
        logoImageView.frame = CGRect(x: (self.view.frame.width / 2) - ((self.view.frame.width * 0.2) / 2) , y: self.view.frame.height * 0.03 + 60 , width: self.view.frame.width * 0.2, height: self.view.frame.width * 0.16)
        logoImageView.image = imagenLogo
        
        
        self.view.addSubview(logoImageView!)
    }
    
    func crearSpinnerCiudad(listaCiu : Array<String>)
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = (self.view.frame.width / 2) - ((self.view.frame.width * 0.9) / 2)
        let puntoInicialY = 60 + logoImageView.frame.height + (self.view.frame.height * 0.03) * 2
        spinnerCiudad = DKDropMenu(frame : CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.05))
        
        spinnerCiudad.addItems(listaCiu)
        
        backgroundSpinnerCiudad = CAGradientLayer().amarilloDegradado()
        backgroundSpinnerCiudad.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
        imagenSpinnerCiudad = UIImage(named: "flecha_abajo")
        iconoSpinnerCiudad = UIImageView(frame: CGRect(x: spinnerCiudad.frame.width - spinnerCiudad.frame.height * 0.4 - spinnerCiudad.frame.height * 0.25 , y: spinnerCiudad.frame.height * 0.30, width: spinnerCiudad.frame.height * 0.4, height: spinnerCiudad.frame.height * 0.4))
        
        iconoSpinnerCiudad.image = imagenSpinnerCiudad
        
        spinnerCiudad.backgroundColor = UIColor.clearColor()
        spinnerCiudad.delegate = self
        spinnerCiudad.addSubview(iconoSpinnerCiudad)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            spinnerCiudad.tamanoLetra = 12.0
            break
            
        case .Pad:
            spinnerCiudad.tamanoLetra = 22.0
            break
            
        default:
            break
        }
        spinnerCiudad.itemHeight = tamanoBaseHeight * 0.05
        
        self.view.layer.addSublayer(backgroundSpinnerCiudad)
        self.view.addSubview(spinnerCiudad)
    }
    
    func crearScrollView()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicial = 60 + logoImageView.frame.height + (self.view.frame.height * 0.03) * 2 + (tamanoBaseHeight * 0.05) + self.view.frame.height * 0.03
        
        let altura = self.view.frame.height - (60 + logoImageView.frame.height + (self.view.frame.height * 0.03) * 2 + tamanoBaseHeight * 0.05 +  self.view.frame.height * 0.03)
        scrollview = UIScrollView()
        scrollview.frame = CGRect(x: 0, y: puntoInicial, width: self.view.frame.width, height: altura )
        
    }
    
    
    func crearFormulario()
    {
        
        eliminarScrollView()
        crearScrollView()
        crearCajaTextoNombre()
        crearCajaTextoDireccion()
        crearCajaTextoBarrio()
        crearCajaTextoTelfono()
        crearSpinnerFormaPago()
        crearCajaTextoObservaciones()
        
        scrollview.layer.addSublayer(backgroundSpinnerFormaPago)
        scrollview.addSubview(spinnerFormaPago)
        spinnerCiudad.removeFromSuperview()
        backgroundSpinnerCiudad.removeFromSuperlayer()
        
        
        
        
        self.view.addSubview(scrollview)
        self.view.layer.addSublayer(backgroundSpinnerCiudad)
        self.view.addSubview(spinnerCiudad)
        
        crearBotonEnviarPedido()
        
        if contenidoheigth > scrollview.frame.height
        {
            scrollview.contentSize = CGSize(width: scrollview.frame.width, height: contenidoheigth)
        }
        else
        {
            scrollview.contentSize = CGSize(width: scrollview.frame.width, height: scrollview.frame.height)
        }
    }
    
    func eliminarVistaScrollView()
    {
        if scrollview != nil
        {
            backgroundNombreTextField.removeFromSuperlayer()
            nombreTextField.removeFromSuperview()
            
            backgroundDireccionTextField.removeFromSuperlayer()
            direccionTextField.removeFromSuperview()
            
            backgroundBarrioTextField.removeFromSuperlayer()
            barrioTextField.removeFromSuperview()
            
            backgroundTelefonoTextField.removeFromSuperlayer()
            telefonoTextField.removeFromSuperview()
            
            
            spinnerFormaPago.removeFromSuperview()
            backgroundSpinnerFormaPago.removeFromSuperlayer()
            iconoSpinnerFormaPago.removeFromSuperview()
            
            observacionesTextView.removeFromSuperview()
            placeholderObservacionesTextField.removeFromSuperview()
            backgroundObservacionesTextView.removeFromSuperlayer()
            
            botonEnviarPedido.removeFromSuperview()
            backgroundButonEnviarPedido.removeFromSuperlayer()
            
            scrollview.removeFromSuperview()
            
            imagenSpinnerFormaPago = nil
            iconoSpinnerFormaPago = nil
            backgroundSpinnerFormaPago = nil
            spinnerFormaPago.delegate = nil
            spinnerFormaPago = nil
            
            
            scrollview = nil
            backgroundNombreTextField = nil
            nombreTextField.delegate = nil
            nombreTextField = nil
            backgroundDireccionTextField = nil
            direccionTextField.delegate = nil
            direccionTextField = nil
            backgroundBarrioTextField = nil
            barrioTextField.delegate = nil
            barrioTextField = nil
            backgroundTelefonoTextField = nil
            telefonoTextField.delegate = nil
            telefonoTextField = nil
            
            observacionesTextView.delegate = nil
            observacionesTextView = nil
            placeholderObservacionesTextField = nil
            backgroundObservacionesTextView = nil
            
            botonEnviarPedido = nil
            backgroundButonEnviarPedido = nil
            
        }
    }
    
    func crearCajaTextoNombre()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = scrollview.frame.width * 0.05
        contenidoheigth = 0.0
        nombreTextField = UITextField()
        nombreTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
        
        backgroundNombreTextField = CAGradientLayer().amarilloDegradado()
        backgroundNombreTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: tamanoBaseHeight * 0.05)
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
        contenidoheigth = self.contenidoheigth + tamanoBaseHeight * 0.05
        
    }
    
    func crearCajaTextoDireccion()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = scrollview.frame.width * 0.05
        contenidoheigth = contenidoheigth + tamanoBaseHeight * 0.03
        direccionTextField = UITextField()
        direccionTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
        
        backgroundDireccionTextField = CAGradientLayer().amarilloDegradado()
        backgroundDireccionTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: tamanoBaseHeight * 0.05)
        direccionTextField.layer.insertSublayer(backgroundDireccionTextField, atIndex: 0)
        direccionTextField.textAlignment = NSTextAlignment.Center
        
        
        direccionTextField.textColor = UIColor.redColor()
        direccionTextField.keyboardType = UIKeyboardType.Alphabet
        
        direccionTextField.delegate = self
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Dirección", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            direccionTextField.attributedPlaceholder = placeholderCorreo
            direccionTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Dirección", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            direccionTextField.attributedPlaceholder = placeholderCorreo
            direccionTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview.addSubview(direccionTextField)
        contenidoheigth = self.contenidoheigth + tamanoBaseHeight * 0.05
        
    }
    
    func crearCajaTextoBarrio()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = scrollview.frame.width * 0.05
        contenidoheigth = contenidoheigth + tamanoBaseHeight * 0.03
        barrioTextField = UITextField()
        barrioTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
        
        backgroundBarrioTextField = CAGradientLayer().amarilloDegradado()
        backgroundBarrioTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: tamanoBaseHeight * 0.05)
        barrioTextField.layer.insertSublayer(backgroundBarrioTextField, atIndex: 0)
        barrioTextField.textAlignment = NSTextAlignment.Center
        
        
        barrioTextField.textColor = UIColor.redColor()
        barrioTextField.keyboardType = UIKeyboardType.Alphabet
        
        barrioTextField.delegate = self
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Barrio", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            barrioTextField.attributedPlaceholder = placeholderCorreo
            barrioTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Barrio", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            barrioTextField.attributedPlaceholder = placeholderCorreo
            barrioTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview.addSubview(barrioTextField)
        contenidoheigth = self.contenidoheigth + tamanoBaseHeight * 0.05
        
    }
    
    func crearCajaTextoTelfono()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = scrollview.frame.width * 0.05
        contenidoheigth = contenidoheigth + tamanoBaseHeight * 0.03
        telefonoTextField = UITextField()
        telefonoTextField.frame = CGRect(x: puntoInicialX, y: self.contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
        
        backgroundTelefonoTextField = CAGradientLayer().amarilloDegradado()
        backgroundTelefonoTextField.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: tamanoBaseHeight * 0.05)
        telefonoTextField.layer.insertSublayer(backgroundTelefonoTextField, atIndex: 0)
        telefonoTextField.textAlignment = NSTextAlignment.Center
        
        
        telefonoTextField.textColor = UIColor.redColor()
        telefonoTextField.keyboardType = UIKeyboardType.PhonePad
        
        telefonoTextField.delegate = self
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            let placeholderCorreo = NSAttributedString(string: "Teléfono", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 12)!])
            telefonoTextField.attributedPlaceholder = placeholderCorreo
            telefonoTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            let placeholderCorreo = NSAttributedString(string: "Teléfono", attributes: [NSForegroundColorAttributeName : UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1), NSFontAttributeName : UIFont(name: "Segoe Print",size: 22)!])
            telefonoTextField.attributedPlaceholder = placeholderCorreo
            telefonoTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        
        scrollview.addSubview(telefonoTextField)
        contenidoheigth = self.contenidoheigth + tamanoBaseHeight * 0.05
        
    }

    
    func crearSpinnerFormaPago()
    {
        var formapago  = Array <String>()
        formapago.append("Seleccione forma de pago")
        
        for fp in self.listaFormaPago
        {
            
            formapago.append(fp.nombre!)
        }
        
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = scrollview.frame.width * 0.05
        contenidoheigth = contenidoheigth + tamanoBaseHeight * 0.03
        spinnerFormaPago = DKDropMenu(frame : CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.05))
        
        spinnerFormaPago.addItems(formapago)
        
        backgroundSpinnerFormaPago = CAGradientLayer().amarilloDegradado()
        backgroundSpinnerFormaPago.frame = CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
        imagenSpinnerFormaPago = UIImage(named: "flecha_abajo")
        iconoSpinnerFormaPago = UIImageView(frame: CGRect(x: spinnerFormaPago.frame.width - spinnerFormaPago.frame.height * 0.4 - spinnerFormaPago.frame.height * 0.25 , y: spinnerFormaPago.frame.height * 0.30, width: spinnerFormaPago.frame.height * 0.4, height: spinnerFormaPago.frame.height * 0.4))
        
        iconoSpinnerFormaPago.image = imagenSpinnerFormaPago
        
        spinnerFormaPago.backgroundColor = UIColor.clearColor()
        spinnerFormaPago.delegate = self
        spinnerFormaPago.addSubview(iconoSpinnerFormaPago)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            spinnerFormaPago.tamanoLetra = 12.0
            break
            
        case .Pad:
            spinnerFormaPago.tamanoLetra = 22.0
            break
            
        default:
            break
        }
        spinnerFormaPago.itemHeight = tamanoBaseHeight * 0.05
        contenidoheigth = contenidoheigth + tamanoBaseHeight * 0.05
        
    }
    
    func crearCajaTextoObservaciones()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = scrollview.frame.width * 0.05
        contenidoheigth = contenidoheigth + tamanoBaseHeight * 0.03
        observacionesTextView = UITextView()
        observacionesTextView.frame = CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.15)
        
        observacionesTextView.contentSize.height = tamanoBaseHeight * 0.2
        
        backgroundObservacionesTextView = CAGradientLayer().amarilloDegradado()
        backgroundObservacionesTextView.frame = CGRect(x:0 , y: 0 , width: scrollview.frame.width * 0.9 , height: tamanoBaseHeight * 0.2 * 2)
        observacionesTextView.layer.insertSublayer(backgroundObservacionesTextView, atIndex: 0)
        observacionesTextView.textAlignment = NSTextAlignment.Center
        
        observacionesTextView.textColor = UIColor.redColor()
        observacionesTextView.delegate = self
        
        
        placeholderObservacionesTextField = UILabel()
        placeholderObservacionesTextField.frame = CGRect(x: 0, y: 10, width: observacionesTextView.frame.width, height: observacionesTextView.frame.height * 0.7)
        
        placeholderObservacionesTextField.numberOfLines = 3
        
        placeholderObservacionesTextField.textAlignment = NSTextAlignment.Center
        placeholderObservacionesTextField.textColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        placeholderObservacionesTextField.text = "Observaciones (opcional) \n ejemplo : Traer Cambio."
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            observacionesTextView.font = UIFont(name: "Segoe Print",size: 12)
            placeholderObservacionesTextField.font = UIFont(name: "Segoe Print",size: 12)
            break
            
        case .Pad:
            observacionesTextView.font = UIFont(name: "Segoe Print",size: 22)
            placeholderObservacionesTextField.font = UIFont(name: "Segoe Print",size: 22)
            break
            
        default:
            break
        }
        observacionesTextView.scrollToBotom()
        observacionesTextView.addSubview(placeholderObservacionesTextField)
        contenidoheigth = contenidoheigth + tamanoBaseHeight * 0.15
        
        scrollview.addSubview(observacionesTextView)
    }

    
    
    func crearMensajeCompruebeConexion()
    {
        
        mensajeCompruebeConexionLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.05 , y: (self.view.frame.height / 2) - (self.view.frame.height * 0.15)/2 , width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.15))
        
        mensajeCompruebeConexionLabel.textColor = UIColor.whiteColor()
        mensajeCompruebeConexionLabel.text = "Compruebe su conexión a internet"
        mensajeCompruebeConexionLabel.backgroundColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        
        mensajeCompruebeConexionLabel.numberOfLines = 2
        
        
        volverCargarVistaBtn = UIButton(frame: CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height - ((self.view.frame.height - 60) * 0.06) - self.view.frame.height * 0.02, width: self.view.frame.width * 0.9, height: (self.view.frame.height - 60) * 0.06))
        
        volverCargarVistaBtn.setTitle("Volver a cargar la vista", forState: UIControlState.Normal)
        
        backgroundVolverCargarVistaBtn = CAGradientLayer().rojoDegradado()
        backgroundVolverCargarVistaBtn.frame = CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height - ((self.view.frame.height - 60) * 0.06) - self.view.frame.height * 0.02, width: self.view.frame.width * 0.9, height: (self.view.frame.height - 60) * 0.06)
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            mensajeCompruebeConexionLabel.font = UIFont(name: "Segoe Print", size: 18)
            volverCargarVistaBtn.titleLabel?.font = UIFont(name: "Matura MT Script Capitals" , size: 14 )
            break
            
        case .Pad:
            mensajeCompruebeConexionLabel.font = UIFont(name: "Segoe Print", size: 25)
            volverCargarVistaBtn.titleLabel?.font = UIFont(name: "Matura MT Script Capitals" , size: 24 )
            break
            
        default:
            break
        }
        
        volverCargarVistaBtn.addTarget(nil, action: #selector(actionVolverCargarVista), forControlEvents: .TouchUpInside)
        self.view.addSubview(mensajeCompruebeConexionLabel)
        self.view.layer.addSublayer(backgroundVolverCargarVistaBtn)
        self.view.addSubview(volverCargarVistaBtn)
    }
    
    func crearBotonEnviarPedido()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = scrollview.frame.width * 0.05
        contenidoheigth = contenidoheigth + tamanoBaseHeight * 0.04
        botonEnviarPedido = UIButton()
        botonEnviarPedido.frame = CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.06)
        botonEnviarPedido.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        botonEnviarPedido.setTitle("Enviar Pedido", forState: UIControlState.Normal)
        
        backgroundButonEnviarPedido = CAGradientLayer().rojoDegradado()
        backgroundButonEnviarPedido.frame = CGRect(x: puntoInicialX, y: contenidoheigth, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.06)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            botonEnviarPedido.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 14)
            break
            
        case .Pad:
            botonEnviarPedido.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 24)
            break
            
        default:
            break
        }
        
        
        scrollview.layer.addSublayer(backgroundButonEnviarPedido)
        
        botonEnviarPedido.addTarget(nil, action: #selector(actionEnviarPedido), forControlEvents: .TouchUpInside)
        scrollview.addSubview(botonEnviarPedido!)
        self.contenidoheigth = self.contenidoheigth + scrollview.frame.height * 0.06
    }
    
    // MARK: - eventos Click
    
    func actionAtras(sender: AnyObject)
    {
        atras()
    }
    func actionVolverCargarVista(sender: AnyObject)
    {
        volverCargarVista()
    }
    
    func actionEnviarPedido(sender: AnyObject)
    {
        enviarPedido()
    }
    
    // MARK: - logica de negocio
    
    func enviarPedido()
    {
        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
        
        if nombreTextField.text!.isEmpty || direccionTextField.text!.isEmpty || barrioTextField.text!.isEmpty || telefonoTextField.text!.isEmpty
        {
            self.view.makeToast(message: "Todos los campos son obligatorios menos el de observaciones.", duration: 2, position: HRToastPositionCenter)
        }
        else
        {
            if spinnerFormaPago.selectedIndice == 0
            {
                self.view.makeToast(message: "Seleccione una forma de pago.", duration: 2, position: HRToastPositionCenter)
            }
            else
            {
                enviarPedidoBackendless()
            }
        }
        
    }
    
    func atras()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cargarCiudadesBackendless()
    {
        UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
        UIView.hr_setToastFontColor(color: UIColor.blackColor())
        presentWindow  = UIApplication.sharedApplication().keyWindow
        
        fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        
        
        var ciudadSelect = Array<String>()
        ciudadSelect.append("objectId")
        ciudadSelect.append("nombre")
        ciudadSelect.append("email")
        
        
        let dataQueryCiudad = BackendlessDataQuery()
        dataQueryCiudad.properties = ciudadSelect
        
        
        let queryCiudad = backendless.data.of(Ciudad.ofClass())
        
        self.view.addSubview(fondoTrasparenteAlertview)
        presentWindow.makeToastActivity(message: "Cargando ...")
        queryCiudad.find(dataQueryCiudad, response: { (result: BackendlessCollection!) -> Void in
            
            self.listaCiudades = result.getCurrentPage() as! [Ciudad]
            
            var ciudades  = Array <String>()
            ciudades.append("Seleccione una ciudad")
            
            for ciu in self.listaCiudades
            {
                
                ciudades.append(ciu.nombre!)
            }
            
            
            self.crearSpinnerCiudad(ciudades)
            
            self.fondoTrasparenteAlertview.removeFromSuperview()
            self.presentWindow.hideToastActivity()
            self.presentWindow = nil
            self.fondoTrasparenteAlertview = nil
            
            }, error: { (fault: Fault!) -> Void in
                
                self.presentWindow.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertview.removeFromSuperview()
                self.fondoTrasparenteAlertview = nil
                self.crearMensajeCompruebeConexion()
                
            })
    }
    
    func cargarFormaPagoBackendless(ciudadid : String)
    {
        UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
        UIView.hr_setToastFontColor(color: UIColor.blackColor())
        presentWindow  = UIApplication.sharedApplication().keyWindow
        
        fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        var formapagoSelect = Array<String>()
        formapagoSelect.append("objectId")
        formapagoSelect.append("nombre")
        formapagoSelect.append("abreviatura")
    
        
        let dataQueryformapago = BackendlessDataQuery()
        dataQueryformapago.properties = formapagoSelect
        dataQueryformapago.whereClause = "activado = TRUE AND ciudad='"+ciudadid+"'"
        
        let queryFormapago = backendless.data.of(Formapago.ofClass())
        
        self.view.addSubview(fondoTrasparenteAlertview)
        presentWindow.makeToastActivity(message: "Cargando ...")
        queryFormapago.find(dataQueryformapago, response: { (result: BackendlessCollection!) -> Void in
            
            
            self.fondoTrasparenteAlertview.removeFromSuperview()
            self.presentWindow.hideToastActivity()
            self.presentWindow = nil
            self.fondoTrasparenteAlertview = nil
            
            self.listaFormaPago = result.getCurrentPage() as! [Formapago]
            
            self.crearFormulario()
            
        }, error: { (fault: Fault!) -> Void in
                
                self.presentWindow.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertview.removeFromSuperview()
                self.fondoTrasparenteAlertview = nil
                
                self.eliminarSpinnerCiudad()
                self.eliminarScrollView()
                self.crearMensajeCompruebeConexion()
                
        })
    }
    
    func enviarPedidoBackendless()
    {
        UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
        UIView.hr_setToastFontColor(color: UIColor.blackColor())
        presentWindow  = UIApplication.sharedApplication().keyWindow
        
        fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let pedido = Pedido()
        pedido.peddireccion = direccionTextField.text! + " " + barrioTextField.text!
        pedido.pedformapago = listaFormaPago[spinnerFormaPago.selectedIndice! - 1].abreviatura
        pedido.pedtelefono = telefonoTextField.text!
        pedido.pedpersonanombre = nombreTextField.text!
        pedido.pedobservaciones = observacionesTextView.text!
       
       
        pedido.ciudad = listaCiudades[spinnerCiudad.selectedIndice! - 1].objectId
        
        let dataQueryPedido = backendless.data.of(Pedido.ofClass())
        
        self.view.addSubview(fondoTrasparenteAlertview)
        presentWindow.makeToastActivity(message: "Enviando ...")
        
        dataQueryPedido.save(
            pedido,
            response: { (result: AnyObject!) -> Void in
                
                let obj = result as! Pedido
                print("Contact has been saved: \(obj.objectId)")
                
                
                
                var recipients = Array<String>()
                recipients.append(self.listaCiudades[self.spinnerCiudad.selectedIndice! - 1].email!)
                
                let asunto = "Nuevo pedido"
                let fp = self.listaFormaPago[self.spinnerFormaPago.selectedIndice! - 1].nombre!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = NSTimeZone(name: "America/Bogota")
                
                var mailBody = "<h1>Nuevo pedido</h1>"
                mailBody += "<b>Fecha y hora : </b>" + dateFormatter.stringFromDate(obj.created!) + "<br>"
                mailBody += "<b>Nombre cliente : </b>" + obj.pedpersonanombre! + "<br>"
                mailBody += "<b>Teléfono : </b>" + obj.pedtelefono! + "<br>"
                mailBody += "<b>Dirección : </b>" + obj.peddireccion! + "<br>"
                mailBody += "<b>Ciudad : </b>" + self.listaCiudades[self.spinnerCiudad.selectedIndice! - 1].nombre!
                mailBody += "<br>" + "<b>Forma de Pago : </b>" + fp + "<br>"
                mailBody += "<b>Observaciones : </b>" + obj.pedobservaciones! + "<br><br><br>"
                mailBody += "<table border='1'><tr><th>Producto</th><th>cantidad</th><th>Precio</th>"
                mailBody += "<th>Total</th></tr>"
                
                
                var totalPedido = 0;
                
                for itemcar in AppUtil.listaCarro
                {
                    let itempedido = Itempedido()
                    itempedido.pedido = obj.objectId
                    itempedido.producto = itemcar.objectId
                    itempedido.itemcantidad = itemcar.cantidad
                    
                    let dataQueryItemPedido = self.backendless.data.of(Itempedido.ofClass())
                    
                    dataQueryItemPedido.save(
                        itempedido,
                        response: { (result: AnyObject!) -> Void in
                            
                        },
                        error: { (fault: Fault!) -> Void in
                            
                    })
                    
                    var producto = Producto()
                    
                    for  p in AppUtil.data
                    {
                        if p.objectId == itemcar.objectId
                        {
                            producto = p
                            break
                        }
                    }
                    let total = producto.precio * itemcar.cantidad
                    totalPedido = totalPedido + total
                    mailBody += "<tr>"
                    mailBody += "<td>" + producto.prodnombre! + "</td>"
                    mailBody += "<td>" + String(itemcar.cantidad) + "</td>"
                    mailBody += "<td>" + String(producto.precio) + "</td>"
                    mailBody += "<td>" + String(total) + "</td></tr>"
                    
                }
                
                mailBody += "</table><h2>Costo domicilio :  </h2>" + String(AppUtil.listaSubcategorias[0].domicilio)
                mailBody += "<h2>Subtotal :  </h2>" + String(totalPedido)
                mailBody += "<h2>Total Pedido:</h2>" + String(totalPedido + AppUtil.listaSubcategorias[0].domicilio);
                
                
                self.backendless.messagingService.sendHTMLEmail(asunto, body: mailBody, to: recipients, response: { (result: AnyObject!) -> Void in
                    
                        print("mensaje enviado")
                    
                    
                    
                    }, error: { (fault : Fault!) -> Void in
                
                            print("error : \(fault.message)")
                
                    })
                
                self.presentWindow.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertview.removeFromSuperview()
                self.fondoTrasparenteAlertview = nil
                
                self.comunicacionLoginControllerNoRegistradoController.seRealizoPedido()
                
                self.atras()
                
            },
            error: { (fault: Fault!) -> Void in
                print("fServer reported an error: \(fault)")
                
                self.presentWindow.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertview.removeFromSuperview()
                self.fondoTrasparenteAlertview = nil
                
                UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                
                self.view.makeToast(message: "Compruebe su conexión a internet.", duration: 2, position: HRToastPositionCenter)                
        })
    }
    
    func volverCargarVista()
    {
        mensajeCompruebeConexionLabel.removeFromSuperview()
        volverCargarVistaBtn.removeFromSuperview()
        backgroundVolverCargarVistaBtn.removeFromSuperlayer()
        
        mensajeCompruebeConexionLabel = nil
        volverCargarVistaBtn = nil
        backgroundVolverCargarVistaBtn = nil
        
        cargarCiudadesBackendless()
    }
    
    func eliminarSpinnerCiudad()
    {
        spinnerCiudad.removeFromSuperview()
        backgroundSpinnerCiudad.removeFromSuperlayer()
        iconoSpinnerCiudad.removeFromSuperview()
        imagenSpinnerCiudad = nil
        iconoSpinnerCiudad = nil
        backgroundSpinnerCiudad = nil
        spinnerCiudad.delegate = nil
        spinnerCiudad = nil
        
    }
    func eliminarScrollView()
    {
        eliminarVistaScrollView()
    }
    // MARK: DKDropMenuDelegate
    func itemSelectedWithIndex(index: Int, name: String , dKDropMenu : DKDropMenu) {
        print("indice : \(index) \(name) selected");
        
        if dKDropMenu == spinnerCiudad
        {
            if index == 0
            {
                spinnerCiudad.removeFromSuperview()
                backgroundSpinnerCiudad.removeFromSuperlayer()
                eliminarScrollView()
                
                self.view.layer.addSublayer(backgroundSpinnerCiudad)
                self.view.addSubview(spinnerCiudad)
                
            }
            else
            {
                cargarFormaPagoBackendless(listaCiudades[index - 1].objectId!)
                
            }
        }
        
    }
    
    func collapsedChanged(dKDropMenu : DKDropMenu)
    {
        
        if dKDropMenu == spinnerCiudad
        {
            let tamanoBaseHeight = self.view.frame.height - 60
            let puntoInicialX = (self.view.frame.width / 2) - ((self.view.frame.width * 0.9) / 2)
            let puntoInicialY = 60 + logoImageView.frame.height + (self.view.frame.height * 0.03) * 2
            
            let conteoCiudades = CGFloat(listaCiudades.count + 1)
            
            
            if(!spinnerCiudad.collapsed)
            {
                backgroundSpinnerCiudad.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.05 * conteoCiudades)
            }
            else
            {
                backgroundSpinnerCiudad.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
            }
            
        }
        else
        {
            
            if dKDropMenu == spinnerFormaPago
            {
                let tamanoBaseHeight = self.view.frame.height - 60
                
                
                let conteoFormaPago = CGFloat(listaFormaPago.count + 1)
                
                
                if(!spinnerFormaPago.collapsed)
                {
                    backgroundSpinnerFormaPago.frame = CGRect(x: spinnerFormaPago.frame.origin.x, y: spinnerFormaPago.frame.origin.y, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.05 * conteoFormaPago)
                }
                else
                {
                    backgroundSpinnerFormaPago.frame = CGRect(x: spinnerFormaPago.frame.origin.x, y: spinnerFormaPago.frame.origin.y, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
                }
                
            }
            
        }
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
        
        /*if textField == claveTextField || textField == repetirClaveTextField
        {
            return length <= 20
        }*/
        
        return length <= 70
        
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
        let limite = scrollview.frame.height - 250
        let posicionYfinalCajatexto = textView.frame.origin.y + textView.frame.height
        
        if posicionYfinalCajatexto > limite
        {
            
            scrollview.setContentOffset(CGPointMake(0, posicionYfinalCajatexto  - limite),animated: true)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        scrollview.setContentOffset(CGPointMake(0, 0),animated: true)
        
    }
    
    func textViewDidChange(textView: UITextView)
    {
        let espacing = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        if !observacionesTextView.text.stringByTrimmingCharactersInSet(espacing).isEmpty
        {
            placeholderObservacionesTextField.hidden = true
        }
        else
        {
            placeholderObservacionesTextField.hidden = false
        }
        
        
    }
    
    
    //MARK: - funcion dinit
    
    deinit
    {
        btnAtras.removeFromSuperview()
        backgroundTitulo.removeFromSuperlayer()
        tituloLabel.removeFromSuperview()
        logoImageView.removeFromSuperview()
        
        
        
        imagenBtnAtras = nil
        btnAtras = nil
        backgroundTitulo = nil
        tituloLabel = nil
        imagenLogo = nil
        logoImageView = nil
        
        if spinnerCiudad != nil
        {
            spinnerCiudad.removeFromSuperview()
            backgroundSpinnerCiudad.removeFromSuperlayer()
            iconoSpinnerCiudad.removeFromSuperview()
            imagenSpinnerCiudad = nil
            iconoSpinnerCiudad = nil
            backgroundSpinnerCiudad = nil
            spinnerCiudad.delegate = nil
            spinnerCiudad = nil
        }
        
        if mensajeCompruebeConexionLabel != nil
        {
            mensajeCompruebeConexionLabel.removeFromSuperview()
            backgroundVolverCargarVistaBtn.removeFromSuperlayer()
            volverCargarVistaBtn.removeFromSuperview()
            
            volverCargarVistaBtn = nil
            backgroundVolverCargarVistaBtn = nil
            mensajeCompruebeConexionLabel = nil
        }
        
        eliminarVistaScrollView()
        comunicacionLoginControllerNoRegistradoController = nil
        
        self.view.removeFromSuperview()
        debugPrint("se va a dealloc NoRegistradoViewController")
    }

}
