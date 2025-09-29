//: [Previous](@previous)
import UIKit
import PlaygroundSupport

class DrawViewController: UIViewController {
	override func loadView() {
		let view = UIView()
		view.backgroundColor = .gray

		let myView = BoardingPassView()
//		let myView = TestingView()
		myView.frame = CGRect(x: 0, y: 0, width: 300, height: 600)
//		myView.backgroundColor = .gray
		view.addSubview(myView)
		self.view = view
		//myView.setNeedsDisplay()
	}
}

class BoardingPassView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		//setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		//setupView()
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		setupView()
		debugPrint("called draw")
	}

	func setupView() {

		let offset:CGFloat    	= 0;
		let squareWidth:Int 	  	= 10
		let squareRows:Int    	= Int(self.frame.size.width/CGFloat(squareWidth))
		let squareColumns:Int 	= Int(self.frame.size.height/CGFloat(squareWidth))

		for (index,_) in (0...squareRows).enumerated() {
			for (column,_) in (0...squareColumns).enumerated() {
					// Build The Square
				let rectanglePath = UIBezierPath(roundedRect: CGRectMake(
					self.frame.minX + CGFloat(squareWidth * index) - offset,
					self.frame.minY + CGFloat(column * squareWidth), 10, 10),cornerRadius: 0.00)

					// Style Square
				let a = CAShapeLayer()
				a.path = rectanglePath.cgPath
				a.strokeColor = UIColor.white.cgColor
//				if (self.frame.midX == self.frame.size.height/2) || (self.frame.midY == self.frame.size.width/2) {
//					a.fillColor = UIColor.blue.cgColor
//				}else{
					a.fillColor = UIColor.yellow.cgColor
//				}

				a.opacity = 0.3
				a.lineWidth = 1
				self.layer.insertSublayer(a, at: 1)
			}
		}

		let path: UIBezierPath = getPath()

		let shape = CAShapeLayer()
		shape.path = path.cgPath
		shape.lineWidth = 2.0
		shape.strokeColor = UIColor.white.cgColor
		shape.fillColor = UIColor.clear.cgColor

		self.layer.addSublayer(shape)
	}

	func getPath() -> UIBezierPath {
		let path: UIBezierPath = UIBezierPath()

		let rect = self.frame

		path.move(to: CGPoint(x: rect.minX + 30, y: rect.minY))

			//Top Edge
		path.addLine(to: CGPoint(x: rect.maxX - 30, y: rect.minY))

			//Right Top Curve
		path.addArc(withCenter: CGPoint(x:  rect.maxX - 30, y:  rect.minY + 40), radius: 40, startAngle: CGFloat(Double.pi/2 * 3), endAngle: 0, clockwise: true)
//
//			//Right Edge
		path.addLine(to: CGPoint(x: rect.maxX + 10, y: rect.midY + 40))
//
//			//Semicircle on Right Edge
		path.addArc(withCenter: CGPoint(x: rect.maxX + 10, y: rect.midY + 55), radius: 15, startAngle: CGFloat(Double.pi/2 * 3), endAngle: CGFloat(Double.pi/2), clockwise: false)
//
//			//Right Edge second half
		path.addLine(to: CGPoint(x: rect.maxX + 10, y: rect.midY + 70))
//
//			//Right bottom curve
		path.addArc(withCenter: CGPoint(x: rect.maxX - 30, y: rect.maxY - 30), radius: 40, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi/2), clockwise: true)
//
//			//Bottom Edge
		path.addLine(to: CGPoint(x: rect.minX + 40, y: rect.maxY + 10))
//
//			//Left bottom curve
		path.addArc(withCenter: CGPoint(x: rect.minX + 40, y: rect.maxY - 30), radius: 40, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
//
//			//Left second half
		path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + 70))
//
//			//Semicircle on left edge
		path.addArc(withCenter: CGPoint(x: rect.minX, y: rect.midY + 55), radius: 15, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi/2 * 3), clockwise: false)
//
//			//Left Edge
		path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 40))
//
//			//Left Top Curve
		path.addArc(withCenter: CGPoint(x:  rect.minX + 40, y:  rect.minY + 40), radius: 40, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi/2 * 3), clockwise: true)
//
//			//Moving to the semicircle
		path.move(to: CGPoint(x: rect.minX + 15, y: rect.midY + 55))
//
//			//Line from left semicircle to right
		path.addLine(to: CGPoint(x: rect.maxX - 5, y: rect.midY + 55))

		path.close()
		return path
	}
}

class TestingView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}

	func setupView() {

		let path: UIBezierPath = getPath()

		let shape = CAShapeLayer()
		shape.path = path.cgPath
		shape.lineWidth = 2.0
		shape.strokeColor = UIColor.white.cgColor
		shape.fillColor = UIColor.clear.cgColor

		self.layer.addSublayer(shape)
	}

	func getPath() -> UIBezierPath {
		let path: UIBezierPath = UIBezierPath()

		path.move(to: CGPoint(x: 50, y: 10))
		path.addLine(to: CGPoint(x: 260, y: 10))
		


		path.close()
		return path
	}
}
PlaygroundPage.current.liveView = DrawViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)
