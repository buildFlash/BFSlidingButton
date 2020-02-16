/// Copyright (c) 2019 Aryan Sharma
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class BFSlidingButton: UIControl {
	var minimumValue: CGFloat = 0 {
		didSet {
			updateLayerFrames()
		}
	}
	
	var maximumValue: CGFloat = 1 {
		didSet {
			updateLayerFrames()
		}
	}
	
	var lowerValue: CGFloat = 0 {
		didSet {
			updateLayerFrames()
		}
	}
	
	var trackTintColor = UIColor(white: 0.9, alpha: 1) {
		didSet {
			trackLayer.setNeedsDisplay()
		}
	}
	
	var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
		didSet {
			trackLayer.setNeedsDisplay()
		}
	}
	
	var trackHighlightSecondaryTintColor = UIColor(red: 0.95, green: 0.0, blue: 0.12, alpha: 1) {
		didSet {
			trackLayer.setNeedsDisplay()
		}
	}
	
	var thumbImage = #imageLiteral(resourceName: "attendanceMarkedOut") {
		didSet {
			lowerThumbImageView.image = thumbImage
			updateLayerFrames()
		}
	}
	
	var highlightedThumbImage = #imageLiteral(resourceName: "attendanceMarkedOut") {
		didSet {
			lowerThumbImageView.highlightedImage = highlightedThumbImage
			updateLayerFrames()
		}
	}
	
	var text: String = "" {
		didSet {
			
			UIView.transition(with: label,
							  duration: 0.25,
							  options: .transitionCrossDissolve,
							  animations: {
								self.label.text = self.text
								self.updateLayerFrames()
			}, completion: nil)
		}
	}
	
	var font: UIFont = UIFont.systemFont(ofSize: 17) {
		didSet {
			label.font = font
			updateLayerFrames()
		}
	}
	
	var textColor: UIColor = UIColor.black {
		didSet {
			label.textColor = textColor
			updateLayerFrames()
		}
	}
	
	var textBackgroundColor: UIColor = UIColor.clear {
		didSet {
			label.backgroundColor = textBackgroundColor
			updateLayerFrames()
		}
	}
	
	var textAlignment: NSTextAlignment = .center {
		didSet {
			label.textAlignment = textAlignment
			updateLayerFrames()
		}
	}
	
	var isSliding = false
	
	var thumbSize = CGSize(width: 65, height: 65)

	private let trackLayer = BFSlidingButtonTrackLayer()
	private let lowerThumbImageView = UIImageView()
	private var previousLocation = CGPoint()
	private let label = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		trackLayer.slidingButton = self
		trackLayer.contentsScale = UIScreen.main.scale
		layer.addSublayer(trackLayer)
		addSubview(label)
		lowerThumbImageView.isUserInteractionEnabled = false
		lowerThumbImageView.image = thumbImage
		addSubview(lowerThumbImageView)
		lowerThumbImageView.clipsToBounds = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func updateLayerFrames() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)

		trackLayer.frame = bounds.insetBy(dx: 0.0, dy: 0.0)
		trackLayer.setNeedsDisplay()
		label.frame.size = CGSize(width: frame.width - thumbSize.width, height: frame.height*0.8)
		label.center = CGPoint(x: frame.width/2, y: frame.height/2)
		lowerThumbImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue),
										   size: thumbSize)
		CATransaction.commit()

	}
	
	func positionForValue(_ value: CGFloat) -> CGFloat {
		return (bounds.width - thumbSize.width) * value
	}
	
	private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
		let x = positionForValue(value)
		return CGPoint(x: x, y: (bounds.height - thumbSize.height) / 2.0)
	}

	override var frame: CGRect {
		didSet {
			updateLayerFrames()
		}
	}


}

extension BFSlidingButton {
	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		
		isSliding = true
		previousLocation = touch.location(in: self)
		
		
		if lowerThumbImageView.frame.contains(previousLocation) {
			lowerThumbImageView.isHighlighted = true
		}
		
		return lowerThumbImageView.isHighlighted
	}
	
	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let location = touch.location(in: self)
		isSliding = true

		
		let deltaLocation = location.x - previousLocation.x
		let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
		
		previousLocation = location
		
		
		if lowerThumbImageView.isHighlighted {
			lowerValue += deltaValue
			lowerValue = boundValue(lowerValue, toLowerValue: minimumValue,
									upperValue: maximumValue)
		}
		return true
	}
	
	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		lowerThumbImageView.isHighlighted = false
		isSliding = false
		sendActions(for: .valueChanged)

	}

	
	
	private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
							upperValue: CGFloat) -> CGFloat {
		return min(max(value, lowerValue), upperValue)
	}

}
