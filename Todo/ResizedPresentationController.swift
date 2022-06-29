//
//  ResizedPresentationController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 31/05/2022.
//

import UIKit

// create a half screen presentation viewcontroller
class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }
        return CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: bounds.height/2)
    }
}
//class OneFourthSizePresentationController: UIPresentationController {
//    override var frameOfPresentedViewInContainerView: CGRect {
//        guard let bounds = containerView?.bounds else { return .zero }
//        return CGRect(x: 0, y: bounds.height*3/4, width: bounds.width, height: bounds.height/4)
//    }
//}
