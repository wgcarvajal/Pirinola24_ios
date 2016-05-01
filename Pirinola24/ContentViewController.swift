//
//  ContentViewController.swift
//  Pirinola24
//
//  Created by Aplimovil on 27/04/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    @IBOutlet weak var subcategoria: UILabel!    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageIndex: Int!
    var subcategoriaTitulo : String?
    var listaProductos = Array<Producto>()
    var tipoFrament : Int!
    var anchoCelda : CGFloat!
    var altoCelda : CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subcategoria.text = self.subcategoriaTitulo
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.listaProductos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        
        let pirinolaCarga = UIImage.gifWithName("carga")
        let cargandoProducto = UIImageView(image: pirinolaCarga)
        
        let tamCargandoProducto = self.altoCelda/4
        
        cargandoProducto.frame = CGRect(x: (self.anchoCelda/2)-(tamCargandoProducto/2), y: (self.altoCelda/2)-(tamCargandoProducto/2), width: tamCargandoProducto, height: tamCargandoProducto)
        
        cell.addSubview(cargandoProducto)
        
        let url = listaProductos[indexPath.row].imgFile
        
        if let image = AppUtil.imagenCache.objectForKey(url!) as? UIImage
        {
            cargandoProducto.hidden = true
            cell.imagen?.image = image
        }
        else
        {
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url! )!,completionHandler: {(data, response, error) -> Void in
                
                
                if error != nil
                {
                    print(error)
                    return
                }
                
                let image = UIImage(data: data!)
                
                AppUtil.imagenCache.setObject(image!, forKey: url!)
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                   
                    cargandoProducto.hidden = true
                    cell.imagen?.image = image
                    
                })
                
                
            }).resume()
            
        }
        
        return cell
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        //self.performSegueWithIdentifier("showImage", sender: self)
        
        
    }
    
    
        
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
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
        
        print(totalWidth) // this prints 106.666666667
        
        self.anchoCelda = totalWidth-8
        self.altoCelda = totalHeight-10
        return CGSizeMake(totalWidth-8, totalHeight-10)
        
    }

    

}
