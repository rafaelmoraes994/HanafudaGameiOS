//
//  DragAndDropManager.swift
//  Hanafuda - Koi Koi
//
//  Created by Rafael on 3/5/18.
//  Copyright © 2018 Rafael. All rights reserved.
//

import UIKit

protocol GameCardMovement {
    func didStartLongPress()
    func didStopLongPress()
}

class DragAndDropManager: KDDragAndDropManager {
    
    var delegate: GameCardMovement?
    
    override func updateForLongPress(_ recogniser: UILongPressGestureRecognizer) {
        guard let bundle = self.bundle else { return }
        
        let pointOnCanvas = recogniser.location(in: recogniser.view)
        let sourceDraggable : KDDraggable = bundle.sourceDraggableView as! KDDraggable
        let pointOnSourceDraggable = recogniser.location(in: bundle.sourceDraggableView)
        
        switch recogniser.state {
            
            
        case .began :
            self.canvas.addSubview(bundle.representationImageView)
            sourceDraggable.startDraggingAtPoint(pointOnSourceDraggable)
            delegate?.didStartLongPress()
            
        case .changed :
            
            // Update the frame of the representation image
            var repImgFrame = bundle.representationImageView.frame
            repImgFrame.origin = CGPoint(x: pointOnCanvas.x - bundle.offset.x, y: pointOnCanvas.y - bundle.offset.y);
            bundle.representationImageView.frame = repImgFrame
            
            var overlappingAreaMAX: CGFloat = 0.0
            
            var mainOverView: UIView?
            
            for view in self.views where view is KDDraggable  {
                
                let viewFrameOnCanvas = self.convertRectToCanvas(view.frame, fromView: view)
                
                
                /*                 ┌────────┐   ┌────────────┐
                 *                 │       ┌┼───│Intersection│
                 *                 │       ││   └────────────┘
                 *                 │   ▼───┘│
                 * ████████████████│████████│████████████████
                 * ████████████████└────────┘████████████████
                 * ██████████████████████████████████████████
                 */
                
                let overlappingAreaCurrent = bundle.representationImageView.frame.intersection(viewFrameOnCanvas).area
                
                if overlappingAreaCurrent > overlappingAreaMAX {
                    
                    overlappingAreaMAX = overlappingAreaCurrent
                    
                    mainOverView = view
                }
                
                
            }
            
            
            
            if let droppable = mainOverView as? KDDroppable {
                
                let rect = self.canvas.convert(bundle.representationImageView.frame, to: mainOverView)
                
                if droppable.canDropAtRect(rect) {
                    
                    if mainOverView != bundle.overDroppableView { // if it is the first time we are entering
                        
                        (bundle.overDroppableView as! KDDroppable).didMoveOutItem(bundle.dataItem)
                        droppable.willMoveItem(bundle.dataItem, inRect: rect)
                    }
                    
                    // set the view the dragged element is over
                    self.bundle!.overDroppableView = mainOverView
                    
                    droppable.didMoveItem(bundle.dataItem, inRect: rect)
                    
                }
            }
            
            
        case .ended :
            
            if bundle.sourceDraggableView != bundle.overDroppableView { // if we are actually dropping over a new view.
                
                if let droppable = bundle.overDroppableView as? KDDroppable {
                    
                    sourceDraggable.dragDataItem(bundle.dataItem)
                    
                    let rect = self.canvas.convert(bundle.representationImageView.frame, to: bundle.overDroppableView)
                    
                    droppable.dropDataItem(bundle.dataItem, atRect: rect)
                    
                }
            }
            
            
            bundle.representationImageView.removeFromSuperview()
            sourceDraggable.stopDragging()
            
        default:
            break
            
        }
    }
        
    
    
}
