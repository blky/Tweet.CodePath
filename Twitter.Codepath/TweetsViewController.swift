import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func NewTweet(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("NewTweetNavigationVC") as NewTweetViewController
         self.navigationController?.pushViewController(controller, animated: true)
        
    }
    var tweets:[Tweet]?
    
    @IBAction func onLogout(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println ("count is \(self.tweets?.count)")
        return self.tweets?.count ?? 0
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetListCell") as TweetsListTableViewCell
        cell.tweet = tweets?[indexPath.row]
        return cell
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("singleTweetVC") as SingleTweetViewController
        controller.tweet = self.tweets![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true )
        TwitterClient.sharedInstance.homeTimelineCompletionWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        

        self.title = "Home"
        TwitterClient.sharedInstance.homeTimelineCompletionWithParams(nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
            println("tweets count is \(self.tweets?.count)")
             self.tableView.reloadData()
            })
 
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        
    }
    func refresh( refreshControl : UIRefreshControl)
    {
        refreshControl.beginRefreshing()
        TwitterClient.sharedInstance.homeTimelineCompletionWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        refreshControl.endRefreshing()
    }
  

}
