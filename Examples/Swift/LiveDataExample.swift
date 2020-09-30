import Mapbox

@objc(LiveDataExample_Swift)

class LiveDataExample: UIViewController, MGLMapViewDelegate {

    var source: MGLShapeSource!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a new map view using the Mapbox Dark style.
        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: MGLStyle.darkStyleURL(withVersion: 9))
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.tintColor = .gray

        // Set the map view‘s delegate property.
        mapView.delegate = self
        view.addSubview(mapView)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let url0 = "https://wanderdrone.appspot.com/"
        let url1 = "http://192.168.0.168:8080/feature/"
        let url2 = "http://192.168.0.168:8080/featureCollection/"
        guard let url = URL(string: url2) else {
            return
        }
        // Add a source to the map. https://wanderdrone.appspot.com/ generates coordinates for simulated paths.
        source = MGLShapeSource(identifier: "wanderdrone", url: url, options: nil)

//        var coors = [
//            CLLocationCoordinate2D.init(latitude: 30, longitude: 30),
//            CLLocationCoordinate2D.init(latitude: 31, longitude: 31)
//        ]
//        let polygonFeature = MGLPolygonFeature.init(coordinates: &coors, count: UInt(coors.count))
//        let emptyFeature = MGLEmptyFeature.init()
//
//        let features: [MGLShape & MGLFeature] = [
//            polygonFeature,
//            emptyFeature,
//        ]
//        source = MGLShapeSource.init(identifier: "zva", features: features, options: nil)

        style.addSource(source)

        // Add a Maki icon to the map to represent the drone's coordinate. The specified icon is included in the Mapbox Dark style's sprite sheet. For more information about Maki icons, see   https://www.mapbox.com/maki-icons/
        let droneLayer = MGLSymbolStyleLayer(identifier: "wanderdrone", source: source)

//        droneLayer.iconImageName = NSExpression(forConstantValue: "rocket-15")
//        droneLayer.iconHaloColor = NSExpression(forConstantValue: UIColor.white)

//        for emojiStr in ["😀", "❤️"] {
//            let emojiImg = emojiStr.emojiToImage()
//        }
//        let firstStr = "💀"
//        let firstStr = "\u{1F600}"
//        let first = firstStr.emojiToImage()!
//        style.setImage(first, forName: firstStr)

//        let secondStr = "💖"
//        let secondStr = "\u{1F496}"
//        let second = secondStr.emojiToImage()!
//        style.setImage(second, forName: secondStr)

        let emojis = allEmojis()
        for emoji in emojis {
            guard let icon = emoji.emojiToImage() else { return }
            style.setImage(icon, forName: emoji)
        }

        NSLog("emojis count \(emojis.count)")

//        let icons = [ firstStr: firstStr, secondStr: secondStr ]
        let iconsMap = emojis.reduce([String: String]()) { (dict, emoji) -> [String: String] in
            var dict = dict
            dict[emoji] = emoji
            return dict
        }

        NSLog("icons count \(iconsMap.count)")

        droneLayer.iconImageName = NSExpression(format: "FUNCTION(%@, 'valueForKeyPath:', name)", iconsMap)
//        droneLayer.iconImageName = NSExpression(forConstantValue: "zva-emoji")
//        droneLayer.text = NSExpression.init(forKeyPath: "name")
//        droneLayer.text = NSExpression.init(forConstantValue: "azaza")
//        droneLayer.textColor = NSExpression.init(forConstantValue: UIColor.white)

        style.addLayer(droneLayer)

        // Create a timer that calls the `updateUrl` function every 1.5 seconds.
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateUrl), userInfo: nil, repeats: true)
    }

    @objc func updateUrl() {
        // Update the icon's position by setting the `url` property on the source.
        source.url = source.url
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Invalidate the timer if the view will disappear.
        timer.invalidate()
        timer = Timer()
    }}

public func allEmojis() -> [String] {
    let ranges = [
//        Array(8400...8447),
//        Array(9100...9300),
//        Array(65024...65039),
//        Array(0x23F0...0x23FA),
//        Array(0x2600...0x27BF),
//        Array(0xFE00...0xFE0F),
        Array(0x1F170...0x1F251),
        Array(0x1F300...0x1F5FF),
        Array(0x1F600...0x1F64F),
        Array(0x1F680...0x1F6FF),
        Array(0x1F900...0x1F9FF)
//        [0x231A, 0x231B, 0x2328, 0x2B50]
    ]

    let all = ranges.joined().map {
        return String(Character(UnicodeScalar($0) ?? "-"))
    }

    return all
}

extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 48, height: 48)
        let rect = CGRect(origin: .zero, size: size)
        let textAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ]
        let textSize = (self as NSString).size(withAttributes: textAttributes)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
//        UIColor.clear.set()
        ctx?.setFillColor(UIColor.white.cgColor)
        ctx?.fillEllipse(in: rect)
        ctx?.restoreGState()
//        UIRectFill(CGRect(origin: .zero, size: size))
        self.draw(
            in: CGRect.init(
                x: (size.width - textSize.width) / 2,
                y: (size.width - textSize.width) / 2,
                width: textSize.width,
                height: textSize.height
            ),
            withAttributes: textAttributes
        )
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
