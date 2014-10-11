import UIKit

class SingleTweetViewController: UIViewController {
    
    var tweet:Tweet?
    var favorite: NSNumber?
    var favoriteCount: NSNumber?
    var retweeted:NSNumber?
    var retweetCount:NSNumber?
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelScreenName: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelNumberOfRetweets: UILabel!
    @IBOutlet weak var labelNumberofFavorite: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var buttonRetweet: UIButton!
    @IBOutlet weak var buttonReply: UIButton!
    @IBOutlet weak var textViewText: UITextView!
    @IBAction func onRetweet(sender: AnyObject) {
        let id = tweet!.id! as NSNumber
        var params: NSDictionary = ["id" : id]
        if retweeted == 0 {
            retweeted = 1
            retweetCount = retweetCount! +  1
            labelNumberOfRetweets.text = "\(retweetCount!)"
            self.buttonRetweet.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
            TwitterClient.sharedInstance.postRetweetCompletionWithParams(params, completion: { (tweet, error) -> () in
                if error != nil {
                    println (" retweet error")
                    self.retweetCount = self.retweetCount! - 1
                    self.labelNumberOfRetweets.text = "\(self.retweetCount!)"

                    self.buttonRetweet.setImage(UIImage(named: "retweet.png"), forState: UIControlState.Normal)
                    self.retweeted = 0
                } else {
                    println ("retweet done")
                }
            })
        }
    }
    @IBAction func onFavorite(sender: UIButton) {
        let id = tweet!.id! as NSNumber
        var params: NSDictionary = ["id" : id]
        if favorite == 1 {
             favorite = 0
            favoriteCount = favoriteCount! - 1
            labelNumberofFavorite.text = "\(favoriteCount!)"
            
            self.buttonFavorite.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
            TwitterClient.sharedInstance.postunFavoriteCompletionWithParams(params ) { (tweet, error) -> () in
                if error != nil {
                    println ("un favorite error")
                    self.buttonFavorite.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
                     self.favorite = 1
                 } else {
                    println ("un favorite")
                }
            }
        } else {
            favorite = 1
            favoriteCount = favoriteCount! + 1
            labelNumberofFavorite.text = "\(favoriteCount!)"
            self.buttonFavorite.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)

            TwitterClient.sharedInstance.postFavoriteCompletionWithParams(params ) { (tweet, error) -> () in
                if error != nil {
                    println ("post favorite error")
                    self.buttonFavorite.setImage(UIImage(named: "favorite.png"), forState: UIControlState.Normal)
                     self.favorite = 0
                 } else {
                    println ("post favorite")
                }
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toReply" {
            let nvc = segue.destinationViewController as UINavigationController
            for each in nvc.childViewControllers {
                if each.isKindOfClass(NewTweetViewController) == true {
                    let vc = each as NewTweetViewController
                    vc.isReply = true
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favorite = tweet?.favorited
        favoriteCount = tweet!.favorite_count?
        retweeted = tweet?.retweeted
        retweetCount = tweet?.retweet_count
        
        self.title  = "Tweet"
        self.textViewText.editable = false
        self.textViewText.linkTextAttributes =  [NSForegroundColorAttributeName : UIColor .blueColor()]
        self.textViewText.text = tweet?.text
        self.textViewText.dataDetectorTypes = UIDataDetectorTypes.Link
        self.textViewText.alpha = 1
        println("tweet is \(tweet?.user?.name) , favorite \(tweet?.favorited), retweeted: \(tweet?.retweeted)")
        self.labelName.backgroundColor = UIColor.whiteColor()
        self.labelName.backgroundColor = UIColor.whiteColor()
         self.labelScreenName.backgroundColor =  UIColor.whiteColor()
        self.labelTime.backgroundColor =  UIColor.whiteColor()
        self.labelNumberofFavorite.backgroundColor = UIColor.whiteColor()
        self.labelNumberOfRetweets.backgroundColor = UIColor.whiteColor()
        self.labelName.text = tweet?.user?.name
        self.labelScreenName.text = "@\(tweet!.user!.screenName!)"
        let imgURL = tweet?.user?.profileImageURL
        self.imgProfile.setImageWithURL( NSURL(string:imgURL!) )
        var formatter = NSDateFormatter()
        formatter.dateFormat =  "MM/dd/yyyy hh:mm:ss a"
        self.labelTime.text = formatter.stringFromDate(tweet!.createAt!)
        self.labelNumberOfRetweets.text = "\(tweet!.retweet_count!)"
        self.labelNumberofFavorite.text = "\(tweet!.favorite_count!)"
        if tweet?.favorited == 1 {
             self.buttonFavorite.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
        if tweet?.retweeted == 1 {
             self.buttonRetweet.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }
    }

   
}
