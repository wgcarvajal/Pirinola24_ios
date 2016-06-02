//
//  NoRegistradoViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 1/06/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class NoRegistradoViewController: UIViewController , DKDropMenuDelegate
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
    
    var listaCiudades : Array<Ciudad>!
    
    var scrollview: UIScrollView!
    
    var contenidoheigth : CGFloat!
    
    
    var mensajeCompruebeConexionLabel : UILabel!
    var backgroundVolverCargarVistaBtn : CAGradientLayer!
    var volverCargarVistaBtn : UIButton!
    
    
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
        spinnerCiudad = DKDropMenu(frame : CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.06))
        
        spinnerCiudad.addItems(listaCiu)
        
        backgroundSpinnerCiudad = CAGradientLayer().amarilloDegradado()
        backgroundSpinnerCiudad.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.06)
        imagenSpinnerCiudad = UIImage(named: "flecha_abajo")
        iconoSpinnerCiudad = UIImageView(frame: CGRect(x: spinnerCiudad.frame.width - spinnerCiudad.frame.height * 0.5 - spinnerCiudad.frame.height * 0.25 , y: spinnerCiudad.frame.height * 0.25, width: spinnerCiudad.frame.height * 0.5, height: spinnerCiudad.frame.height * 0.5))
        
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
        spinnerCiudad.itemHeight = tamanoBaseHeight * 0.06
        
        self.view.layer.addSublayer(backgroundSpinnerCiudad)
        self.view.addSubview(spinnerCiudad)
    }
    
    func crearScrollView()
    {
        let tamanoBaseHeight = self.view.frame.height - 60
        let puntoInicial = 60 + logoImageView.frame.height + (self.view.frame.height * 0.03) * 3 + (tamanoBaseHeight * 0.06)
        
        let altura = self.view.frame.height - (60 + logoImageView.frame.height + (self.view.frame.height * 0.03) * 3 + tamanoBaseHeight * 0.06 )
        scrollview = UIScrollView()
        scrollview.frame = CGRect(x: 0, y: puntoInicial, width: self.view.frame.width, height: altura )
        
        scrollview.backgroundColor = UIColor.blueColor()
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
        
        
        
       /* BackendlessDataQuery dataQueryformapago= new BackendlessDataQuery();
        List<String>formapagoSelect=new ArrayList<>();
        formapagoSelect.add("objectId");
        formapagoSelect.add("nombre");
        formapagoSelect.add("abreviatura");
        dataQueryformapago.setProperties(formapagoSelect);
        dataQueryformapago.setWhereClause("activado = TRUE AND ciudad='"+ciudadid+"'");
        pd = ProgressDialog.show(this, getResources().getString(R.string.txt_cargando_vista), getResources().getString(R.string.por_favor_espere), true, false);
        
        final Context context= this;
        Backendless.Persistence.of(Formapago.class).find(dataQueryformapago, new AsyncCallback<BackendlessCollection<Formapago>>() {
        @Override
        public void handleResponse(final BackendlessCollection<Formapago> fp) {*/
        
        
        
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
                scrollview.removeFromSuperview()
                
                self.view.layer.addSublayer(backgroundSpinnerCiudad)
                self.view.addSubview(spinnerCiudad)
                
            }
            else
            {
                cargarFormaPagoBackendless(listaCiudades[index - 1].objectId!)
                
                /*if scrollview != nil && scrollview.isDescendantOfView(self.view)
                {
                    scrollview.removeFromSuperview()
                    scrollview = nil
                }
                
                spinnerCiudad.removeFromSuperview()
                backgroundSpinnerCiudad.removeFromSuperlayer()
                
                crearScrollView()
                self.view.addSubview(scrollview)
                self.view.layer.addSublayer(backgroundSpinnerCiudad)
                self.view.addSubview(spinnerCiudad)*/
                
                
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
                backgroundSpinnerCiudad.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.06 * conteoCiudades)
            }
            else
            {
                backgroundSpinnerCiudad.frame = CGRect(x: puntoInicialX, y: puntoInicialY, width: self.view.frame.width * 0.9, height: tamanoBaseHeight * 0.06)
            }
            
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
        
        self.view.removeFromSuperview()
        debugPrint("se va a dealloc NoRegistradoViewController")
    }

}
