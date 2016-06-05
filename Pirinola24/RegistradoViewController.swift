//
//  RegistradoViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 1/06/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

protocol ComunicacionListaCiudadesControllerRegistradoController
{
    func seRealizoPedido()
}


class RegistradoViewController: UIViewController , DKDropMenuDelegate , UITextViewDelegate
{
    var fondoTrasparenteAlertview : UIView!
    var presentWindow : UIWindow!
    
    var tituloLabel : UILabel!
    var backgroundTitulo: CAGradientLayer!
    var btnAtras : UIButton!
    var imagenBtnAtras : UIImage!
    var mensajeSeleccionar : UILabel!
    
    var listaTelefonos: Array<Telefono>!
    var listaFormaPagos: Array<Formapago>!
    var listaDirecciones: Array<Direccion>!
    
    var mensajeCompruebeConexionLabel : UILabel!
    var backgroundVolverCargarVistaBtn : CAGradientLayer!
    var volverCargarVistaBtn : UIButton!
    
    
    var backgroundSpinnerFormaPago : CAGradientLayer!
    var spinnerFormaPago : DKDropMenu!
    var imagenSpinnerFormaPago : UIImage!
    var iconoSpinnerFormaPago : UIImageView!
    
    var backgroundSpinnerDireccion : CAGradientLayer!
    var spinnerDireccion : DKDropMenu!
    var imagenSpinnerDireccion : UIImage!
    var iconoSpinnerDireccion : UIImageView!
    var btnAgregarDireccion : UIButton!
    var imagenAgrearDireccion : UIImage!
    
    
    var backgroundSpinnerTelefono : CAGradientLayer!
    var spinnerTelefono : DKDropMenu!
    var imagenSpinnerTelefono : UIImage!
    var iconoSpinnerTelefono : UIImageView!
    var btnAgregarTelefono : UIButton!
    var imagenAgrearTelefono : UIImage!
    
    var backgroundObservacionesTextView : CAGradientLayer!
    var observacionesTextView : UITextView!
    var placeholderObservacionesTextField : UILabel!
    
    var backgroundButonEnviarPedido : CAGradientLayer!
    var botonEnviarPedido : UIButton!
    
    var scrollview: UIScrollView!
    
    var ciudad : Ciudad!
    
    let backendless = Backendless.sharedInstance()
    
    var comunicacionListaCiudadesControllerRegistradoController : ComunicacionListaCiudadesControllerRegistradoController!

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

    override func viewWillAppear(animated: Bool) {
        if listaDirecciones == nil && listaTelefonos == nil && listaFormaPagos == nil
        {
            cargarDatosBackendless()
        }
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
        
        tituloLabel.text = ciudad.nombre
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
        self.view.addSubview(scrollview)
    }
    
    func crearMensajeSeleccionar()
    {
        mensajeSeleccionar = UILabel(frame: CGRect(x: self.view.frame.width * 0.05, y: 0 , width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.2))
        
        mensajeSeleccionar.numberOfLines = 3
        
        mensajeSeleccionar.textColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        
        mensajeSeleccionar.text = "Si no aparece la dirección o el teléfono en las listas puedes adicionarlos"
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            mensajeSeleccionar.font = UIFont(name: "Segoe Print", size: 16)
            break
            
        case .Pad:
            mensajeSeleccionar.font = UIFont(name: "Segoe Print", size: 26)
            break
            
        default:
            break
        }
        
        scrollview.addSubview(mensajeSeleccionar)
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
    
