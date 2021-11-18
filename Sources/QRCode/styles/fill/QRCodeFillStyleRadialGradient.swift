//
//  QRCodeFillStyleRadialGradient.swift
//
//  Created by Darren Ford on 16/11/21.
//  Copyright © 2021 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import CoreGraphics

public extension QRCode.FillStyle {
	/// A simple radial gradient fill
	@objc(QRCodeFillStyleRadialGradient)
	class RadialGradient: NSObject, QRCodeFillStyleGenerator {
		let gradient: QRGradient

		// For radial gradients, the center point
		public var centerPoint: CGPoint

		/// Fill the specified path/rect with a gradient
		/// - Parameters:
		///   - gradient: The color gradient to use
		///   - centerPoint: The fractional position within the fill rect to start the radial fill (0.0 -> 1.0)
		@objc public init(_ gradient: QRGradient, centerPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) {
			self.gradient = gradient
			self.centerPoint = centerPoint
		}

		/// Fill the specified rect with the gradient
		public func fill(ctx: CGContext, rect: CGRect) {
			let grCentre = self.gradientCenterPt(forSize: rect.width)
			let grRadius = rect.width / 1.75
			ctx.drawRadialGradient(
				self.gradient.cgGradient,
				startCenter: self.gradientCenterPt(forSize: rect.width), startRadius: 0,
				endCenter: grCentre, endRadius: grRadius,
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
		}

		/// Fill the specified path with the gradient
		public func fill(ctx: CGContext, rect: CGRect, path: CGPath) {
			ctx.addPath(path)
			ctx.clip()

			let grCentre = self.gradientCenterPt(forSize: rect.width)
			let grRadius = rect.width / 1.75
			ctx.drawRadialGradient(
				self.gradient.cgGradient,
				startCenter: self.gradientCenterPt(forSize: rect.width), startRadius: 0,
				endCenter: grCentre, endRadius: grRadius,
				options: [.drawsAfterEndLocation, .drawsBeforeStartLocation])
		}

		public func copyStyle() -> QRCodeFillStyleGenerator {
			return RadialGradient(
				self.gradient.copyGradient(),
				centerPoint: self.centerPoint
			)
		}

		private func gradientCenterPt(forSize: CGFloat) -> CGPoint {
			return CGPoint(x: self.centerPoint.x * forSize, y: self.centerPoint.y * forSize)
		}
	}
}
