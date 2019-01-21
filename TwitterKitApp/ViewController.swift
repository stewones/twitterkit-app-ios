import UIKit
import TwitterKit
import TwitterCore

class ViewController: UIViewController, TWTRComposerViewControllerDelegate{
    
    
    
    @IBOutlet var imgTweet: UIImageView!
    @IBOutlet var tvTweet: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func touchLogout(_ sender: UIButton) {
        logout();
    }
    
    @IBAction func touchLogin(_ sender: UIButton) {
        login();
    }
    
    
    @IBAction func btnTwitterSharePressed(_ sender: UIButton) {
        if (Twitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            // App must have at least one logged-in user to compose a Tweet
            compose()
            
        } else {
            // Log in, and then check again
            Twitter.sharedInstance().logIn { session, error in
                
                
                if session != nil { // Log in succeeded
                    
                    self.compose()
                    
                } else {
                    let alert = UIAlertController(title: "No Twitter Accounts Available", message: "You must log in before presenting a composer.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okayd", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
        
        
    }
    
    
    func login() {
        // Log in, and then check again
        Twitter.sharedInstance().logIn { session, error in
            
            if session != nil { // Log in succeeded
                let alert = UIAlertController(title: "Yeah", message: "Log in succeeded. SESSION TOKEN: \(String(describing: session?.authToken))", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Okayd", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: false, completion: nil);
                
                print("SESSION TOKEN: \(String(describing: session?.authToken))")
            } else {
                print("ERROR: \(String(describing: error))")
//                let alert = UIAlertController(title: "Error", message: error as? String, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Okayd", style: UIAlertActionStyle.cancel, handler: nil))
//                self.present(alert, animated: false, completion: nil)
            }
        }
    }
    
    func logout() {
        let store = Twitter.sharedInstance().sessionStore
        
        if let userId = store.session()?.userID {
            store.logOutUserID(userId)
            
            let alert = UIAlertController(title: "Nooo", message: "User logged out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okayd", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    func compose() {
        guard let shareImg2 = UIImage.init(named: "gif") else{
            print("failed init share img")
            return
        }
        //let shareImg = UIImage.init(named: "mountain")!
        let composer = TWTRComposerViewController.init(initialText: "gif will be tweeted", image: shareImg2, videoURL: nil)
        composer.delegate = self
        present(composer, animated: true, completion: nil)
    }
    
    func composerDidCancel(_ controller: TWTRComposerViewController) {
        print("composerDidCancel, composer cancelled tweet")
    }
    
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        print("composerDidSucceed tweet published")
    }
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
        print("composerDidFail, tweet publish failed == \(error.localizedDescription)")
    }
    
}
