import UIKit
import SWRevealViewController
import FeedHenry

class CallCloudViewController: UIViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var cloudButton: UIButton!
    
    @IBOutlet weak var result: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.cloudButton.enabled = false
        // Initialized cloud connection
        FH.init {(resp: Response, error: NSError?) -> Void in
            if let error = error {
                print("FH init failed. Error = \(error)")
                if FH.isOnline == false {
                    self.result.text = "Make sure you're online."
                } else {
                    self.result.text = "Please fill in fhconfig.plist file."
                }
                return
            }
            print("initialized OK")
            self.cloudButton.enabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callcloud(sender: UIButton) {
        print("Call cloud was clicked")
        self.cloudButton.enabled = false
        FH.cloud("hello", method: HTTPMethod.POST,
                 args: nil, headers: nil,
                 completionHandler: {(resp: Response, error: NSError?) -> Void in
                    self.cloudButton.enabled = true
                    if let error = error {
                        print("Cloud Call Failed, \(error)")
                        self.result.text = "Error during Cloud call: \(error.userInfo[NSLocalizedDescriptionKey]!)"
                        return
                    }
                    if let parsedRes = resp.parsedResponse as? [String:String] {
                        self.result.text = parsedRes["msg"]
                    }
        })        
    }
}