    func crearSpinnerDireccion(listaDir : Array<String>)
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = self.view.frame.width * 0.05
        let puntoInicialY = self.mensajeSeleccionar.frame.height
        spinnerDireccion = DKDropMenu(frame : CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.8, height: tamanoBaseHeight * 0.05))
        
        spinnerDireccion.addItems(listaDir)
        
        backgroundSpinnerDireccion = CAGradientLayer().amarilloDegradado()
        backgroundSpinnerDireccion.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.8, height: tamanoBaseHeight * 0.05)
        imagenSpinnerDireccion = UIImage(named: "flecha_abajo")
        iconoSpinnerDireccion = UIImageView(frame: CGRect(x: spinnerDireccion.frame.width - spinnerDireccion.frame.height * 0.4 - spinnerDireccion.frame.height * 0.25 , y: spinnerDireccion.frame.height * 0.30, width: spinnerDireccion.frame.height * 0.4, height: spinnerDireccion.frame.height * 0.4))
        
        iconoSpinnerDireccion.image = imagenSpinnerDireccion
        
        spinnerDireccion.backgroundColor = UIColor.clearColor()
        spinnerDireccion.delegate = self
        spinnerDireccion.addSubview(iconoSpinnerDireccion)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            spinnerDireccion.tamanoLetra = 12.0
            break
            
        case .Pad:
            spinnerDireccion.tamanoLetra = 22.0
            break
            
        default:
            break
        }
        spinnerDireccion.itemHeight = tamanoBaseHeight * 0.05
        
        btnAgregarDireccion = UIButton(frame: CGRect(x: puntoInicialX + spinnerDireccion.frame.width + self.view.frame.width * 0.02 , y: puntoInicialY, width: self.view.frame.width * 0.08, height: tamanoBaseHeight * 0.05))
        
        imagenAgrearDireccion = UIImage(named: "btn_mas")
        
        btnAgregarDireccion.setBackgroundImage(imagenAgrearDireccion, forState: UIControlState.Normal)
        btnAgregarDireccion.addTarget(nil, action: #selector(actionAgregarDireccion), forControlEvents: .TouchUpInside)
       
    }
    
    func crearSpinnerTelefono(listaTel : Array<String>)
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = self.view.frame.width * 0.05
        let puntoInicialY = self.mensajeSeleccionar.frame.height + spinnerDireccion.frame.height + tamanoBaseHeight * 0.04
        spinnerTelefono = DKDropMenu(frame : CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.8, height: tamanoBaseHeight * 0.05))
        
        spinnerTelefono.addItems(listaTel)
        
        backgroundSpinnerTelefono = CAGradientLayer().amarilloDegradado()
        backgroundSpinnerTelefono.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.8, height: tamanoBaseHeight * 0.05)
        imagenSpinnerTelefono = UIImage(named: "flecha_abajo")
        iconoSpinnerTelefono = UIImageView(frame: CGRect(x: spinnerTelefono.frame.width - spinnerTelefono.frame.height * 0.4 - spinnerTelefono.frame.height * 0.25 , y: spinnerTelefono.frame.height * 0.30, width: spinnerTelefono.frame.height * 0.4, height: spinnerTelefono.frame.height * 0.4))
        
        iconoSpinnerTelefono.image = imagenSpinnerTelefono
        
        spinnerTelefono.backgroundColor = UIColor.clearColor()
        spinnerTelefono.delegate = self
        spinnerTelefono.addSubview(iconoSpinnerTelefono)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            spinnerTelefono.tamanoLetra = 12.0
            break
            
        case .Pad:
            spinnerTelefono.tamanoLetra = 22.0
            break
            
        default:
            break
        }
        spinnerTelefono.itemHeight = tamanoBaseHeight * 0.05
        
        btnAgregarTelefono = UIButton(frame: CGRect(x: puntoInicialX + spinnerTelefono.frame.width + self.view.frame.width * 0.02 , y: puntoInicialY, width: self.view.frame.width * 0.08, height: tamanoBaseHeight * 0.05))
        
        imagenAgrearTelefono = UIImage(named: "btn_mas")
        
        btnAgregarTelefono.setBackgroundImage(imagenAgrearTelefono, forState: UIControlState.Normal)
        btnAgregarTelefono.addTarget(nil, action: #selector(actionAgregarTelefono), forControlEvents: .TouchUpInside)
        
    }
    
    func crearSpinnerFormaPago(formapago: Array<String>)
    {
        
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = self.view.frame.width * 0.05
        let puntoInicialY = self.mensajeSeleccionar.frame.height + spinnerDireccion.frame.height + tamanoBaseHeight * 0.04 * 2 + spinnerTelefono.frame.height
        spinnerFormaPago = DKDropMenu(frame : CGRect(x: puntoInicialX, y: puntoInicialY, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.05))
        
        spinnerFormaPago.addItems(formapago)
        
        backgroundSpinnerFormaPago = CAGradientLayer().amarilloDegradado()
        backgroundSpinnerFormaPago.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
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
    }
    
    
    func crearCajaTextoObservaciones()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = self.view.frame.width * 0.05
        let puntoInicialY = self.mensajeSeleccionar.frame.height + spinnerDireccion.frame.height + tamanoBaseHeight * 0.04 * 3 + spinnerTelefono.frame.height * 2
        observacionesTextView = UITextView()
        observacionesTextView.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.15)
        
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
    }
    
    func crearBotonEnviarPedido()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicialX = self.view.frame.width * 0.05
        let puntoInicialY = self.mensajeSeleccionar.frame.height + spinnerDireccion.frame.height + tamanoBaseHeight * 0.04 * 3 + spinnerTelefono.frame.height * 2 + tamanoBaseHeight * 0.05 + observacionesTextView.frame.height
        botonEnviarPedido = UIButton()
        botonEnviarPedido.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.06)
        botonEnviarPedido.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        botonEnviarPedido.setTitle("Enviar Pedido", forState: UIControlState.Normal)
        
        backgroundButonEnviarPedido = CAGradientLayer().rojoDegradado()
        backgroundButonEnviarPedido.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: scrollview.frame.width * 0.9, height: tamanoBaseHeight * 0.06)
        
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
        
        
        
        
        botonEnviarPedido.addTarget(nil, action: #selector(actionEnviarPedido), forControlEvents: .TouchUpInside)
        
       
    }
    
    
    func agregarVistasEnOrden()
    {
        scrollview.layer.addSublayer(backgroundButonEnviarPedido)
        scrollview.addSubview(botonEnviarPedido)
        observacionesTextView.addSubview(placeholderObservacionesTextField)
        scrollview.addSubview(observacionesTextView)
        scrollview.layer.addSublayer(backgroundSpinnerFormaPago)
        scrollview.addSubview(spinnerFormaPago)
        scrollview.layer.addSublayer(backgroundSpinnerTelefono)
        scrollview.addSubview(spinnerTelefono)
        scrollview.addSubview(btnAgregarTelefono)
        scrollview.layer.addSublayer(backgroundSpinnerDireccion)
        scrollview.addSubview(spinnerDireccion)
        scrollview.addSubview(btnAgregarDireccion)
        
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
    
    func actionAgregarDireccion(sender: AnyObject)
    {
        agregarDireccion()
    }
    
    func actionAgregarTelefono(sender: AnyObject)
    {
        agregarTelefono()
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
        
        if spinnerFormaPago.selectedIndice == 0 || spinnerTelefono.selectedIndice == 0 || spinnerDireccion.selectedIndice == 0
        {
            self.view.makeToast(message: "Todos los campos son obligatorios menos el de observaciones.", duration: 2, position: HRToastPositionCenter)
        }
        else
        {
            
            enviarPedidoBackendless()
            
        }
        
    }
    
    func agregarDireccion()
    {
        print("agregar direccion")
    }
    
    func agregarTelefono()
    {
        print("agregar telefono")
    }
    
    func volverCargarVista()
    {
        mensajeCompruebeConexionLabel.removeFromSuperview()
        volverCargarVistaBtn.removeFromSuperview()
        backgroundVolverCargarVistaBtn.removeFromSuperlayer()
        
        mensajeCompruebeConexionLabel = nil
        volverCargarVistaBtn = nil
        backgroundVolverCargarVistaBtn = nil
        
        cargarDatosBackendless()
    }
    
    func atras()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cargarDatosBackendless()
    {
        let user = backendless.userService.currentUser
        UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
        UIView.hr_setToastFontColor(color: UIColor.blackColor())
        presentWindow  = UIApplication.sharedApplication().keyWindow
        
        fondoTrasparenteAlertview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        
        let dataQueryDireccion = BackendlessDataQuery()
        dataQueryDireccion.whereClause = "user = '" + user.objectId + "' AND idciudad='" + ciudad.objectId!+"'"
        
        let optionsdireccion = QueryOptions()
        optionsdireccion.pageSize = 100
        dataQueryDireccion.queryOptions = optionsdireccion
        
        let queryDireccion = backendless.data.of(Direccion.ofClass())
        
        self.view.addSubview(fondoTrasparenteAlertview)
        presentWindow.makeToastActivity(message: "Cargando ...")
        queryDireccion.find(dataQueryDireccion, response: { (result: BackendlessCollection!) -> Void in
            
            self.listaDirecciones = result.getCurrentPage() as! [Direccion]
            
            let dataQueryTelfono = BackendlessDataQuery()
            dataQueryTelfono.whereClause = "user = '" + user.objectId + "' AND idciudad='" + self.ciudad.objectId!+"'"
            
            let optionstelfono = QueryOptions()
            optionstelfono.pageSize = 100
            dataQueryTelfono.queryOptions = optionstelfono
            
            let queryTelfono = self.backendless.data.of(Telefono.ofClass())
            queryTelfono.find(dataQueryTelfono, response: { (result: BackendlessCollection!) -> Void in
                
                self.listaTelefonos = result.getCurrentPage() as! [Telefono]
                
                let dataQueryFormaPago = BackendlessDataQuery()
                dataQueryFormaPago.whereClause = "ciudad='" + self.ciudad.objectId! + "' AND activado= TRUE"
                
                let queryFormaPago = self.backendless.data.of(Formapago.ofClass())
                queryFormaPago.find(dataQueryFormaPago, response: { (result: BackendlessCollection!) -> Void in
                    
                    self.listaFormaPagos = result.getCurrentPage() as! [Formapago]
                    
                    var listadirecciones = Array<String>()
                    
                    listadirecciones.append("Seleccione dirección")
                    
                    for dire in self.listaDirecciones
                    {
                        listadirecciones.append(dire.direccion!)
                    }
                    
                    var listatelefonos = Array<String>()
                    
                    listatelefonos.append("Seleccione teléfono")
                    
                    for tel in self.listaTelefonos
                    {
                        listatelefonos.append(tel.numero!)
                    }
                    
                    var listaformapago = Array<String>()
                    
                    listaformapago.append("Seleccione forma de pago")
                    
                    for fp in self.listaFormaPagos
                    {
                        listaformapago.append(fp.nombre!)
                    }
                    
                    self.crearScrollView()
                    self.crearMensajeSeleccionar()
                    self.crearSpinnerDireccion(listadirecciones)
                    self.crearSpinnerTelefono(listatelefonos)
                    self.crearSpinnerFormaPago(listaformapago)
                    self.crearCajaTextoObservaciones()
                    self.crearBotonEnviarPedido()
                    self.agregarVistasEnOrden()
                    
                    self.fondoTrasparenteAlertview.removeFromSuperview()
                    self.presentWindow.hideToastActivity()
                    self.presentWindow = nil
                    self.fondoTrasparenteAlertview = nil
                    
                    }, error: { (fault: Fault!) -> Void in
                        
                        self.listaDirecciones = nil
                        self.listaTelefonos = nil
                        self.presentWindow.hideToastActivity()
                        self.presentWindow = nil
                        self.fondoTrasparenteAlertview.removeFromSuperview()
                        self.fondoTrasparenteAlertview = nil
                        self.crearMensajeCompruebeConexion()
                })
                
                
                }, error: { (fault: Fault!) -> Void in
                    
                    self.listaDirecciones = nil
                    self.presentWindow.hideToastActivity()
                    self.presentWindow = nil
                    self.fondoTrasparenteAlertview.removeFromSuperview()
                    self.fondoTrasparenteAlertview = nil
                    self.crearMensajeCompruebeConexion()
                })
            
            }, error: { (fault: Fault!) -> Void in
                
                self.presentWindow.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertview.removeFromSuperview()
                self.fondoTrasparenteAlertview = nil
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
        pedido.peddireccion = listaDirecciones[spinnerDireccion.selectedIndice! - 1].direccion!
        pedido.pedformapago = listaFormaPagos[spinnerFormaPago.selectedIndice! - 1].abreviatura
        pedido.pedtelefono = listaTelefonos[spinnerTelefono.selectedIndice! - 1].numero!
        pedido.pedpersonanombre = backendless.userService.currentUser.name
        pedido.pedobservaciones = observacionesTextView.text!
        
        
        pedido.ciudad = ciudad.objectId
        
        let dataQueryPedido = backendless.data.of(Pedido.ofClass())
        
        self.view.addSubview(fondoTrasparenteAlertview)
        presentWindow.makeToastActivity(message: "Enviando ...")
        
        dataQueryPedido.save(
            pedido,
            response: { (result: AnyObject!) -> Void in
                
                let obj = result as! Pedido
                print("Contact has been saved: \(obj.objectId)")
                
                
                
                var recipients = Array<String>()
                recipients.append(self.ciudad.email!)
                
                let asunto = "Nuevo pedido"
                let fp = self.listaFormaPagos[self.spinnerFormaPago.selectedIndice! - 1].nombre!
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = NSTimeZone(name: "America/Bogota")
                
                var mailBody = "<h1>Nuevo pedido</h1>"
                mailBody += "<b>Fecha y hora : </b>" + dateFormatter.stringFromDate(obj.created!) + "<br>"
                mailBody += "<b>Nombre cliente : </b>" + obj.pedpersonanombre! + "<br>"
                mailBody += "<b>Teléfono : </b>" + obj.pedtelefono! + "<br>"
                mailBody += "<b>Dirección : </b>" + obj.peddireccion! + "<br>"
                mailBody += "<b>Ciudad : </b>" + self.ciudad.nombre!
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
                
                self.comunicacionListaCiudadesControllerRegistradoController.seRealizoPedido()
                
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
    
    
    // MARK: DKDropMenuDelegate
    func itemSelectedWithIndex(index: Int, name: String , dKDropMenu : DKDropMenu) {
        print("indice : \(index) \(name) selected");
        
        
        
    }
    
    func collapsedChanged(dKDropMenu : DKDropMenu)
    {
        
        if dKDropMenu == spinnerDireccion
        {
            let tamanoBaseHeight = self.view.frame.height - 60
            let puntoInicialX = self.view.frame.width * 0.05
            let puntoInicialY = self.mensajeSeleccionar.frame.height
            
            let conteoDirecciones = CGFloat(listaDirecciones.count + 1)
            
            
            if(!spinnerDireccion.collapsed)
            {
                backgroundSpinnerDireccion.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.8, height: tamanoBaseHeight * 0.05 * conteoDirecciones)
            }
            else
            {
                backgroundSpinnerDireccion.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.8, height: tamanoBaseHeight * 0.05)
            }
            
        }
        else
        {
            if dKDropMenu == spinnerTelefono
            {
                let tamanoBaseHeight = self.view.frame.height - 60
                let puntoInicialX = self.view.frame.width * 0.05
                let puntoInicialY = self.mensajeSeleccionar.frame.height + spinnerDireccion.frame.height + tamanoBaseHeight * 0.04
                
                let conteoTelefonos = CGFloat(listaTelefonos.count + 1)
                
                
                if(!spinnerTelefono.collapsed)
                {
                    backgroundSpinnerTelefono.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.8, height: tamanoBaseHeight * 0.05 * conteoTelefonos)
                }
                else
                {
                    backgroundSpinnerTelefono.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.8, height: tamanoBaseHeight * 0.05)
                }
                
            }
            else
            {
                
                if dKDropMenu == spinnerFormaPago
                {
                    let tamanoBaseHeight = self.view.frame.height - 60
                    let puntoInicialX = self.view.frame.width * 0.05
                    let puntoInicialY = self.mensajeSeleccionar.frame.height + spinnerDireccion.frame.height + tamanoBaseHeight * 0.04 * 2 + spinnerTelefono.frame.height
                    
                    let conteoformapago = CGFloat(listaFormaPagos.count + 1)
                    
                    
                    if(!spinnerFormaPago.collapsed)
                    {
                        backgroundSpinnerFormaPago.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.05 * conteoformapago)
                    }
                    else
                    {
                        backgroundSpinnerFormaPago.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.05)
                    }
                    
                }
            }
        }
        
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
        
        
        
        imagenBtnAtras = nil
        btnAtras = nil
        backgroundTitulo = nil
        tituloLabel = nil
        
        
        if scrollview != nil
        {
            mensajeSeleccionar.removeFromSuperview()
            mensajeSeleccionar = nil
            
            backgroundSpinnerTelefono.removeFromSuperlayer()
            spinnerTelefono.removeFromSuperview()
            btnAgregarTelefono.removeFromSuperview()
            btnAgregarTelefono = nil
            imagenAgrearTelefono = nil
            spinnerTelefono.delegate = nil
            spinnerTelefono = nil
            backgroundSpinnerTelefono = nil
            
            backgroundSpinnerDireccion.removeFromSuperlayer()
            spinnerDireccion.removeFromSuperview()
            btnAgregarDireccion.removeFromSuperview()
            btnAgregarDireccion = nil
            imagenAgrearDireccion = nil
            spinnerDireccion.delegate = nil
            spinnerDireccion = nil
            backgroundSpinnerDireccion = nil
            
            backgroundSpinnerFormaPago.removeFromSuperlayer()
            spinnerFormaPago.removeFromSuperview()
            spinnerFormaPago.delegate = nil
            spinnerFormaPago = nil
            backgroundSpinnerFormaPago = nil
            
            backgroundObservacionesTextView.removeFromSuperlayer()
            placeholderObservacionesTextField.removeFromSuperview()
            observacionesTextView.removeFromSuperview()
            
            observacionesTextView.delegate = nil
            observacionesTextView = nil
            placeholderObservacionesTextField = nil
            backgroundObservacionesTextView = nil
            
            botonEnviarPedido.removeFromSuperview()
            backgroundButonEnviarPedido.removeFromSuperlayer()
            
            botonEnviarPedido = nil
            backgroundButonEnviarPedido = nil
            
            scrollview.removeFromSuperview()
            scrollview = nil

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
        
       
        
        listaDirecciones = nil
        listaTelefonos = nil
        listaFormaPagos = nil
        
        comunicacionListaCiudadesControllerRegistradoController = nil
        self.view.removeFromSuperview()
        debugPrint("se va a dealloc registradoViewController")
    }

}
