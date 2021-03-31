//
//  SwiftViewController.swift
//  Text2CGPathDemo
//
//  Created by Adrian Russell on 31/03/2021.
//  Copyright © 2021 Adrian Russell. All rights reserved.
//

import UIKit

class SwiftViewController: UIViewController {
    
    let SINGLE_LINE_STRING = "Single line path."
    let MULTI_LINE_STRING  = "Multi-line string that doesn't have a newline character so is automatically lined to fit width."
    let MULTI_LINE_STRING_LINE_BREAKS = "Multi-line string\nwith '\\n' characters\nto\nforce\nnew line."

    let kFonts = [ "Helvetica-Bold", "AmericanTypewriter-CondensedLight", "MarkerFelt-Thin", "TimesNewRomanPS-ItalicMT" ]
    let kFontsizes: [CGFloat] = [ 30.0, 60.0, 50.0, 40.0 ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.78, green: 0.90, blue: 0.91, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // load single with standard string
        let line1 = singleLinePathStandard()
        line1.position = CGPoint(x: self.view.bounds.size.width / 2.0,
                                 y: self.view.bounds.size.height * 0.10)
        view.layer.addSublayer(line1)
        
        // load single with attributed string
        let line2 = singleLinePathAttributed()
        line2.position = CGPoint(x: self.view.bounds.size.width / 2.0,
                                 y: self.view.bounds.size.height * 0.25)
        view.layer.addSublayer(line2)

        // load multi with attributed string
        let line3 = multiLinePathAttributed()
        line3.position = CGPoint(x: self.view.bounds.size.width / 2.0,
                                 y: self.view.bounds.size.height * 0.5)
        view.layer.addSublayer(line3)
        
        // load multi with '\n'
        let line4 = multiLinePathStandardLineBreaks()
        line4.position = CGPoint(x: self.view.bounds.size.width / 2.0,
                                 y: self.view.bounds.size.height * 0.80)
        view.layer.addSublayer(line4)
    }

    
    func attributedString(for string: String) -> NSAttributedString {
        let attString = NSMutableAttributedString(string: string)
        
        for i in 0..<string.count {
            let option = i % 4
            if let font = UIFont(name: kFonts[option], size: kFontsizes[option]) {
                attString.addAttribute(.font, value: font, range: NSMakeRange(i, 1))
            }
        }
        
        return attString
    }


    func singleLinePathStandard() -> CAShapeLayer {
        let font = UIFont.boldSystemFont(ofSize: 60.0)
        let line1 = CAShapeLayer()
        let path = UIBezierPath(for: SINGLE_LINE_STRING, with: font).cgPath
        line1.path = path
        line1.bounds = path.boundingBox
        line1.isGeometryFlipped = true
        line1.fillColor = UIColor.white.cgColor
        line1.strokeColor = UIColor.black.cgColor
        line1.lineWidth = 1.0
        
        return line1;
    }

    func singleLinePathAttributed() -> CAShapeLayer {
        let attString = attributedString(for: SINGLE_LINE_STRING)
        let line1 = CAShapeLayer()
        let path = UIBezierPath(for: attString).cgPath
        line1.path = path
        line1.bounds = path.boundingBox
        line1.isGeometryFlipped = true
        line1.fillColor = UIColor.white.cgColor
        line1.strokeColor = UIColor.black.cgColor
        line1.lineWidth = 1.0
        
        return line1
    }

    func multiLinePathAttributed() -> CAShapeLayer {
        let mutAttr = attributedString(for: MULTI_LINE_STRING).mutableCopy() as! NSMutableAttributedString
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = .justified
        
        mutAttr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutAttr.length))
        
        let line2 = CAShapeLayer()
        let path = UIBezierPath(forMultilineAttributedString: mutAttr,
                                maxWidth: view.bounds.width - 100).cgPath
        line2.path = path
        line2.bounds = path.boundingBox
        line2.isGeometryFlipped = true
        line2.fillColor = UIColor.white.cgColor
        line2.strokeColor = UIColor.black.cgColor
        line2.lineWidth = 1.0
        
        return line2
    }

    func multiLinePathStandardLineBreaks() -> CAShapeLayer {
        let line3 = CAShapeLayer()
        let path = UIBezierPath(forMultilineString: MULTI_LINE_STRING_LINE_BREAKS,
                                with: UIFont.boldSystemFont(ofSize: 40.0),
                                maxWidth: view.bounds.width - 100,
                                textAlignment: .center).cgPath
        line3.path = path
        line3.bounds = path.boundingBox
        line3.isGeometryFlipped = true
        line3.fillColor = UIColor.white.cgColor
        line3.strokeColor = UIColor.black.cgColor
        line3.lineWidth = 1.0
        
        return line3
    }
}
