//
//  ViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 27/04/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, ComunicacionControllerPrincipal, SideBarDelegate
{
    var pageViewController : UIPageViewController!
    var pageTitles : NSArray!
    var sideBar : SideBar = SideBar()
    var presentWindow : UIWindow?
    
    var backendless = Backendless.sharedInstance()
    
    var alertView: UIView!
    var fondoTrasparenteAlertView:UIView!
    var cerrar_button: UIButton!
    var cancel_button: UIButton!
    var tituProducto : UILabel!
    var descripcion:UILabel!
    
    var imagenIntro : UIImage?
    var imageViewIntro : UIImageView?
    
    var mensajeSinConexion : UILabel?
    var btnVolverACargarVista : UIButton?
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        let background = CAGradientLayer().amarilloDegradado()
        
        background.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
        
        self.view.layer.insertSublayer(background, atIndex: 0)
        self.calcularTamanos()
        self.animacionPantallaInicial()
    }
    
    func inicializarMensajeSinconexion()
    {
        mensajeSinConexion = UILabel(frame: CGRect(x: self.view.frame.width * 0.05, y: (self.view.frame.height/2) - 50, width: self.view.frame.width - (self.view.frame.width * 0.05 * 2), height: 100))
        
        mensajeSinConexion?.text = "Compruebe su conexión a internet...."
        mensajeSinConexion?.textColor = UIColor.whiteColor()
        mensajeSinConexion?.font = UIFont(name: "Segoe Print", size: 16)
        mensajeSinConexion?.numberOfLines = 2
        mensajeSinConexion?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        mensajeSinConexion?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        mensajeSinConexion?.layer.borderColor = UIColor.whiteColor().CGColor
        mensajeSinConexion?.layer.borderWidth = 1.0
        
        btnVolverACargarVista = UIButton(frame: CGRect(x: self.view.frame.width * 0.05, y: self.view.frame.height - 40, width: self.view.frame.width - (self.view.frame.width * 0.05 * 2), height: 30))
        
        btnVolverACargarVista?.setTitle("Volver a cargar la vista", forState: UIControlState.Normal)
        btnVolverACargarVista?.titleLabel?.font = UIFont(name: "Matura MT Script Capitals",size: 18)
        
        let fondobtnVolver = CAGradientLayer().rojoDegradado()
        fondobtnVolver.frame = CGRect(x: 0, y: 0, width: self.btnVolverACargarVista!.frame.width, height: self.btnVolverACargarVista!.frame.height)
        
        self.btnVolverACargarVista?.addTarget(self, action: #selector(clickVolverCargarVista), forControlEvents: .TouchUpInside)
        
        btnVolverACargarVista?.layer.insertSublayer(fondobtnVolver, atIndex: 0)
        
        self.view.addSubview(mensajeSinConexion!)
        self.view.addSubview(btnVolverACargarVista!)
    }
    
    func clickVolverCargarVista(sender: AnyObject)
    {
        quitarMensajeSinConexion()
        self.loadDatosRemotos()
    }
    
    func quitarMensajeSinConexion()
    {
        self.mensajeSinConexion?.removeFromSuperview()
        self.btnVolverACargarVista?.removeFromSuperview()
        
        self.mensajeSinConexion = nil
        self.btnVolverACargarVista = nil
    }
    
    func animacionPantallaInicial()
    {
        
        imagenIntro = UIImage.gifWithName("pirinola_introgif")
        imageViewIntro = UIImageView(image: imagenIntro)
        imageViewIntro!.frame = CGRect(x: 0, y: (self.view.frame.height / 2) - ( (height: self.view.frame.width * 0.74) / 2 ), width: self.view.frame.width, height: self.view.frame.width * 0.74)
        
        self.view.addSubview(imageViewIntro!)
        
        irViewController()
    }
    
    func irViewController()
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            sleep(7)
            dispatch_async(dispatch_get_main_queue())
            {
                self.imageViewIntro?.removeFromSuperview()
                self.imageViewIntro = nil
                self.imagenIntro = nil
                self.loadDatosRemotos()
            }
        }
        
    }
    
    
    func calcularTamanos()
    {
        switch UIDevice.currentDevice().userInterfaceIdiom
        {
            case .Phone:
                
                print("es iphone")
                AppUtil.sizeTituloSubcategoria = 21.0
                AppUtil.sizeOpcionMenu = 21.0
                AppUtil.altoCeldaOpcionMenu = 40.0
            
            break
        
            case .Pad:
                AppUtil.sizeTituloSubcategoria = 30.0
                AppUtil.sizeOpcionMenu = 45.0
                AppUtil.altoCeldaOpcionMenu = 70.0

            break
            
            default:
                
            break
        }
    }
    
    func loadDatosRemotos()
    {
        UIView.hr_setToastThemeColor(color: UIColor.whiteColor())
        UIView.hr_setToastFontColor(color: UIColor.blackColor())
        presentWindow = UIApplication.sharedApplication().keyWindow
        
        var subcategoriaSelect = Array<String>()
        subcategoriaSelect.append("objectId")
        subcategoriaSelect.append("imgTitulo")
        subcategoriaSelect.append("tipoFragment")
        subcategoriaSelect.append("subcatnombre")
        subcategoriaSelect.append("domicilio")
        subcategoriaSelect.append("minimopedido")
        
        
        let dataQuerySubcategoria = BackendlessDataQuery()
        let queryOptionSubcategoria = BackendlessDataQuery().queryOptions
        dataQuerySubcategoria.properties = subcategoriaSelect
        queryOptionSubcategoria.sortBy(["posicion asc"])
        dataQuerySubcategoria.queryOptions = queryOptionSubcategoria
        
        
        let querySubcategoria = backendless.data.of(Subcategoria.ofClass())
        presentWindow!.makeToastActivity(message: "Cargando...")
        querySubcategoria.find(dataQuerySubcategoria,
            response: { (result: BackendlessCollection!) -> Void in
                AppUtil.listaSubcategorias = result.getCurrentPage() as! [Subcategoria]
                
                
                
                var productoSelect = Array<String>()
                productoSelect.append("objectId");
                productoSelect.append("precio");
                productoSelect.append("proddescripcion");
                productoSelect.append("prodnombre");
                productoSelect.append("subcategoria");
                productoSelect.append("imgFile");
                
                let dataQueryProducto = BackendlessDataQuery()
                let queryOptionProducto = BackendlessDataQuery().queryOptions
                
                dataQueryProducto.properties = productoSelect
                queryOptionProducto.sortBy(["posicion asc"])
                queryOptionProducto.pageSize = 100
                dataQueryProducto.queryOptions = queryOptionProducto
                
                let queryProducto = self.backendless.data.of(Producto.ofClass())
                queryProducto.find(dataQueryProducto, response:  { (result: BackendlessCollection!) -> Void in
                    
                    AppUtil.data = result.getCurrentPage() as! [Producto]
                     self.mostrarPagerView()
                    self.presentWindow!.hideToastActivity()
                    self.presentWindow = nil
                    
                    },
                    error: { (fault: Fault!) -> Void in
                        print("Server reported an error: \(fault)")
                        self.presentWindow!.hideToastActivity()
                        self.presentWindow = nil
                        self.inicializarMensajeSinconexion()
                })
                
                
                
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
                self.presentWindow!.hideToastActivity()
                self.presentWindow = nil
                self.inicializarMensajeSinconexion()
        })
    }
    
    func mostrarPagerView()
    {
        self.pageTitles = NSArray(objects: "Explore", "Today Widget")
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as ContentViewController
        
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0,30, self.view.frame.width, self.view.frame.height - 60)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.pageViewController.view.frame.width, self.view.frame.height)
        
        let anchoM = self.view.frame.size.width - 50
        let altoL = ((self.view.frame.size.width - 50)/3) + 30
        
        
        sideBar = SideBar(sourceView: self.view, menuItems: ["Logo", "Tu Pedido", "Contáctenos"], anchoMenu: anchoM, altoEspacioLogo: altoL)
        
        sideBar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func viewControllerAtIndex(index: Int)-> ContentViewController
    {
        if ((AppUtil.listaSubcategorias.count == 0) || (index >= AppUtil.listaSubcategorias.count))
        {
            return ContentViewController()
        }
        
        let vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        vc.pageIndex = index
        vc.subcategoriaTitulo = AppUtil.listaSubcategorias[index].subcatnombre
        vc.tipoFrament = AppUtil.listaSubcategorias[index].tipoFragment
        vc.comunicacionControllerPrincipal = self
        vc.subcategoriaId = AppUtil.listaSubcategorias[index].objectId
        
        return vc        
    }
    
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if ( (index == 0) || (index  == NSNotFound))
        {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index  == NSNotFound)
        {
            return nil
        }
        
        index += 1
        
        if ( index == AppUtil.listaSubcategorias.count)
        {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return AppUtil.listaSubcategorias.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }   
    
    
    
    func abrirMenuPrincipal()
    {
        
        sideBar.showSideBar(true)
      
    }
    
    func irPedido()
    {
        irApedido()
        
    }
    
    
    //MARK: - funciones logica de negocio
    
    
    
    func irAcontacto()
    {
        
         self.performSegueWithIdentifier("irContacto", sender: nil)
        
        
    }
    
    func irApedido()
    {
        self.performSegueWithIdentifier("irPedido", sender: nil)
    }
    
    
    func creandoDialogDescripcionProducto()
    {
        fondoTrasparenteAlertView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        fondoTrasparenteAlertView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        alertView = UIView(frame: CGRect(x: self.view.center.x - ((self.view.frame.width - 60) / 2), y: self.view.center.y - ((self.view.frame.width - 60) / 2), width: self.view.frame.width - 60, height: self.view.frame.width - 60))
        
        alertView.backgroundColor = UIColor.whiteColor()
        
        tituProducto = UILabel(frame: CGRect(x: 0 , y: 0, width: alertView.frame.width, height: 30))
        tituProducto.backgroundColor = UIColor.clearColor()
        tituProducto.textAlignment = NSTextAlignment.Center
        tituProducto.font = UIFont(name:"Matura MT Script Capitals", size: 21)
        tituProducto.textColor = UIColor.whiteColor()
        
        
        let fondotituloproducto = CAGradientLayer().rojoDegradado()
        fondotituloproducto.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: 30)
        
        
        descripcion = UILabel(frame: CGRect(x: 5, y: 30, width: alertView.frame.width-10, height: alertView.frame.height-30 - 35))
        descripcion.textColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        descripcion.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descripcion.numberOfLines = 7
        descripcion.textAlignment = NSTextAlignment.Center
        descripcion.backgroundColor = UIColor.clearColor()
        descripcion.font = UIFont(name: "Segoe Print",size: 14)
        
        
        let fondoBoton = CAGradientLayer().amarilloDegradado()
        fondoBoton.frame =  CGRect(x: 0, y: 0, width: 60, height: 30)
        cerrar_button = UIButton(frame: CGRect(x: (alertView.frame.width / 2) - 30, y: alertView.frame.height - 35, width: 60, height: 30))
        cerrar_button.backgroundColor = UIColor.clearColor()
        cerrar_button.setTitle("Cerrar", forState: UIControlState.Normal)
        cerrar_button.titleLabel?.font = UIFont(name:"Matura MT Script Capitals",size: 14.0)
        cerrar_button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cerrar_button.addTarget(self, action: #selector(onClick_cerrar), forControlEvents: UIControlEvents.TouchUpInside)
        cerrar_button.layer.insertSublayer(fondoBoton, atIndex: 0)
        
        alertView.layer.insertSublayer(fondotituloproducto, atIndex: 0)
        alertView.addSubview(tituProducto)
        alertView.addSubview(descripcion)
        alertView.addSubview(cerrar_button)
        
        fondoTrasparenteAlertView.addSubview(alertView)
        
        self.alertView.alpha = 0
        self.tituProducto.alpha = 0
        self.cerrar_button.alpha = 0
        self.descripcion.alpha = 0
        self.fondoTrasparenteAlertView.alpha = 0
        
    }
    func eliminandoDialogDescripcionProducto()
    {
        self.alertView = nil
        self.tituProducto = nil
        self.cerrar_button = nil
        self.descripcion = nil
        self.fondoTrasparenteAlertView = nil
    }
    
    func onClick_cerrar()
    {
        cerrar_button.alpha = 0.5
        
        UIView.animateWithDuration(0.5, animations:{ ()-> Void in
            
            self.alertView.alpha = 0
            self.tituProducto.alpha = 0
            self.cerrar_button.alpha = 0
            self.descripcion.alpha = 0
            self.fondoTrasparenteAlertView.alpha = 0
            
        }){ (Bool) -> Void in
            
            self.fondoTrasparenteAlertView.removeFromSuperview()
            self.eliminandoDialogDescripcionProducto()
            
        }
        
    }
    
    func mostrarDescripcionProducto(nombreProducto: String, descripcionProducto: String)
    {
        self.creandoDialogDescripcionProducto()
        self.tituProducto.text = nombreProducto
        self.descripcion.text = descripcionProducto
        self.view.addSubview(fondoTrasparenteAlertView)
        
        UIView.animateWithDuration(0.5, animations:{ ()-> Void in
            
            self.alertView.alpha = 1
            self.tituProducto.alpha = 1
            self.cerrar_button.alpha = 1
            self.descripcion.alpha = 1
            self.fondoTrasparenteAlertView.alpha = 1
        })
    }

    
    // MARK: - funciones interface menu drawer
    
    func sideBarDidSelectButtonAtIndex(index: Int)
    {
        switch index
        {
            case 1:
                sideBar.showSideBar(false)
                irApedido()
            break
            case 2:
                sideBar.showSideBar(false)
                irAcontacto()
            break
            default:
            break
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        print("buenas")
    }
    
}

