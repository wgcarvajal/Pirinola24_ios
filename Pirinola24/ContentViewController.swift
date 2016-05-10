//
//  ContentViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 27/04/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

protocol ComunicacionControllerPrincipal
{
    func abrirMenuPrincipal()
    func irPedido()
}

class ContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
   
    
    @IBOutlet weak var subcategoria: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageIndex: Int!
    var subcategoriaTitulo : String?
    var subcategoriaId : String?
    var listaProductos = Array<Producto>()
    var tipoFrament : Int!
    var anchoCelda : CGFloat!
    var altoCelda : CGFloat!
    var comunicacionControllerPrincipal: ComunicacionControllerPrincipal!
    var tamanoCelda : CGSize?
    var imagenPlaceholder : UIImage?
    var espacioEntreceldas : UIEdgeInsets?
    var tamBotoncelda : CGFloat?
    var espacioBotonCelda : CGFloat?
    
    var alertView: UIView!
    var cerrar_button: UIButton!
    var cancel_button: UIButton!
    var tituProducto : UILabel!
    var descripcion:UILabel!
    
    
    
    // MARK: - funciones propias del controlador
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let background = CAGradientLayer().rojoDegradado()
        background.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.subcategoria.frame.height)        
       
        
        self.view.layer.insertSublayer(background, atIndex:0 )
        self.subcategoria.text = self.subcategoriaTitulo
        self.subcategoria.font = UIFont(name: "Matura MT Script Capitals", size: AppUtil.sizeTituloSubcategoria)

        self.subcategoria.backgroundColor = UIColor.clearColor()
        self.imagenPlaceholder = UIImage.gifWithName("carga")
        self.cargarDatos()
        self.fijar_tamanoCelda()
        self.fijar_espacio_entre_celdas()
        self.fijar_tamano_boton_celda()
        self.creandoDialogDescripcionProducto()
        
        // Do any additional setup after loading the view.
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - funciones de la logica de negocio
    
    func cargarDatos()
    {
        
        for producto in AppUtil.data
        {
            if(producto.subcategoria == self.subcategoriaId)
            {
                self.listaProductos.append(producto)
            }
        }
        
    }
    
    func fijar_tamanoCelda()
    {
        let totalHeight: CGFloat
        let totalWidth: CGFloat
    
        if self.tipoFrament == 1
        {
            totalHeight = (self.view.frame.height / 2.5)
            totalWidth = (self.view.frame.width / 2)
        }
    
        else
        {
            if self.tipoFrament == 2
            {
                totalHeight = (self.view.frame.height / 3)
                totalWidth = (self.view.frame.width / 3)
            }
            else
            {
                totalHeight = (5.0)
                totalWidth = (5.0)
            }
        }
        self.anchoCelda = totalWidth-8
        self.altoCelda = totalHeight-10
        self.tamanoCelda = CGSizeMake(totalWidth-8, totalHeight-10)
    }
    
    func fijar_espacio_entre_celdas()
    {
        self.espacioEntreceldas = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }
    
    func fijar_tamano_boton_celda()
    {
        if self.tipoFrament==1
        {
           self.tamBotoncelda = self.anchoCelda/5
           self.espacioBotonCelda = (self.anchoCelda / 5)-3
        }
        else
        {
            self.tamBotoncelda = self.anchoCelda/4
            self.espacioBotonCelda = (self.anchoCelda / 8)-3
        }
    }
    
    func creandoDialogDescripcionProducto()
    {
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
        
        
        
    }
    
    func onClick_cerrar()
    {
        cerrar_button.alpha = 0.5
        
        UIView.animateWithDuration(0.5, animations:{ ()-> Void in
            
            self.alertView.alpha = 0
            self.tituProducto.alpha = 0
            self.cerrar_button.alpha = 0
            self.descripcion.alpha = 0
            
        }){ (Bool) -> Void in
         
            self.alertView.removeFromSuperview()
            
        }
        
    }
    
     // MARK: - funciones del collectionview
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.listaProductos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let producto = listaProductos[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.nombreProducto = producto.prodnombre
        cell.objectId = producto.objectId
        cell.precio = producto.precio
        cell.urlimagen = NSURL(string: producto.imgFile!)
        cell.iniciarBotones(self.tamBotoncelda!,ubicacionInicial: (self.altoCelda-(self.tamBotoncelda! * 2)), espacio: self.espacioBotonCelda!)
        
        if cell.placeholder == nil
        {
            let tamCargandoProducto = self.altoCelda/4
            let cargandoProducto = UIImageView(image: self.imagenPlaceholder)
            cargandoProducto.frame = CGRect(x: (self.anchoCelda/2)-(tamCargandoProducto/2), y: (self.altoCelda/2)-(tamCargandoProducto/2), width: tamCargandoProducto, height: tamCargandoProducto)
            cell.agregarPlaceholder(cargandoProducto)
        }
        
        
        if let image = NSURL(string: producto.imgFile!)?.cachedImage {
            // Cached: set immediately.
            if(cell.placeholder != nil)
            {
                cell.placeholder.removeFromSuperview()
                cell.placeholder = nil
                
            }
            
            cell.imagen.image = UIImage(data: image)
            cell.imagen.alpha = 1
            
        } else {
            // Not cached, so load then fade it in.
            cell.imagen.alpha = 0
            NSURL(string: producto.imgFile!)!.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                if cell.urlimagen == NSURL(string: producto.imgFile!) {
                    
                    cell.imagen.image = UIImage(data: image)
                    UIView.animateWithDuration(0.3)
                    {
                        if(cell.placeholder != nil)
                        {
                            cell.placeholder.removeFromSuperview()
                            cell.placeholder = nil
                            
                        }
                        cell.imagen.alpha = 1
                        
                    }
                    
                }
               
            }
        }
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        if !alertView.isDescendantOfView(self.view)
        {
            tituProducto.text = listaProductos[indexPath.row].prodnombre!
            descripcion.text = listaProductos[indexPath.row].proddescripcion!
            self.alertView.alpha = 1
            self.tituProducto.alpha = 1
            self.cerrar_button.alpha = 1
            self.descripcion.alpha = 1
            self.view.addSubview(alertView)
            
        }
        else
        {
            UIView.animateWithDuration(0.5, animations:{ ()-> Void in
                
                self.alertView.alpha = 0
                self.tituProducto.alpha = 0
                self.cerrar_button.alpha = 0
                self.descripcion.alpha = 0
                
            }){ (Bool) -> Void in
                
                self.alertView.removeFromSuperview()
                
            }
        }
        
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

    
   
     // MARK: - funciones de interfaces
    @IBAction func menuPrincipal(sender: AnyObject)
    {
         self.comunicacionControllerPrincipal!.abrirMenuPrincipal()
    }
    
    @IBAction func clickIrPedido(sender: AnyObject)
    {
        self.comunicacionControllerPrincipal!.irPedido()
    }
    

}
