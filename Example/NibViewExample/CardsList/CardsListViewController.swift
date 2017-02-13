//
//  CardsListViewController.swift
//  NibView
//
//  Created by Domas on 10/02/2017.
//  Copyright © 2017 Trafi. All rights reserved.
//

import UIKit

final class CardsListViewController: UIViewController {
    
    @IBAction private func cardTapped(gesture: UITapGestureRecognizer) {
        performSegueWithIdentifier("ShowDetails", sender: gesture.view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        guard let details = segue.destinationViewController as? CardDetailsViewController, let cardView = sender as? CardView else { return }
        details.setup(with: cardView)
    }
    
}
