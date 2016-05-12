import UIKit
import SWRevealViewController
import FeedHenry

class DataBrowserViewController: UIViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    
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
    @IBAction func saveData(sender: AnyObject) {
        print("Call cloud was clicked")
        self.saveButton.enabled = false
        
        let args = ["collection": "Users", "document": ["data": nameLabel.text ?? ""]]
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate where !delegate.initSuccess {
            delegate.presentAlert("Initialisation failure", message: "Relaunch the app once you fixed the configuration plist file.")
            self.saveButton.enabled = true
        } else { // init is successful
            FH.cloud("saveData", method: HTTPMethod.POST,
                     args: args, headers: nil,
                     completionHandler: {(resp: Response, error: NSError?) -> Void in
                        self.saveButton.enabled = true
                        self.view.endEditing(true)
                        if let error = error {
                            print("Cloud Call Failed, \(error)")
                            return
                        }
                        let alert = UIAlertController(title: "Success", message: "Yay, your data was saved in the cloud", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok, cool!", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
}
