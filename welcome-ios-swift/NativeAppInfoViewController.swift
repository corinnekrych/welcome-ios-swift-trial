import UIKit
import SWRevealViewController
import FeedHenry

class NativeAppInfoViewController: UIViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var envLabel: UILabel!
    @IBOutlet weak var portLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate where !delegate.initSuccess {
            delegate.presentAlert("Initialisation failure", message: "Relaunch the app once you fixed the configuration plist file.")
        } else { // init is successful
            FH.cloud("getFhVars", method: HTTPMethod.POST,
                     args: nil, headers: nil,
                     completionHandler: {(resp: Response, error: NSError?) -> Void in

                        if let error = error {
                            print("Cloud Call Failed, \(error)")
                            return
                        }
                        if let parsedRes = resp.parsedResponse as? [String: String] {
                            if let value = parsedRes["appName"] {
                                self.appNameLabel.text = value
                            }
                            if let value = parsedRes["domain"] {
                                self.domainLabel.text = value
                            }
                            if let value = parsedRes["env"] {
                                self.envLabel.text = value
                            }
                            if let value = parsedRes["port"] {
                                self.portLabel.text = value
                            }
                        }

            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
