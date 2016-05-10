//
//  PedidoViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 6/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class PedidoViewController: UIViewController , SideBarDelegate , UICollectionViewDelegate, UICollectionViewDataSource
{

    var sideBar : SideBar = SideBar()
    
    @IBOutlet weak var tuPedidoLabel: UILabel!
    @IBOutlet weak var botonAtras: UIButton!
    @IBOutlet weak var botonMenuPrincipal: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var totalValor: UILabel!
    @IBOutlet weak var domicilio: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var anchoCelda : CGFloat!
    var altoCelda : CGFloat!
    var tamanoCelda : CGSize?
    var imagenPlaceholder : UIImage?
    var espacioEntreceldas : UIEdgeInsets?
    var tamBotoncelda : CGFloat?
    var espacioBotonCelda : CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let background = CAGradientLayer().rojoDegradado()
        background.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.tuPedidoLabel.frame.height)
        
        self.tuPedidoLabel.backgroundColor = UIColor.clearColor()
        self.tuPedidoLabel.font = UIFont(name: "Matura MT Script Capitals", size: AppUtil.sizeTituloSubcategoria)
        
        let colorRojo : UIColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        self.total.textColor = colorRojo
        self.total.font = UIFont(name: "Stackyard PERSONAL USE", size: 24)
        
        self.totalValor.textColor = colorRojo
        self.totalValor.font = UIFont(name: "URW Bookman L", size: 25)
        
        self.domicilio.textColor = colorRojo
        self.domicilio.font = UIFont(name: "Segoe Print", size: 12)
        
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        let anchoM = self.view.frame.size.width - 50
        let altoL = ((self.view.frame.size.width - 50)/3) + 30
        
        
        sideBar = SideBar(sourceView: self.view, menuItems: ["Logo", "Atras", "Vaciar Pedido"], anchoMenu: anchoM, altoEspacioLogo: altoL)
        
        sideBar.delegate = self
        
        self.botonAtras.hidden = true
        
        self.fijar_tamanoCelda()
        self.fijar_espacio_entre_celdas()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - funciones de interfaz
    
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
        let cargandoProducto = UIImageView(image: self.imagenPlaceholder)
        
        let tamCargandoProducto = self.altoCelda/4
        
        cargandoProducto.frame = CGRect(x: (self.anchoCelda/2)-(tamCargandoProducto/2), y: (self.altoCelda/2)-(tamCargandoProducto/2), width: tamCargandoProducto, height: tamCargandoProducto)
        
        cell.addSubview(cargandoProducto)
       
        if let image = itemCarrito.imagen!.cachedImage {
            // Cached: set immediately.
            cargandoProducto.image = nil
            cargandoProducto.hidden = true
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
                        cargandoProducto.image = nil
                        cargandoProducto.hidden = true
                        cell.imagen.alpha = 1
                    }
                }
            }
        }
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        //print("selecionamos"+listaProductos[indexPath.row].prodnombre!)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     // MARK: - funciones Logica de negocio
    
    
    func back_to_previus_controller()
    {
        print("entro a regresar")
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - funciones interfaza menu drawer
    
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
        switch index
        {
            case 1:
                back_to_previus_controller()
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
    
}
