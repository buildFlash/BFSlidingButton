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

class BFSlidingButtonTrackLayer: CALayer {
	weak var slidingButton: BFSlidingButton?
	
	override func draw(in ctx: CGContext) {
		guard let slider = slidingButton else {
			return
		}
		
		let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		ctx.addPath(path.cgPath)
		
		ctx.setFillColor(slider.trackTintColor.cgColor)
		ctx.fillPath()
		
		ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
		let minimumValuePosition = slider.positionForValue(slider.minimumValue)
		let thumbValuePosition = slider.positionForValue(slider.lowerValue)
		let maxValuePosition = slider.positionForValue(slider.maximumValue)
		let rect = CGRect(x: minimumValuePosition, y: 0,
						  width: thumbValuePosition - minimumValuePosition + slider.thumbSize.width/2,
						  height: bounds.height)
		ctx.fill(rect)
		ctx.setFillColor(slider.trackTintColor.cgColor)
		ctx.fillPath()
		
		ctx.setFillColor(slider.trackHighlightSecondaryTintColor.cgColor)

		let rect2 = CGRect(x: thumbValuePosition+slider.thumbSize.width/2, y: 0,
						   width: maxValuePosition - thumbValuePosition + slider.thumbSize.width/2,
						   height: bounds.height)
		ctx.fill(rect2)
	}

}
