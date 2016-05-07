//
//  ViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 27/04/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource,ComunicacionControllerPrincipal , SideBarDelegate
{
    var pageViewController : UIPageViewController!
    var pageTitles : NSArray!
    var sideBar : SideBar = SideBar()
    
    var backendless = Backendless.sharedInstance()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let background = CAGradientLayer().amarilloDegradado()
        
        background.frame = self.view.bounds
        
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        loadDatosRemotos()
    }
    
    func loadDatosRemotos()
    {
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
                    
                    },
                    error: { (fault: Fault!) -> Void in
                        print("Server reported an error: \(fault)")
                })
                
                
                
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
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
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
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
    
    func irApedido()
    {
        self.performSegueWithIdentifier("irPedido", sender: self)
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
            default:
            break
        }
    }
    
    

}

