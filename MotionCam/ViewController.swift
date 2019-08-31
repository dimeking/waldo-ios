//
//  ViewController.swift
//  MotionCam
//
//  Created by HARI RAJA on 7/24/19.
//  Copyright © 2019 Hari Raja. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gridImageView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var times = [String]()
    
    let gridRows = 10
    let gridCols = 10
    
    var imageLayer = CALayer()
    var gridLayer = CAShapeLayer()
    var gridPath = UIBezierPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpImageLayer()
        gridImageView.layer.addSublayer(imageLayer)
        
        setUpGridPath()
        setUpGridLayer()
        gridImageView.layer.addSublayer(gridLayer)

        times.append(NSDate.init().description)
        times.append(NSDate.init().description)
        times.append(NSDate.init().description)
        tableView.reloadData()
        print("load times table")
    }
    
    func setUpImageLayer() {
        print("setup image layer")
        imageLayer.frame = gridImageView.bounds
        imageLayer.contents = UIImage(named: "frog")?.cgImage
        imageLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
    }
    
    func setUpGridPath() {
        
        let bounds = gridImageView.bounds
        let cellWidth = bounds.width/CGFloat(gridCols)
        let cellHeight = bounds.width/CGFloat(gridRows)
        
        for X in stride(from: bounds.minX, to: bounds.maxX, by: cellWidth) {
            gridPath.move(to: CGPoint(x: X, y: bounds.minY))
            gridPath.addLine(to: CGPoint(x: X, y: bounds.maxY))
        }
        for Y in stride(from: bounds.minY, to: bounds.maxY, by: cellHeight) {
            gridPath.move(to: CGPoint(x: bounds.minX, y: Y))
            gridPath.addLine(to: CGPoint(x: bounds.maxX, y: Y))
        }
        gridPath.close()
    }
    
    func setUpGridLayer() {

        gridLayer.path = gridPath.cgPath
        gridLayer.lineCap = CAShapeLayerLineCap.butt
        gridLayer.lineDashPattern = nil
        gridLayer.lineDashPhase = 0.0
        gridLayer.lineJoin = CAShapeLayerLineJoin.miter
        gridLayer.lineWidth = 1.0
        gridLayer.miterLimit = 10.0
        gridLayer.strokeColor = UIColor.white.cgColor

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
        cell.textLabel?.text = times[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

