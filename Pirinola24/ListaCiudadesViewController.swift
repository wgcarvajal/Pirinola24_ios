//
//  ListaCiudadesViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 3/06/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

protocol ComunicacionPedidoControllerListaCiudadesController
{
    func seRealizoPedido()
}

class ListaCiudadesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , ComunicacionListaCiudadesControllerRegistradoController
{
    
    var fondoTrasparenteAlertview : UIView!
    var presentWindow : UIWindow!
    
    var tituloLabel : UILabel!
    var backgroundTitulo: CAGradientLayer!
    var btnAtras : UIButton!
    var imagenBtnAtras : UIImage!
    var mensajeSeleccioneCiudad : UILabel!
    
    let backendless = Backendless.sharedInstance()
    
    var ciudadesTableView: UITableView!
    var listaCiudades : Array<Ciudad>!
    
    var mensajeCompruebeConexionLabel : UILabel!
    var backgroundVolverCargarVistaBtn : CAGradientLayer!
    var volverCargarVistaBtn : UIButton!
    
    var comunicacionPedidoControllerListaCiudadesController : ComunicacionPedidoControllerListaCiudadesController!
    
    var pedidoRealizado : Int = 0
    

    var indiceCiudadSeleccionado : Int!
    
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
    
    override func viewWillAppear(animated: Bool) {
        
        if listaCiudades == nil
        {
            cargarCiudadesBackendless()
        }
        
        if pedidoRealizado == 1
        {
            pedidoRealizado = 0
            
            comunicacionPedidoControllerListaCiudadesController.seRealizoPedido()
            atras()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let vc = segue.destinationViewController as! RegistradoViewController
        vc.comunicacionListaCiudadesControllerRegistradoController = self
        vc.ciudad = listaCiudades[indiceCiudadSeleccionado]
    }
 
    
    
    // MARK: - funciones de interfaz grafica
    
    func crearVistas()
    {
        crearTituloVista()
        crearBotonAtras()
        crearMensajeSeleccioneCiudad()
        
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
    
    
    func crearMensajeSeleccioneCiudad()
    {
        mensajeSeleccioneCiudad = UILabel(frame: CGRect(x: self.view.frame.width * 0.05, y: 60 , width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.15))
        
        mensajeSeleccioneCiudad.numberOfLines = 2
        
        mensajeSeleccioneCiudad.textColor = UIColor.redColor()
        
        mensajeSeleccioneCiudad.text = "Seleccioné la ciudad donde te encuentras."
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            mensajeSeleccioneCiudad.font = UIFont(name: "Segoe Print", size: 16)
            break
            
        case .Pad:
            mensajeSeleccioneCiudad.font = UIFont(name: "Segoe Print", size: 26)
            break
            
        default:
            break
        }
        
        self.view.addSubview(mensajeSeleccioneCiudad)
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
    
    func crearTableViewCiudades()
    {
        ciudadesTableView = UITableView(frame: CGRect(x: 0  , y: 60 + mensajeSeleccioneCiudad.frame.height + self.view.frame.height * 0.03 , width: self.view.frame.width * 0.95 , height: self.view.frame.height - (60 + mensajeSeleccioneCiudad.frame.height + self.view.frame.height * 0.03) ), style: UITableViewStyle.Plain)
        ciudadesTableView.delegate      =   self
        ciudadesTableView.dataSource    =   self
        ciudadesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        ciudadesTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(ciudadesTableView)
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

    
    // MARK: - logica de negocio
    
    
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
        dataQueryCiudad.whereClause = "activado = TRUE"
        
        
        let queryCiudad = backendless.data.of(Ciudad.ofClass())
        
        self.view.addSubview(fondoTrasparenteAlertview)
        presentWindow.makeToastActivity(message: "Cargando ...")
        queryCiudad.find(dataQueryCiudad, response: { (result: BackendlessCollection!) -> Void in
            
            self.listaCiudades = result.getCurrentPage() as! [Ciudad]
            
            self.fondoTrasparenteAlertview.removeFromSuperview()
            self.presentWindow.hideToastActivity()
            self.presentWindow = nil
            self.fondoTrasparenteAlertview = nil
            self.crearTableViewCiudades()
            
            }, error: { (fault: Fault!) -> Void in
                
                self.presentWindow.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertview.removeFromSuperview()
                self.fondoTrasparenteAlertview = nil
                self.crearMensajeCompruebeConexion()
        })

    }
    
    // MARK: - funciones TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return listaCiudades.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
       
        let altoCelda = self.view.frame.height * 0.06
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clearColor()
        
        let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        
        let separatorSelected = UILabel(frame: CGRect(x: self.view.frame.width * 0.05, y: altoCelda - 1, width: self.view.frame.width * 0.95, height: 0.5))
        separatorSelected.backgroundColor = UIColor.redColor()
        
        selectedView.backgroundColor = UIColor.clearColor()
        selectedView.addSubview(separatorSelected)
        cell.selectedBackgroundView = selectedView
        
        let Separator = UILabel(frame: CGRect(x: self.view.frame.width * 0.05, y: altoCelda - 1, width: self.view.frame.width * 0.95, height: 0.5))
        Separator.backgroundColor = UIColor.redColor()
        
        
        cell.textLabel!.text = listaCiudades [indexPath.row].nombre
        cell.textLabel?.textColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        
        let icono = UIImageView(frame: CGRect(x: self.view.frame.width * 0.85, y: (altoCelda / 2) - (altoCelda * 0.6) / 2, width: self.view.frame.width * 0.1, height: altoCelda * 0.6))
        
        icono.image = UIImage(named: "flecha_derecha_redonda")
        
        
        cell.addSubview(Separator)
        cell.addSubview(icono)
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            cell.textLabel?.font = UIFont(name: "Segoe Print", size: 16)
            break
            
        case .Pad:
            cell.textLabel?.font = UIFont(name: "Segoe Print", size: 26)
            break
            
        default:
            break
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        indiceCiudadSeleccionado = indexPath.row
        performSegueWithIdentifier("irRegistrado", sender: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.view.frame.height * 0.06
    }
    
    // MARK: - funcion comunicacion ListaCiudadesController con  RegistradoController
    
    func seRealizoPedido() {
        
        pedidoRealizado = 1
    }
    
    //MARK: - funcion dinit
    
    deinit
    {
        btnAtras.removeFromSuperview()
        backgroundTitulo.removeFromSuperlayer()
        tituloLabel.removeFromSuperview()
        mensajeSeleccioneCiudad.removeFromSuperview()
        
        imagenBtnAtras = nil
        btnAtras = nil
        backgroundTitulo = nil
        tituloLabel = nil
        mensajeSeleccioneCiudad = nil
        
       
        
        if mensajeCompruebeConexionLabel != nil
        {
            mensajeCompruebeConexionLabel.removeFromSuperview()
            backgroundVolverCargarVistaBtn.removeFromSuperlayer()
            volverCargarVistaBtn.removeFromSuperview()
            
            volverCargarVistaBtn = nil
            backgroundVolverCargarVistaBtn = nil
            mensajeCompruebeConexionLabel = nil
        }
        
        if ciudadesTableView != nil
        {
            ciudadesTableView.removeFromSuperview()
            ciudadesTableView.dataSource = nil
            ciudadesTableView.delegate = nil
            
            ciudadesTableView = nil
            
        }
        listaCiudades = nil
        comunicacionPedidoControllerListaCiudadesController = nil
        self.view.removeFromSuperview()
        
        debugPrint("se va a dealloc ListaCiudadesViewController")
    }

}
