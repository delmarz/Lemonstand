//
//  ViewController.swift
//  LemonStand3
//
//  Created by delmarz on 1/20/15.
//  Copyright (c) 2015 delmarz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var moneySupplyCount: UILabel!
    @IBOutlet weak var lemonSupplyCount: UILabel!
    @IBOutlet weak var iceCubeSupplyCount: UILabel!
    
    @IBOutlet weak var lemonPurchaseCount: UILabel!
    @IBOutlet weak var iceCubePurchaseCount: UILabel!
    
    @IBOutlet weak var lemonMixCount: UILabel!
    @IBOutlet weak var iceCubeMixCount: UILabel!
    
    
    var supplies = Supplies(aMoney: 10, aLemon: 1, aIceCube: 1)
    var price = Price()
    
    var weatherImageView:UIImageView = UIImageView(frame: CGRectMake(20, 50, 50, 50))
    
    var weatherArray:[[Int]] =  [[10, 5, 3, 2], [20, 15, 14, 11], [36, 32, 31, 21]]
    var weatherToday:[Int] = []
    
    var lemonToPurchase = 0
    var iceCubeToPurchase = 0
    var lemonToMix = 0
    var iceCubeToMix = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(self.weatherImageView)
        
        simulateWeatherToday()
        updateMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func purchaseLemonButtonPressed(sender: AnyObject) {
        
        
        if self.supplies.money >= self.price.lemon {
            self.lemonToPurchase += 1
            self.supplies.money -= self.price.lemon
            self.supplies.lemon += 1
        }
        else {
            showAlertWithText(message: "You don't have enough money")
        }
        updateMainView()
        
    }
    
    @IBAction func purchaseIceCubeButtonPressed(sender: AnyObject) {
        
        if self.supplies.money >= self.price.iceCube {
            self.iceCubeToPurchase += 1
            self.supplies.money -= self.price.iceCube
            self.supplies.iceCube += 1
        }
        else {
            showAlertWithText(message: "You dont have enough money")
        }
        updateMainView()
        
    }
    
    @IBAction func unpurchaseLemonButtonPressed(sender: AnyObject) {
        
        if self.lemonToPurchase > 0 {
            self.lemonToPurchase -= 1
            self.supplies.money += self.price.lemon
            self.supplies.lemon -= 1
        }
        else {
            showAlertWithText(message: "You dont have anything to return")
        }
        updateMainView()
    }
    
    @IBAction func unpurchaseIceCubeButtonPressed(sender: AnyObject) {
        
        
        if self.iceCubeToPurchase > 0 {
            self.iceCubeToPurchase -= 1
            self.supplies.money += self.price.iceCube
            self.supplies.iceCube -= 1
        }
        else {
            showAlertWithText(message: "You dont have anything to return")
        }
        updateMainView()
    }
    
    
    @IBAction func mixLemonButtonPressed(sender: AnyObject) {
        
        
        if self.supplies.lemon > 0 {
            self.lemonToMix += 1
            self.supplies.lemon -= 1
        }
        else {
            showAlertWithText(message: "You dont have enough inventory")
        }
        updateMainView()
        
    }
    
    @IBAction func mixIceCubeButtonPressed(sender: AnyObject) {
        
        if self.supplies.iceCube > 0 {
            self.iceCubeToMix += 1
            self.supplies.iceCube -= 1
        }
        else {
            showAlertWithText(message: "You dont have inventory")
        }
        updateMainView()
    }
    
    @IBAction func unmixLemonButtonPressed(sender: AnyObject) {
        
        
        if self.lemonToMix > 0 {
            self.lemonToMix -= 1
            self.supplies.lemon += 1
        }
        else {
            showAlertWithText(message: "You dont have anything to return" )
        }
        updateMainView()
        
    }
    
    @IBAction func unmixIceCubeButtonPressed(sender: AnyObject) {
        
        if self.iceCubeToMix > 0 {
            self.iceCubeToMix -= 1
            self.supplies.iceCube += 1
        }
        else {
            showAlertWithText(message: "You dont have anything to return")
        }
        updateMainView()
    }
    
    
    @IBAction func startDayButtonPressed(sender: AnyObject) {
        
        
        var average = findAverage(self.weatherToday)
        
        
        if self.lemonToMix == 0 && self.iceCubeToMix > 0 && self.weatherImageView.image == UIImage(named: "Cold") {
            
            let coldWeather:[Int] = [0, 0, 0, 0,]
            let average = findAverage(coldWeather)
            
            println("No ones need ice cube only, especially its a cold weather")
            
            let customers = Int(arc4random_uniform(UInt32(average)))
            println("Customer: \(customers)")
            
            let lemonadeRatio = Float(self.lemonToMix) / Float(self.iceCubeToMix)
            println("Lemonade Ratio: \(lemonadeRatio)")
            
            self.lemonToPurchase = 0
            self.iceCubeToPurchase = 0
            self.lemonToMix = 0
            self.iceCubeToMix = 0
            
            simulateWeatherToday()
            updateMainView()
        }
        else if self.lemonToMix == 0 && self.iceCubeToMix == 0 {
            showAlertWithText(message: "Input your lemon or ice cube before selling it")
        }
        
        else {
            let customers = Int(arc4random_uniform(UInt32(average)))
            println("Customer: \(customers)")
            
            let lemonadeRatio = Float(self.lemonToMix) / Float(self.iceCubeToMix)
            println("Lemonade Ratio: \(lemonadeRatio)")
            
            for x in 0...customers{
                
                let preference = Double(arc4random_uniform(UInt32(100))) / 100
                
                if preference < 0.4 && lemonadeRatio > 1 {
                    println("Paid")
                    self.supplies.money += 1
                }
                else if preference > 0.6 && lemonadeRatio < 1 {
                    println("Paid")
                    self.supplies.money += 1
                }
                else if preference <= 0.6 && preference >= 0.4 && lemonadeRatio == 1 {
                    println("Paid")
                    self.supplies.money += 1
                }
                else {
                    println("No match, no revenue")
                }
            }
            
            self.lemonToPurchase = 0
            self.iceCubeToPurchase = 0
            self.lemonToMix = 0
            self.iceCubeToMix = 0
            
            simulateWeatherToday()
            updateMainView()
            
        }
     
        
    }
    
    // Helper
    
    func updateMainView() {

        self.moneySupplyCount.text = "$\(self.supplies.money)"
        self.lemonSupplyCount.text = "\(self.supplies.lemon) Lemon"
        self.iceCubeSupplyCount.text = "\(self.supplies.iceCube) Ice Cube"
        
        self.lemonPurchaseCount.text = "\(self.lemonToPurchase)"
        self.iceCubePurchaseCount.text = "\(self.iceCubeToPurchase)"
        
        self.lemonMixCount.text = "\(self.lemonToMix)"
        self.iceCubeMixCount.text = "\(self.iceCubeToMix)"
        
    }
    
    func showAlertWithText(header: String = "Warning", message: String) {
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func simulateWeatherToday() {
        
        let index = Int(arc4random_uniform(UInt32(self.weatherArray.count)))
        self.weatherToday = self.weatherArray[index]
        
        switch index {
            
        case 0:
            self.weatherImageView.image = UIImage(named: "Cold")
        case 1:
            self.weatherImageView.image = UIImage(named: "Mild")
        case 2:
            self.weatherImageView.image = UIImage(named: "Warm")
        default:
            self.weatherImageView.image = UIImage(named: "Warm")
        }
        
        
    }
    
    func findAverage(data:[Int]) -> Int
    {
        
        var sum = 0
        
        for x in data{
            
            sum += x
        }
        
        let average:Double = Double(sum) / (Double)(data.count)
        let rounded:Int = Int(ceil(average))
        return rounded
        
    }
    
    

}

