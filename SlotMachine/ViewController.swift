//
//  ViewController.swift
//  SlotMachine
//
//  Created by Kamlesh Nanda on 10/26/14.
//  Copyright (c) 2014 Kamlesh Nanda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var firstContainer:UIView!
    var secondContainer:UIView!
    var thirdContainer:UIView!
    var fourthContainer:UIView!
    
    var titleLabel:UILabel!
    
    // Information Labels
    var creditsLabel: UILabel!
    var betLabel: UILabel!
    var winnerPaidLabel: UILabel!
    var creditsTitleLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    var resultsLabel: UILabel!
    
    //Buttons in our fourth container
    var resetButton:UIButton!
    var betOneButton:UIButton!
    var betMaxButton:UIButton!
    var spinButton:UIButton!
    
    var slots:[[Slot]] = []
    
    // Stats
    var credits = 0
    var currentBet = 0
    var winnings = 0
    var lastResult: String? = "Lets Play"
    
    let kMarginForView:CGFloat = 10.0
    let kMarginForSlot:CGFloat = 2.0
    let kSixth:CGFloat = 1.0/6.0
    let kNumberOfContainers = 3
    let kNumberOfSlots = 3
    let kThird:CGFloat = 1.0/3.0
    let kHalf:CGFloat = 1.0/2.0
    let kEigth:CGFloat = 1.0/8.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViews()
        setupFirstContainer(self.firstContainer)
        setupThirdContainer(self.thirdContainer)
        setupFourthContainer(self.fourthContainer)
        hardReset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IBActions
    
    func resetButtonPressed(button:UIButton) {
        hardReset()
    }
    
    func betOneButtonPressed(button:UIButton) {
        if(credits <= 0) {
            showAlertWithText(header: "No More Credits", message: "Reset Game")
        } else if (currentBet < 5) {
            currentBet++
            credits--
            updateMainView()
        } else {
            showAlertWithText(message: "You can only bet 5 credits at a time!")
        }
    }
    
    func betMaxButtonPressed(button:UIButton) {
        if(credits <= 5) {
            showAlertWithText(header: "No Enough Credits", message: "Bet Less")
        } else if (currentBet < 5) {
            var creditsToBetMax = 5 - currentBet
            currentBet += creditsToBetMax
            credits -= creditsToBetMax
            updateMainView()
        } else {
            showAlertWithText(message: "You can only bet 5 credits at a time!")
        }
    }
    
    func spinButtonPressed(button:UIButton) {
        removeSlotImageViews()
        if(currentBet <= 0) {
            showAlertWithText(header: "No Bets", message: "Bet something first.")
        }
        slots = Factory.createSlots()
        setupSecondContainer(self.secondContainer)
        var winningsMultiplier = SlotBrain.computeWinnings(slots, resultString: &lastResult)
        if lastResult == nil {
            lastResult = "No wins, try again"
        }
        winnings = winningsMultiplier * currentBet
        credits += winnings
        currentBet = 0
        updateMainView()
    }
    
    func setupContainerViews() {
        self.firstContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + kMarginForView, y: self.view.bounds.origin.y, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(firstContainer)
        
        self.secondContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kMarginForView, y: firstContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * (3 * kSixth)))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(secondContainer)
        
        self.thirdContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kMarginForView, y: self.firstContainer.frame.height + self.secondContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRect(x: self.view.bounds.origin.x + self.kMarginForView, y: self.firstContainer.frame.height + self.secondContainer.frame.height + self.thirdContainer.frame.height, width: self.view.bounds.width - (kMarginForView * 2), height: self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(fourthContainer)
        
    }
    
    func setupFirstContainer(containerView: UIView) {
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.yellowColor()
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        containerView.addSubview(self.titleLabel)
    }
    
    func setupSecondContainer(containerView: UIView) {
        for var containerNumber = 0; containerNumber < self.kNumberOfContainers; ++containerNumber {
            
            for var slotNumber = 0; slotNumber < self.kNumberOfSlots; ++slotNumber {
                var slot:Slot
                var slotImageView = UIImageView()
                
                if slots.count != 0 {
                    let slotContainer = slots[containerNumber]
                    slot = slotContainer[slotNumber]
                    slotImageView.image = slot.image
                } else {
                    slotImageView.image = UIImage(named: "Ace")
                }
                
                slotImageView.backgroundColor = UIColor.yellowColor()
                slotImageView.frame = CGRect(x: containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(containerNumber) * kThird), y: containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(slotNumber) * kThird), width: containerView.bounds.width * kThird - kMarginForSlot, height: containerView.bounds.height * kThird - kMarginForSlot)
                containerView.addSubview(slotImageView)
            }
        }
    }
    
    func setupThirdContainer(containerView: UIView) {
        self.creditsLabel = UILabel()
        self.creditsLabel.text = "000000"
        self.creditsLabel.textColor = UIColor.redColor()
        self.creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.creditsLabel.sizeToFit()
        self.creditsLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird)
        self.creditsLabel.textAlignment = NSTextAlignment.Center
        self.creditsLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.creditsLabel)
        
        self.betLabel = UILabel()
        self.betLabel.text = "0000"
        self.betLabel.textColor = UIColor.redColor()
        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird)
        self.betLabel.textAlignment = NSTextAlignment.Center
        self.betLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.betLabel)
        
        self.winnerPaidLabel = UILabel()
        self.winnerPaidLabel.text = "000000"
        self.winnerPaidLabel.textColor = UIColor.redColor()
        self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.winnerPaidLabel.sizeToFit()
        self.winnerPaidLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird)
        self.winnerPaidLabel.textAlignment = NSTextAlignment.Center
        self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.winnerPaidLabel)
        
        self.creditsTitleLabel = UILabel()
        self.creditsTitleLabel.text = "Credits"
        self.creditsTitleLabel.textColor = UIColor.blackColor()
        self.creditsTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.creditsTitleLabel.sizeToFit()
        self.creditsTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(self.creditsTitleLabel)
        
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet"
        self.betTitleLabel.textColor = UIColor.blackColor()
        self.betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 3, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(self.betTitleLabel)

        
        self.winnerPaidTitleLabel = UILabel()
        self.winnerPaidTitleLabel.text = "Winner Paid"
        self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
        self.winnerPaidTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.winnerPaidTitleLabel.sizeToFit()
        self.winnerPaidTitleLabel.center = CGPoint(x: containerView.frame.width * kSixth * 5, y: containerView.frame.height * kThird * 2)
        containerView.addSubview(self.winnerPaidTitleLabel)
        
        self.resultsLabel = UILabel()
        self.resultsLabel.text = self.lastResult
        self.resultsLabel.textColor = UIColor.purpleColor()
        self.resultsLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.resultsLabel.textAlignment = NSTextAlignment.Center
        self.resultsLabel.sizeToFit()
        self.resultsLabel.center = CGPoint(x: containerView.frame.width * kHalf, y: containerView.frame.height * kThird * 2.6)
        containerView.addSubview(self.resultsLabel)
    }
    
    func setupFourthContainer(containerView: UIView) {
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclaredon-Bold", size: 12)
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPoint(x: containerView.frame.width * kEigth, y: containerView.frame.height * kHalf)
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.resetButton)
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclaredon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.greenColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPoint(x: containerView.frame.width * 3 * kEigth, y: containerView.frame.height * kHalf)
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("Bet Max", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclaredon-Bold", size: 12)
        self.betMaxButton.backgroundColor = UIColor.redColor()
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPoint(x: containerView.frame.width * 5 * kEigth, y: containerView.frame.height * kHalf)
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betMaxButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclaredon-Bold", size: 12)
        self.spinButton.backgroundColor = UIColor.redColor()
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPoint(x: containerView.frame.width * 7 * kEigth, y: containerView.frame.height * kHalf)
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.spinButton)
    }
    
    func removeSlotImageViews() {
        if self.secondContainer != nil {
            let container: UIView? = self.secondContainer
            let subViews:Array? = container!.subviews
            for views in subViews! {
                views.removeFromSuperview()
            }
        }
    }
    
    func hardReset() {
        removeSlotImageViews()
        slots.removeAll(keepCapacity: true)
        self.setupSecondContainer(self.secondContainer)
        credits = 50
        winnings = 0
        currentBet = 0
        
        updateMainView()
    }
    
    func updateMainView() {
        self.creditsLabel.text = "\(credits)"
        self.betLabel.text = "\(currentBet)"
        self.winnerPaidLabel.text = "\(winnings)"
        self.resultsLabel.text = lastResult
        //Center the results label
        self.resultsLabel.sizeToFit()
        self.resultsLabel.center = CGPoint(x: self.resultsLabel.superview!.frame.width * kHalf, y: self.resultsLabel.superview!.frame.height * kThird * 2.6)
        self.lastResult = nil
    }
    
    func showAlertWithText(header: String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

