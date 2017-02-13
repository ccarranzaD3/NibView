//
//  NibLoader.swift
//  NibLoader
//
//  Created by Domas on 10/02/2017.
//  Copyright © 2016 Trafi. All rights reserved.
//

// MARK: - Public

public extension NibLoadable where Self: UIView {
    var nibLoader: IBNibLoader<Self> { return IBNibLoader(self) }
}

public struct IBNibLoader<NibLoadableView: NibLoadable where NibLoadableView: UIView> {
    
    func awakeAfter(using aDecoder: NSCoder, @autoclosure _ superMethod: () -> AnyObject?) -> AnyObject? {
        guard nonPrivateSubviews.isEmpty else { return superMethod() }
        
        let nibView = view.dynamicType.fromNib()
        copyProperties(to: nibView)
        
        return nibView
    }
    
    func initWithFrame() {
        #if TARGET_INTERFACE_BUILDER
            let nibView = view.dynamicType.fromNib()
            copyProperties(to: nibView)
            SubviewsCopier.copySubviewReferences(from: nibView, to: view)
            
            nibView.frame = view.bounds
            nibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            view.addSubview(nibView)
        #endif
    }
    
    func prepareForInterfaceBuilder() {
        if nonPrivateSubviews.count == 1 {
            // Used as a reference container
            view.backgroundColor = .clearColor()
        } else {
            // Is original .xib file
            nonPrivateSubviews.first?.removeFromSuperview()
        }
    }
    
    func setValue(value: AnyObject?, forKeyPath keyPath: String) {
        #if TARGET_INTERFACE_BUILDER
            guard let subview = value as? UIView else { return }
            SubviewsCopier.store(subview: subview, forKeyPath: keyPath, of: view)
        #endif
    }
    
    
    // MARK: - Private
    
    private let view: NibLoadableView
    private init(_ view: NibLoadableView) {
        self.view = view
    }
    
    private var nonPrivateSubviews: [UIView] {
        return view.subviews.filter { !String($0.dynamicType).hasPrefix("_") }
    }
    
    private func copyProperties(to nibView: UIView) {
        nibView.frame = view.frame
        nibView.autoresizingMask = view.autoresizingMask
        nibView.translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints
        nibView.clipsToBounds = view.clipsToBounds
        nibView.alpha = view.alpha
        nibView.hidden = view.hidden
    }
    
}

#if TARGET_INTERFACE_BUILDER
    private struct SubviewsCopier {
        
        static var viewKeyPathsForSubviews = [UIView: [String: UIView]]()
        
        static func store(subview subview: UIView, forKeyPath keyPath: String, of view: UIView) {
            if viewKeyPathsForSubviews[view] == nil {
                viewKeyPathsForSubviews[view] = [keyPath: subview]
            } else {
                viewKeyPathsForSubviews[view]?[keyPath] = subview
            }
        }
        
        static func copySubviewReferences(from view: UIView, to otherView: UIView) {
            viewKeyPathsForSubviews[view]?.forEach { otherView.setValue($0.1, forKeyPath: $0.0) }
            viewKeyPathsForSubviews[view] = nil
        }
    }
#endif
