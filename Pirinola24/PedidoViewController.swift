//
//  PedidoViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 6/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit
protocol ComunicacionPedidoControllerPrincipalController
{
    func seInicioSecion()
    func seCerroSecion()
}

class PedidoViewController: UIViewController , SideBarDelegate , UICollectionViewDelegate, UICollectionViewDataSource , ComunicacionControladorPedido , ComunicacionPedidoControllerLoginController ,ComunicacionPedidoControllerListaCiudadesController
{

    var sideBar : SideBar = SideBar()
    
    @IBOutlet  var tuPedidoLabel: UILabel!
    @IBOutlet  var botonAtras: UIButton!
    @IBOutlet  var botonMenuPrincipal: UIButton!
    @IBOutlet  var total: UILabel!
    @IBOutlet  var totalValor: UILabel!
    @IBOutlet  var domicilio: UILabel!
    @IBOutlet  var realizarPedido: UIButton!
    
    @IBOutlet  var collectionView: UICollectionView!
    
    var anchoCelda : CGFloat!
    var altoCelda : CGFloat!
    var tamanoCelda : CGSize?
    var imagenPlaceholder : UIImage?
    var espacioEntreceldas : UIEdgeInsets?
    var tamBotoncelda : CGFloat?
    var espacioBotonCelda : CGFloat?
    
    var presentWindow : UIWindow?
    var comunicacionPedidoController_PrincipalController : ComunicacionPedidoControllerPrincipalController?
    
    
    var irListaCiudades : Int = 0
    
    
    //dialgo Vaciar pedido
    
    var alertView: UIView?
    var fondoTrasparenteAlertView:UIView?
    var aceptar_button: UIButton?
    var cancelar_button: UIButton?
    var mensaje:UILabel?
    var iconoMensaje: UIImageView?
    
    var backgroundconfirmarPedido : CAGradientLayer!
    
    
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
        
