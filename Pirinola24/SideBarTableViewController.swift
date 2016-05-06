//
//  SideBarTableViewController.swift
//  BurrySideBar
//
//  Created by Aplimovil on 3/05/16.
//  Copyright © 2016 WD. All rights reserved.
//

import UIKit

protocol SideBarTableViewControllerDelegate
{
    func sideBarControlDidSelectRow(indexPath:NSIndexPath)
}


class SideBarTableViewController: UITableViewController {
    
    // MARK: - Table view data source
    
    var delegate:SideBarTableViewControllerDelegate?
    var tableData:Array<String> = []
    
    var anchomenu : CGFloat!
    var altoLogo :CGFloat!

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            // Configure the cell...
            
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel!.textColor = UIColor.darkTextColor()
            
            let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedView.backgroundColor = UIColor.whiteColor()
            
            cell!.selectedBackgroundView = selectedView
        }
        
        
        
        
        if(indexPath.row == 0)
        {
            let logo = UIImage(named: "pirinola_icono.png")
            
            let logoView = UIImageView(image: logo)
            
            let widthLogo = self.anchomenu / 3
            
            let posicionX = (self.anchomenu / 2) - (widthLogo / 2)
            let posicionY = (self.altoLogo / 2) - (widthLogo / 2)
            
            
            
            logoView.frame = CGRect(x: posicionX , y: posicionY, width: widthLogo, height: widthLogo)
            
            let background = CAGradientLayer().rojoDegradado()
            background.frame = CGRect(x: 0, y: 0, width: self.anchomenu, height: self.altoLogo)
            
            cell!.layer.insertSublayer(background, atIndex:0 )
            cell!.addSubview(logoView)
        }
        else
        {
            cell!.textLabel!.text = tableData[indexPath.row]
            cell!.textLabel?.font = UIFont(name: "Matura MT Script Capitals", size: 20.0)
            cell!.textLabel!.textColor = UIColor(red: 3/255, green: 58/255, blue: 15/255, alpha: 1)
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.row == 0)
        {
            return self.altoLogo
        }
        
        return 45.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        delegate?.sideBarControlDidSelectRow(indexPath)
    }
   

}
