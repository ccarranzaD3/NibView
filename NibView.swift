//
//  NibView.swift
//  NibView
//
//  Created by Domas on 10/02/2017.
//  Copyright © 2016 Trafi. All rights reserved.
//

import NibView

public class NibView: UIView, NibLoadable {
    
    public class var nibName: String {
        return String(self)
    }
    
    public override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        return nibLoader.awakeAfter(using: aDecoder, super.awakeAfterUsingCoder(aDecoder))
    }
    
    // MARK: - Interface builder
    
    #if TARGET_INTERFACE_BUILDER
    
        public override init(frame: CGRect) {
            super.init(frame: frame)
            nibLoader.initWithFrame()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        public override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            nibLoader.prepareForInterfaceBuilder()
        }
    
        public override func setValue(value: AnyObject?, forKeyPath keyPath: String) {
            super.setValue(value, forKeyPath: keyPath)
            nibLoader.setValue(value, forKeyPath: keyPath)
        }

    #endif
}
