import UIKit
import SWRevealViewController
import FeedHenry

class LocationViewController: UIViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var weatherButton: UIButton!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherDate: UILabel!
    @IBOutlet weak var weatherLow: UILabel!
    @IBOutlet weak var weatherHigh: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retrieveWeatherInfo(sender: AnyObject) {
        print("Call cloud was clicked")
        self.weatherButton.enabled = false
        
        let args = ["lat":latitudeLabel.text ?? "", "lon": longitudeLabel.text ?? ""]
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate where !delegate.initSuccess {
            delegate.presentAlert("Initialisation failure", message: "Relaunch the app once you fixed the configuration plist file.")
            self.weatherButton.enabled = true
        } else { // init is successful
            FH.cloud("getWeather", method: HTTPMethod.POST,
                     args: args, headers: nil,
                     completionHandler: {(resp: Response, error: NSError?) -> Void in
                        self.weatherButton.enabled = true
                        if let error = error {
                            print("Cloud Call Failed, \(error)")
                            return
                        }
                        if let parsedRes = resp.parsedResponse as? [String: AnyObject],
                            let responseData = parsedRes["data"] as? [AnyObject],
                            let data = responseData[0] as? [String: AnyObject] {
                            if let value = data["desc"] as? String {
                                self.weatherDescription.text = value
                            }
                            if let value = data["date"] as? String {
                                self.weatherDate.text = value
                            }
                            if let value = data["low"] as? String {
                                self.weatherLow.text = value
                            }
                            if let value = data["high"] as? String {
                                self.weatherHigh.text = value
                            }
                        }
            })
        }
    }
}
