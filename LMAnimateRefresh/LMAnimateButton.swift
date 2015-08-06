//
//  LMAnimateButton.swift
//  LMAnimateRefresh
//
//  Created by 刘明 on 15/7/16.
//  Copyright (c) 2015年 Ming. All rights reserved.
//

import UIKit

class LMAnimateButton: UIControl {
    
    var defaultW: CGFloat!
    var defaultH: CGFloat!
    var defaultR: CGFloat!
    var scale: CGFloat!
    var bgView: UIView!
    
    var spinnerView: LMDesignSpinner!
    var forDisplayButton: UIButton!
    
    var btnBackgroundImage: UIImage?
    
    var _isLoading: Bool = false
    var isLoading: Bool {
        get {
            return _isLoading
        }
        set {
            _isLoading = newValue
            if _isLoading {
                self.startLoading()
            } else {
                self.stopLoading()
            }
        }
    }
    
    var _contentColor: UIColor!
    var contentColor: UIColor {
        get {
            return _contentColor
        }
        set {
            _contentColor = newValue
        }
    }
    
    var _progressColor: UIColor!
    var progressColor: UIColor {
        get {
            return _progressColor
        }
        set {
            _progressColor = newValue
        }
    }
    
    override var frame: CGRect {
        get {
            let _frame = super.frame
            return _frame
        }
        set {
            super.frame = newValue
        }
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            super.selected = newValue
            self.forDisplayButton.selected = newValue
        }
    }
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            super.highlighted = newValue
            self.forDisplayButton.highlighted = newValue
        }
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        initSettingWithColor(color)
    }
    // ???
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettingWithColor(self.tintColor)
    }
    
    func imageWithColor(color: UIColor, cornerRadius: CGFloat) -> UIImage {
        let rect = CGRectMake(0, 0, cornerRadius * 2 + 10, cornerRadius * 2 + 10)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.lineWidth = 0
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let content = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(content, color.CGColor)
        
        path.fill()
        path.stroke()
        path.addClip()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func initSettingWithColor(color: UIColor) {
        self.scale = 1.4
        
        self.bgView = UIView()
        self.bgView.frame = self.bounds
        self.bgView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        self.bgView.userInteractionEnabled = false
        self.bgView.hidden = true
        self.bgView.layer.cornerRadius = CGFloat(3)
        self.addSubview(self.bgView)
        
        defaultW = self.bgView.frame.width
        defaultH = self.bgView.frame.height
        defaultR = self.bgView.layer.cornerRadius
        
        self.spinnerView = LMDesignSpinner(frame: CGRectMake(0, 0, defaultH * 0.8, defaultH * 0.8))
        self.spinnerView.tintColor = UIColor.whiteColor()
        self.spinnerView.lineWidth = 1
        self.spinnerView.center = CGPointMake(CGRectGetMidX(self.layer.bounds), CGRectGetMidY(self.layer.bounds))
        self.spinnerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.spinnerView.userInteractionEnabled = false
        self.addSubview(self.spinnerView)
        
        self.addTarget(self, action: "loadingAction", forControlEvents: .TouchUpInside)
        
        self.forDisplayButton = UIButton(frame: self.bounds)
        self.forDisplayButton.userInteractionEnabled = false
        
        let image = imageWithColor(color, cornerRadius: 3)
        self.forDisplayButton.setBackgroundImage(image.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 10, 10, 10)), forState: .Normal)
        self.addSubview(self.forDisplayButton)
        
        self.contentColor = color
    }
    
    func loadingAction() {
        if self.isLoading {
            self.stopLoading()
        } else {
            self.startLoading()
        }
    }
    
    func startLoading() {
        if btnBackgroundImage == nil {
            btnBackgroundImage = self.forDisplayButton.backgroundImageForState(.Normal)
        }
        
        _isLoading = true
        self.bgView.hidden = false
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = defaultR
        animation.toValue = defaultH * scale * 0.5
        animation.duration = 0.3
        
        self.bgView.layer.cornerRadius = 5//defaultH * scale * 0.5
//        self.bgView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        self.forDisplayButton.setBackgroundImage(nil, forState: .Normal)
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                self.bgView.layer.bounds = CGRectMake(0, 0,
                    self.defaultH * self.scale, self.defaultH * self.scale)
            }) { (completed) -> Void in
                self.forDisplayButton.hidden = true
                self.spinnerView.startAnimating()
        }
    }
    
    func stopLoading() {
        self.spinnerView.stopAnimating()
        self.forDisplayButton.hidden = false
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                self.forDisplayButton.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = defaultH * scale * 0.5
        animation.toValue = defaultR
        animation.duration = 0.3
        
        self.bgView.layer.cornerRadius = defaultR
        self.bgView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                self.bgView.layer.bounds = CGRectMake(0, 0,
                    self.defaultW * self.scale, self.defaultH * self.scale)
            }) { (completed) -> Void in
                let animation = CABasicAnimation(keyPath: "cornerRadius")
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                animation.fromValue = self.bgView.layer.cornerRadius
                animation.toValue = self.defaultR
                animation.duration = 0.2
                
                self.bgView.layer.cornerRadius = self.defaultR
                self.bgView.layer.addAnimation(animation, forKey: "cornerRadius")
                
                UIView.animateWithDuration(0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.6,
                    initialSpringVelocity: 0,
                    options: UIViewAnimationOptions.CurveLinear,
                    animations: { () -> Void in
                        self.bgView.layer.bounds = CGRectMake(0, 0,
                            self.defaultW, self.defaultH)
                    }) { (completed) -> Void in
                        if self.btnBackgroundImage != nil {
                            self.forDisplayButton.setBackgroundImage(self.btnBackgroundImage, forState: .Normal)
                        }
                        self.bgView.hidden = true
                        self._isLoading = false
                }
        }
    }
}
