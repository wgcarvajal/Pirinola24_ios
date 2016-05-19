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
    func mostrarDescripcionProducto(nombreProducto:String,descripcionProducto:String)
}

class ContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet  var subcategoria: UILabel!
    @IBOutlet  var collectionView: UICollectionView!
    
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
    
    var imagenpublicidad : UIImageView?
    
    // MARK: - funciones propias del controlador
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = CAGradientLayer().rojoDegradado()
        background.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.subcategoria.frame.height)        
       
        
        self.view.layer.insertSublayer(background, atIndex:0 )
        self.subcategoria.text = self.subcategoriaTitulo
        self.subcategoria.font = UIFont(name: "Matura MT Script Capitals", size: AppUtil.sizeTituloSubcategoria)

        self.subcategoria.backgroundColor = UIColor.clearColor()
        
        if self.tipoFrament == 3
        {
            self.iniciarVistaPubicitaria()
        }
        else
        {
            self.imagenPlaceholder = UIImage.gifWithName("carga")
            self.cargarDatos()
            self.fijar_tamanoCelda()
            self.fijar_espacio_entre_celdas()
            self.fijar_tamano_boton_celda()
        }   
        
        
        // Do any additional setup after loading the view.
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - funciones de la logica de negocio
    
    override func viewWillAppear(animated: Bool)
    {
        if(collectionView != nil)
        {
            if AppUtil.contadorUpdateCollectionview > 0
            {
                print("se actualizo la vista")
                collectionView.reloadData()
                AppUtil.contadorUpdateCollectionview -= 1
            }
            
        }
        
    }
    
    func iniciarVistaPubicitaria()
    {
        self.imagenpublicidad = UIImageView(frame : CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 95))
        
        
        self.collectionView.removeFromSuperview()
        self.collectionView = nil
        
        self.view.addSubview(imagenpublicidad!)
        
        self.cargarAnuncio()
        
    }
    
    func cargarAnuncio()
    {
        var anuncio : Anuncio?
        for a in AppUtil.listaAnuncios
        {
            if a.subcategoria == self.subcategoriaId
            {
                anuncio = a
                break
            }
        }
        
        if anuncio == nil
        {
            
            self.cargarAnuncioBackendless()
            
        }
        else
        {
            if let image =  NSURL(string: (anuncio?.urlImagen)!)?.cachedImage
            {
                self.imagenpublicidad?.image = UIImage(data: image)
                self.imagenpublicidad?.alpha = 1
            }
            else
            {
                self.imagenpublicidad?.alpha = 0
                NSURL(string: (anuncio?.urlImagen)!)?.fetchImage { image in
                 
                    self.imagenpublicidad?.image = UIImage(data: image)
                    UIView.animateWithDuration(0.3)
                    {
                        
                        self.imagenpublicidad?.alpha = 1
                        
                    }
                    
                }
            }
            
        }
        
        
        
    }
    
    func cargarAnuncioBackendless()
    {
        let backendless = Backendless.sharedInstance()
        var anuncioSelect = Array<String>()
        anuncioSelect.append("objectId")
        anuncioSelect.append("urlImagen")
        anuncioSelect.append("subcategoria")
        
        
        let dataQueryAnuncio = BackendlessDataQuery()
        let queryOptionAnuncio = BackendlessDataQuery().queryOptions
        dataQueryAnuncio.properties = anuncioSelect
        
        queryOptionAnuncio.pageSize = 100
        dataQueryAnuncio.queryOptions = queryOptionAnuncio
        
        
        let queryAnuncio = backendless.data.of(Anuncio.ofClass())
        
        queryAnuncio.find(dataQueryAnuncio,
                    response: { (result: BackendlessCollection!) -> Void in
                        
                    if(result.getCurrentPage().count > 0)
                    {
                        let anuncio : Anuncio? = result.getCurrentPage()[0] as? Anuncio
                        AppUtil.listaAnuncios.append(anuncio!)
                        
                        
                        if let image =  NSURL(string: (anuncio!.urlImagen)!)?.cachedImage
                        {
                            self.imagenpublicidad?.image = UIImage(data: image)
                            self.imagenpublicidad?.alpha = 1
                        }
                        else
                        {
                            self.imagenpublicidad?.alpha = 0
                            NSURL(string: (anuncio?.urlImagen)!)?.fetchImage { image in
                                
                                self.imagenpublicidad?.image = UIImage(data: image)
                                UIView.animateWithDuration(0.3)
                                {
                                    
                                    self.imagenpublicidad?.alpha = 1
                                    
                                }
                                
                            }
                        }

                        
                    }
            },
            error: { (fault: Fault!) -> Void in
            print("Server reported an error: \(fault)")
                
        })
    }
    
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
            totalHeight = ((self.view.frame.height - 20 - 40 - 30) / 2.3)
            totalWidth = (self.view.frame.width / 2)
        }
    
        else
        {
            if self.tipoFrament == 2
            {
                totalHeight = ((self.view.frame.height - 20 - 40 - 30) / 2.8)
                totalWidth = (self.view.frame.width / 3)
            }
            else
            {
                totalHeight = (5.0)
                totalWidth = (5.0)
            }
        }
        self.anchoCelda = totalWidth - 15
        self.altoCelda = totalHeight - 10
        self.tamanoCelda = CGSizeMake(totalWidth - 15, totalHeight - 10)
    }
    
    func fijar_espacio_entre_celdas()
    {
       
        self.espacioEntreceldas = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
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
        let producto = listaProductos[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.nombreProducto = producto.prodnombre
        cell.objectId = producto.objectId
        cell.precio = producto.precio
        cell.urlimagen = NSURL(string: producto.imgFile!)
        cell.finalizarBotones()
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
        
            let nombre = listaProductos[indexPath.row].prodnombre!
            let descripcion = listaProductos[indexPath.row].proddescripcion!
            self.comunicacionControllerPrincipal.mostrarDescripcionProducto(nombre, descripcionProducto: descripcion)        
    }
    
    
        
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        
        return self.espacioEntreceldas!
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
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