        let background = CAGradientLayer().rojoDegradado()
        background.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.tuPedidoLabel.frame.height)
        
        self.tuPedidoLabel.backgroundColor = UIColor.clearColor()
        self.tuPedidoLabel.font = UIFont(name: "Matura MT Script Capitals", size: AppUtil.sizeTituloSubcategoria)
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        let anchoM = self.view.frame.size.width - 50
        let altoL = ((self.view.frame.size.width - 50)/3) + 30
        
        let backendless = Backendless.sharedInstance()
        let currentUser = backendless.userService.currentUser
        
        self.botonAtras.hidden = true
        
        if AppUtil.listaCarro.count > 0
        {
            
            if(currentUser == nil)
            {
                sideBar = SideBar(sourceView: self.view, menuItems: ["Logo", "Atras", "Vaciar Pedido"], anchoMenu: anchoM, altoEspacioLogo: altoL)
                buscarUsuarioLogueado()
            }
            else
            {
                sideBar = SideBar(sourceView: self.view, menuItems: ["Logo", "Atras", "Vaciar Pedido" ,"Cerrar Sesión"], anchoMenu: anchoM, altoEspacioLogo: altoL)
            }
            
            
            
        }
        else
        {
            if(currentUser == nil)
            {
                sideBar = SideBar(sourceView: self.view, menuItems: ["Logo", "Atras"], anchoMenu: anchoM, altoEspacioLogo: altoL)
                buscarUsuarioLogueado()
            }
            else
            {
                sideBar = SideBar(sourceView: self.view, menuItems: ["Logo", "Atras", "Cerrar Sesión"], anchoMenu: anchoM, altoEspacioLogo: altoL)
            }
        }
        
        
        sideBar.delegate = self
        
        
        self.fijar_tamanoCelda()
        self.fijar_espacio_entre_celdas()
        self.inicializarTamanosLetras()
        self.fijandoValores()
        self.fijar_tamano_boton_celda()
        
    
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if irListaCiudades == 1
        {
            irListaCiudades = 0
            self.performSegueWithIdentifier("irListaCiudades", sender: nil)
            
        }
        
    }
    
    func buscarUsuarioLogueado()
    {
        let backendless = Backendless.sharedInstance()
        
        backendless.userService.isValidUserToken(
            { (result : AnyObject!) -> () in
                if result.boolValue == true
                {
                    self.sideBar.sideBarTableViewController.tableData.append("Cerrar sesión")
                    self.sideBar.sideBarTableViewController.tableView.reloadData()
                }
                else
                {
                    if self.sideBar.sideBarTableViewController.tableData.count == 2
                    {
                        
                        self.botonMenuPrincipal.removeFromSuperview()
                        self.botonMenuPrincipal = nil
                        self.botonAtras.hidden = false
                    }
                    
                    
                    
                }
            },
            error: { (fault : Fault!) -> () in
                
                if self.sideBar.sideBarTableViewController.tableData.count == 2
                {
                    self.botonMenuPrincipal.removeFromSuperview()
                    self.botonMenuPrincipal = nil
                    self.botonAtras.hidden = false
                }
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - funciones de interfaz
    
    func  inicializarTamanosLetras()
    {
        var totalsize:CGFloat? = 0
        var valortotalsize:CGFloat? = 0
        var domiciliosize:CGFloat? = 0
        var btnrealizarpedidosize:CGFloat? = 0
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            totalsize = 24.0
            valortotalsize = 25.0
            domiciliosize = 12
            btnrealizarpedidosize = 20.0
            break
            
        case .Pad:
            totalsize = 30.0
            valortotalsize = 31.0
            domiciliosize = 15
            btnrealizarpedidosize = 25.0
            break
            
        default:
            
            break
        }
        
        let fondoBoton = CAGradientLayer().rojoDegradado()
        fondoBoton.frame = CGRect(x: 0, y: 0, width: self.realizarPedido.frame.width, height: self.realizarPedido.frame.height)
        
        self.realizarPedido.layer.insertSublayer(fondoBoton, atIndex: 0)
        
        self.realizarPedido.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.realizarPedido.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: btnrealizarpedidosize!)
        
        
        let colorRojo : UIColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        self.total.textColor = colorRojo
        self.total.font = UIFont(name: "Stackyard PERSONAL USE", size: totalsize!)
        
        self.totalValor.textColor = colorRojo
        self.totalValor.font = UIFont(name: "URW Bookman L", size: valortotalsize!)
        
        self.domicilio.textColor = colorRojo
        self.domicilio.font = UIFont(name: "Segoe Print", size: domiciliosize!)
        
    }
    
    func fijar_tamanoCelda()
    {
        let totalHeight: CGFloat
        let totalWidth: CGFloat
        
        
        
        totalHeight = (self.view.frame.height / 3)
        totalWidth = (self.view.frame.width / 3)
            
            
        self.anchoCelda = totalWidth-8
        self.altoCelda = totalHeight-10
        self.tamanoCelda = CGSizeMake(self.anchoCelda, self.altoCelda)
    }
    
    
    func fijar_espacio_entre_celdas()
    {
        self.espacioEntreceldas = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }
    
    func fijar_tamano_boton_celda()
    {
        self.tamBotoncelda = self.anchoCelda/4
        self.espacioBotonCelda = (self.anchoCelda / 8)-3
        
    }
    
    func crearVentanaConfirmacionPedido()
    {
        fondoTrasparenteAlertView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        alertView = UIView(frame: CGRect(x: self.view.frame.width * 0.03 , y: self.view.frame.height * 0.30, width: self.view.frame.width * 0.94, height: self.view.frame.height * 0.35))
        
        backgroundconfirmarPedido = CAGradientLayer().amarilloDegradado()
        backgroundconfirmarPedido.frame = CGRect(x: 0 , y: 0 , width: self.view.frame.width * 0.94, height: self.view.frame.height * 0.35)
        
        
        alertView?.layer.addSublayer(backgroundconfirmarPedido)
        
        
        let icono = UIImage(named: "pirinola_icono")
        iconoMensaje = UIImageView(frame: CGRect(x: alertView!.frame.width * 0.05  , y: alertView!.frame.width * 0.05  , width: alertView!.frame.height * 0.4, height: alertView!.frame.height * 0.3))
        
        iconoMensaje?.image = icono
        
        
        
        mensaje = UILabel(frame: CGRect(x: (alertView!.frame.width * 0.05) * 2 + iconoMensaje!.frame.width, y: 0, width: alertView!.frame.width - ((alertView!.frame.width * 0.05) * 3 + iconoMensaje!.frame.width), height: alertView!.frame.height * 0.75))
        
        mensaje?.text = "Hemos recibido su pedido, en contados minutos te llamaremos para confirmarlo. ¡...Gracias por elegirnos....!"
        
        mensaje?.textColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            mensaje?.font = UIFont(name: "Segoe Print", size:14)
            break
            
        case .Pad:
            mensaje?.font = UIFont(name: "Segoe Print", size:25)
            break
            
        default:
            break
        }

        mensaje?.numberOfLines = 10
        
        
        aceptar_button = UIButton(frame: CGRect(x: alertView!.frame.width / 2 - (alertView!.frame.width * 0.3) / 2, y: alertView!.frame.height - (alertView!.frame.height * 0.05) - alertView!.frame.height * 0.15  , width: alertView!.frame.width * 0.3, height: alertView!.frame.height * 0.15))
        
        
        
        
        
        let fondobotonAceptar = CAGradientLayer().rojoDegradado()
        fondobotonAceptar.frame = CGRect(x: 0, y: 0, width: alertView!.frame.width * 0.3, height: alertView!.frame.height * 0.15)
        
        aceptar_button!.layer.insertSublayer(fondobotonAceptar, atIndex:  0)
        
        aceptar_button?.setTitle("Aceptar", forState: UIControlState.Normal)
        aceptar_button?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            aceptar_button?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 16)
            break
            
        case .Pad:
            aceptar_button?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 26)
            break
            
        default:
            break
        }
        
        aceptar_button?.addTarget(self, action: #selector(actionAceptarConfirmarPedido), forControlEvents: .TouchUpInside)
        
        alertView?.addSubview(iconoMensaje!)
        alertView?.addSubview(mensaje!)
        alertView?.addSubview(aceptar_button!)
        fondoTrasparenteAlertView?.addSubview(self.alertView!)
        self.view.addSubview(fondoTrasparenteAlertView!)
        
    }
    
    
    // MARK: - funciones del collectionview
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return AppUtil.listaCarro.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let itemCarrito = AppUtil.listaCarro[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellpedido", forIndexPath: indexPath) as! CollectionViewCellPedido
        
        
        cell.urlimagen = itemCarrito.imagen
        cell.objectId = itemCarrito.objectId
        
        cell.comunicacionControladorPedido = self
        
        cell.iniciarBotones(self.tamBotoncelda!,ubicacionInicial: (self.altoCelda-(self.tamBotoncelda! * 2)), espacio: self.espacioBotonCelda!)
        
        if let image = itemCarrito.imagen!.cachedImage {
            // Cached: set immediately.
            cell.imagen.image = UIImage(data: image)
            cell.imagen.alpha = 1
        } else {
            // Not cached, so load then fade it in.
            cell.imagen.alpha = 0
            itemCarrito.imagen!.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                if cell.urlimagen == itemCarrito.imagen {
                    
                    cell.imagen.image = UIImage(data:image)
                    UIView.animateWithDuration(0.3) {
                        cell.imagen.alpha = 1
                    }
                }
            }
        }
        
        
        
        return cell
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        
        return self.espacioEntreceldas!
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        
        return self.tamanoCelda!
    }
    


    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "irLogin")
        {
            let vc = segue.destinationViewController as! LoginViewController
            vc.comunicacionPedidoControllerLoginController = self
        }
        else
        {
            if(segue.identifier == "irListaCiudades")
            {
                let vc = segue.destinationViewController as! ListaCiudadesViewController
                vc.comunicacionPedidoControllerListaCiudadesController = self
            }
        }
        
        
    }
     // MARK: - funciones Logica de negocio
    
    
    
    func crearMostrarDialogVaciarPedido()
    {
        
        self.crearDialogVaciarPedido()
        self.insertarMensajeDialogMostrarPedido()
        self.insertarBotonesDialogVaciarPedido()
        self.view.addSubview(self.fondoTrasparenteAlertView!)
        
    }
    
    func crearDialogVaciarPedido()
    {
        fondoTrasparenteAlertView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        alertView = UIView(frame: CGRect(x: 0 , y: (self.view.frame.height / 2) - 50, width: self.view.frame.width, height: self.view.frame.height * 0.2))
        
        alertView?.backgroundColor = UIColor.whiteColor()
        alertView?.layer.cornerRadius = 5
        
        fondoTrasparenteAlertView?.addSubview(self.alertView!)
    }
    
    func insertarMensajeDialogMostrarPedido()
    {
        mensaje = UILabel(frame: CGRect(x: (alertView!.frame.width / 2) - ((alertView!.frame.width * 0.55) / 2), y: alertView!.frame.height * 0.1, width: alertView!.frame.width * 0.55, height: alertView!.frame.width * 0.15))
        
        
        mensaje?.text = "Deseas vaciar el pedido?"
        mensaje?.textColor = UIColor.redColor()
        
        let icono = UIImage(named: "logo_pirinola")
        iconoMensaje = UIImageView(frame: CGRect(x: (alertView!.frame.width / 2) - (alertView!.frame.width * 0.15) - ((alertView!.frame.width * 0.55) / 2), y: alertView!.frame.height * 0.1, width: alertView!.frame.width * 0.15, height: alertView!.frame.width * 0.15))
        
        iconoMensaje?.image = icono
        
        
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            mensaje?.font = UIFont(name: "Segoe Print", size:14)
            break
            
        case .Pad:
            mensaje?.font = UIFont(name: "Segoe Print", size:25)
            break
            
        default:
            break
        }
        
        alertView?.addSubview(iconoMensaje!)
        alertView?.addSubview(mensaje!)
    }
    
    func insertarBotonesDialogVaciarPedido()
    {
        cancelar_button = UIButton(frame: CGRect(x: alertView!.frame.width/2 - (alertView!.frame.width * 0.4) - 5 , y: alertView!.frame.height - (alertView!.frame.height * 0.3) - 5  , width: alertView!.frame.width * 0.4 , height: alertView!.frame.height * 0.3))
        
        cancelar_button?.setTitle("Cancelar", forState: UIControlState.Normal)
        cancelar_button?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 16)
        cancelar_button?.titleLabel?.textColor = UIColor.whiteColor()
        
       cancelar_button?.addTarget(self, action: #selector(cancelarVaciarPedido), forControlEvents: .TouchUpInside)
        
        aceptar_button = UIButton(frame: CGRect(x: (alertView!.frame.width/2) + 5 , y: alertView!.frame.height - (alertView!.frame.height * 0.3) - 5  , width: alertView!.frame.width * 0.4 , height: alertView!.frame.height * 0.3))
        
        aceptar_button?.setTitle("Aceptar", forState: UIControlState.Normal)
        
        aceptar_button?.titleLabel?.textColor = UIColor.whiteColor()
        
        aceptar_button?.addTarget(self, action: #selector(aceptarVaciarPedido), forControlEvents: .TouchUpInside)
        
        let fondobotonAceptar = CAGradientLayer().rojoDegradado()
        fondobotonAceptar.frame = CGRect(x: 0, y: 0, width: alertView!.frame.width * 0.4, height: alertView!.frame.height * 0.3)
        
        let fondobotonCancelar = CAGradientLayer().rojoDegradado()
        fondobotonCancelar.frame = CGRect(x: 0, y: 0, width: alertView!.frame.width * 0.4, height: alertView!.frame.height * 0.3)
        
        aceptar_button?.layer.insertSublayer(fondobotonAceptar, atIndex: 0)
        alertView?.addSubview(aceptar_button!)
        cancelar_button?.layer.insertSublayer(fondobotonCancelar, atIndex: 0)
        
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
        case .Phone:
            aceptar_button?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 16)
            cancelar_button?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 16)
        break
            
        case .Pad:
            aceptar_button?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 26)
            cancelar_button?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 26)
            break
            
        default:
            break
        }
        
        
        
        
        alertView?.addSubview(cancelar_button!)
    }
    
    func cancelarVaciarPedido(sender: AnyObject)
    {
        if self.fondoTrasparenteAlertView != nil  && self.fondoTrasparenteAlertView!.isDescendantOfView(self.view)
        {
            self.fondoTrasparenteAlertView?.removeFromSuperview()
            self.fondoTrasparenteAlertView = nil
            self.alertView = nil
            self.iconoMensaje = nil
            self.mensaje = nil
            self.aceptar_button = nil
            self.cancelar_button = nil
        }
    }
    
    func aceptarVaciarPedido(sender: AnyObject)
    {
        if self.fondoTrasparenteAlertView != nil  && self.fondoTrasparenteAlertView!.isDescendantOfView(self.view)
        {
            self.fondoTrasparenteAlertView?.removeFromSuperview()
            self.fondoTrasparenteAlertView = nil
            self.alertView = nil
            self.iconoMensaje = nil
            self.mensaje = nil
            self.aceptar_button = nil
            self.cancelar_button = nil
        }
        
        AppUtil.listaCarro.removeAll()
        self.collectionView.reloadData()
        self.totalValor.text = "$0"
        self.realizarPedido.removeFromSuperview()
        self.realizarPedido = nil
        
        
        UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
        UIView.hr_setToastFontColor(color: UIColor.whiteColor())
        
        self.view.makeToast(message: "Se ha vaciado el pedido.", duration: 2, position: HRToastPositionCenter)
        
        
        administrarDrawerDespuesDeVaciarPedido()
    }
    
    func vaciarPedido()
    {
        AppUtil.listaCarro.removeAll()
        self.collectionView.reloadData()
        self.totalValor.text = "$0"
        self.realizarPedido.removeFromSuperview()
        self.realizarPedido = nil
        administrarDrawerDespuesDeVaciarPedido()
    }
    
    func administrarDrawerDespuesDeVaciarPedido()
    {
        let backendless = Backendless.sharedInstance()
        let currentUser = backendless.userService.currentUser
        
        if currentUser == nil
        {            
            self.sideBar.sideBarTableViewController.tableData = ["Logo" , "Atras"]
            self.sideBar.sideBarTableViewController.tableView.reloadData()
            self.botonMenuPrincipal.removeFromSuperview()
            self.botonMenuPrincipal = nil
            self.botonAtras.hidden = false
        }
        else
        {
            self.sideBar.sideBarTableViewController.tableData = ["Logo" , "Atras" ,"Cerrar sesión"]
            self.sideBar.sideBarTableViewController.tableView.reloadData()
            
        }
    }
    
    func back_to_previus_controller()
    {
        tuPedidoLabel.removeFromSuperview()
        botonAtras.removeFromSuperview()
        if botonMenuPrincipal != nil && botonMenuPrincipal.isDescendantOfView(self.view)
        {
            botonMenuPrincipal.removeFromSuperview()
        }
        total.removeFromSuperview()
        totalValor.removeFromSuperview()
        domicilio.removeFromSuperview()
        
        if realizarPedido != nil && realizarPedido.isDescendantOfView(self.view)
        {
            realizarPedido.removeFromSuperview()
        }
        
        collectionView.removeFromSuperview()
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView = nil
        tuPedidoLabel = nil
        botonAtras = nil
        botonMenuPrincipal = nil
        total = nil
        totalValor = nil
        domicilio = nil
        realizarPedido = nil
        
        self.sideBar.delegate = nil
        
        self.sideBar.sideBarContainerView.removeFromSuperview()
        anchoCelda = nil
        altoCelda = nil
        tamanoCelda = nil
        imagenPlaceholder = nil
        espacioEntreceldas = nil
        tamBotoncelda = nil
        espacioBotonCelda = nil
        
        AppUtil.contadorUpdateCollectionview = 2
        comunicacionPedidoController_PrincipalController = nil
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func probandoFormatoNumeros()
    {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let costString = formatter.stringFromNumber(2399999)
        let modify = costString!.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        print(modify)
    }
    
    func fijandoValores()
    {
        let valorDomicilio = AppUtil.listaSubcategorias[0].domicilio
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        var stringDomicilio = formatter.stringFromNumber(valorDomicilio)
        stringDomicilio = stringDomicilio!.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.domicilio.text = "(Domicilio incluido $" + stringDomicilio! + ")"
        
        if AppUtil.listaCarro.count > 0
        {
            var valorT = valorDomicilio
            for itemcarrito in AppUtil.listaCarro
            {
                valorT += (itemcarrito.cantidad * itemcarrito.precio)
            }
            var stringValorTotal = formatter.stringFromNumber(valorT)
            stringValorTotal = stringValorTotal!.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            self.totalValor.text = "$" + stringValorTotal!
            
        }
        else
        {
            self.realizarPedido.hidden = true
            self.totalValor.text = "$0"
        }
        
    }
    
    
    func comprabarMinimoPedido() -> Bool
    {
        let valorDomicilio = AppUtil.listaSubcategorias[0].domicilio
        
        var valorT = valorDomicilio
        for itemcarrito in AppUtil.listaCarro
        {
            valorT += (itemcarrito.cantidad * itemcarrito.precio)
        }
        return  valorT >= AppUtil.listaSubcategorias[0].minimopedido
        
    }
    
    
    func realizar_pedido()
    {
        if comprabarMinimoPedido()
        {
            if Backendless.sharedInstance().userService.currentUser == nil
            {
                self.performSegueWithIdentifier("irLogin", sender: nil)
            }
            else
            {
                self.performSegueWithIdentifier("irListaCiudades", sender: nil)
            }
            
        }
        else
        {
            let valorminimoPedido = AppUtil.listaSubcategorias[0].minimopedido
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            var stringMinimoPedido = formatter.stringFromNumber(valorminimoPedido)
            stringMinimoPedido = stringMinimoPedido!.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
            UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
            UIView.hr_setToastFontColor(color: UIColor.whiteColor())            
            self.view.makeToast(message: "Valor minimo del pedido $" + stringMinimoPedido!, duration: 2, position: HRToastPositionCenter)
        }
    }
    
    func cerrarSesion()
    {
        
        UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
        UIView.hr_setToastFontColor(color: UIColor.blackColor())
        presentWindow  = UIApplication.sharedApplication().keyWindow
        
        fondoTrasparenteAlertView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.view.addSubview(fondoTrasparenteAlertView!)
        presentWindow!.makeToastActivity(message: "Cerrando sesión...")
        
        let backendless = Backendless.sharedInstance()
        backendless.userService.logout(
            { ( user : AnyObject!) -> () in
                print("User logged out.")
                
                self.presentWindow!.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertView!.removeFromSuperview()
                self.fondoTrasparenteAlertView = nil
                
                
                if AppUtil.listaCarro.count > 0
                {
                    self.sideBar.sideBarTableViewController.tableData = ["Logo", "Atras", "Vaciar Pedido"]
                }
                else
                {
                    self.sideBar.sideBarTableViewController.tableData = ["Logo", "Atras"]
                    self.botonMenuPrincipal.hidden = true
                    self.botonAtras.hidden = false
                }
                
                
                self.sideBar.sideBarTableViewController.tableView.reloadData()
                
                UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                
                self.view.makeToast(message: "Sesión cerrada.", duration: 2, position: HRToastPositionCenter)
                self.comunicacionPedidoController_PrincipalController?.seCerroSecion()
                backendless.userService.setStayLoggedIn(false)
                
            },
            error: { ( fault : Fault!) -> () in
                
                print("Server reported an error: \(fault)")
                
                self.presentWindow!.hideToastActivity()
                self.presentWindow = nil
                self.fondoTrasparenteAlertView!.removeFromSuperview()
                self.fondoTrasparenteAlertView = nil
                
                UIView.hr_setToastThemeColor(color: UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1))
                UIView.hr_setToastFontColor(color: UIColor.whiteColor())
                
                self.view.makeToast(message: "Compruebe su conexiòn a internet", duration: 2, position: HRToastPositionCenter)
                
                
        })
        
    }
    // MARK: - funciones interfaza menu drawer
    
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
        switch index
        {
            case 1:
                back_to_previus_controller()
            break
            
            case 2:
                
                sideBar.showSideBar(false)
                if AppUtil.listaCarro.count > 0
                {
                    
                    self.crearMostrarDialogVaciarPedido()
                }
                else
                {
                    cerrarSesion()
                }
                
            break
        
            case 3:
                sideBar.showSideBar(false)
                cerrarSesion()
            break
            default:
                
            break
        
        }
    }
   
    //MARK: - funciones eventos de click
    
    
    @IBAction func abrirMenuPrincipal(sender: AnyObject)
    {
        sideBar.showSideBar(true)
    }
    
    @IBAction func atrasAction(sender: AnyObject)
    {
        back_to_previus_controller()
    }
    
    
    @IBAction func actionRealizarPedido(sender: AnyObject)
    {
        realizar_pedido()
    }
    
    func actionAceptarConfirmarPedido(sender : AnyObject)
    {
        fondoTrasparenteAlertView?.removeFromSuperview()
        alertView?.removeFromSuperview()
        iconoMensaje?.removeFromSuperview()
        mensaje?.removeFromSuperview()
        aceptar_button?.removeFromSuperview()
        backgroundconfirmarPedido.removeFromSuperlayer()
        
        fondoTrasparenteAlertView = nil
        alertView = nil
        iconoMensaje = nil
        mensaje = nil
        aceptar_button = nil
        backgroundconfirmarPedido = nil
        back_to_previus_controller()
    }
    
    //MARK: - metodos de interface celda pedido
    
    func actualizarCollectionView()
    {
        collectionView.reloadData()
    }
    func actualizarTotal()
    {
        let valorDomicilio = AppUtil.listaSubcategorias[0].domicilio
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        if AppUtil.listaCarro.count > 0
        {
            var valorT = valorDomicilio
            for itemcarrito in AppUtil.listaCarro
            {
                valorT += (itemcarrito.cantidad * itemcarrito.precio)
            }
            var stringValorTotal = formatter.stringFromNumber(valorT)
            stringValorTotal = stringValorTotal!.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            self.totalValor.text = "$" + stringValorTotal!
            
        }
        else
        {
            self.realizarPedido.hidden = true
            self.totalValor.text = "$0"
        }
    }
    
    
    // MARK: - funciones interfaz de comunicacion con login controller
    
    func seInicioSecion()
    {
        self.sideBar.sideBarTableViewController.tableData = ["Logo", "Atras", "Vaciar Pedido" , "Cerrar Sesión"]
        self.sideBar.sideBarTableViewController.tableView.reloadData()        
        comunicacionPedidoController_PrincipalController?.seInicioSecion()
        irListaCiudades = 1
        
    }
    
    func seRealizoPedido()
    {
        print("Gracias por realizar el pedido")
        vaciarPedido()
        crearVentanaConfirmacionPedido()
    }
    
    
    // MARK: - Funcion deinit
    
    deinit
    {
        debugPrint("se va a dealloc pedidoViewController")
    }

    
}
