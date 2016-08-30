//
//  SPEPresetTableViewController.swift
//  FaceKit
//
//  Created by Daniel on 2016/3/31.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

import UIKit
import FaceKit

class SPEPresetTableViewController: UITableViewController {

    var presetType: FACPresetType?
    var gender = FACGender.Male
    var selectPresetClosure: ((FACPreset) -> Void)?
    
    var presets: [FACPreset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadPresetData()
        
        self.clearsSelectionOnViewWillAppear = true
    }

    func loadPresetData() {
        guard let presetType = self.presetType else {
            return
        }
        
        self.presets = FACPreset.getPresetsForType(presetType, gender: self.gender)
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - action
    
    @IBAction func closeAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("presetCell", forIndexPath: indexPath)

        cell.textLabel?.text = self.presets[indexPath.row].name
        
        self.presets[indexPath.row].observePreviewImage({ (preset, image) in
            if cell.imageView?.image != image {
                cell.imageView?.image = image
                
                if self.tableView == tableView {
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }
        })

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectPresetClosure?(self.presets[indexPath.row])
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
