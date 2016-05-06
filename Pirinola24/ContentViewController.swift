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
    
    
    
    
    // MARK: - funciones propias del controlador
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let background = CAGradientLayer().rojoDegradado()
        background.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.subcategoria.frame.height)
        
        self.view.layer.insertSublayer(background, atIndex:0 )
        self.subcategoria.text = self.subcategoriaTitulo
        self.subcategoria.backgroundColor = UIColor.clearColor()
        self.imagenPlaceholder = UIImage.gifWithName("carga")
        self.cargarDatos()
        self.fijar_tamanoCelda()
        self.fijar_espacio_entre_celdas()
        self.fijar_tamano_boton_celda()
        
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
    
     // MARK: - funciones del collectionview
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.listaProductos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.nombreProducto = listaProductos[indexPath.row].prodnombre
        cell.objectId = listaProductos[indexPath.row].objectId
        
        
        
        let cargandoProducto = UIImageView(image: self.imagenPlaceholder)
        
        let tamCargandoProducto = self.altoCelda/4
        
        cargandoProducto.frame = CGRect(x: (self.anchoCelda/2)-(tamCargandoProducto/2), y: (self.altoCelda/2)-(tamCargandoProducto/2), width: tamCargandoProducto, height: tamCargandoProducto)
        
        cell.addSubview(cargandoProducto)
        
        let urlaux = NSURL(string: listaProductos[indexPath.row].imgFile!)
        let url = urlaux
        if let image = url!.cachedImage {
            // Cached: set immediately.
            cargandoProducto.image = nil
            cargandoProducto.hidden = true
            cell.imagen.image = image
            cell.imagen.alpha = 1
            cell.iniciarBotones(self.tamBotoncelda!,ubicacionInicial: (self.altoCelda-(self.tamBotoncelda! * 2)), espacio: self.espacioBotonCelda!)
        } else {
            // Not cached, so load then fade it in.
            cell.imagen.alpha = 0
            url!.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                if url == urlaux {
                    
                    cell.imagen.image = image
                    UIView.animateWithDuration(0.3) {
                        cargandoProducto.image = nil
                        cargandoProducto.hidden = true
                        cell.imagen.alpha = 1
                        cell.iniciarBotones(self.tamBotoncelda!,ubicacionInicial: (self.altoCelda-(self.tamBotoncelda! * 2)), espacio: self.espacioBotonCelda!)
                    }
                }
            }
        }
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        print("selecionamos"+listaProductos[indexPath.row].prodnombre!)
        
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
