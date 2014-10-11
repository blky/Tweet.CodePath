import UIKit

class TweetsListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelScreenName: UILabel!
    @IBOutlet weak var imgViewProfileImg: UIImageView!
    @IBOutlet weak var imgReply: UIImageView!
    @IBOutlet weak var imgRetweet: UIImageView!
    @IBOutlet weak var imgFavorite: UIImageView!
    //@IBOutlet weak var imgTopRetweet: UIImageView!
   // @IBOutlet weak var labelTopRetweet: UILabel!
    var user:User?
    var tweet:Tweet? {
        willSet (newValue){
            self.labelName.backgroundColor = UIColor.whiteColor()
            self.labelName.backgroundColor = UIColor.whiteColor()
            self.labelText.backgroundColor =  UIColor.whiteColor()
            self.labelScreenName.backgroundColor =  UIColor.whiteColor()
            self.labelTime.backgroundColor =  UIColor.whiteColor()
            
            //println("cell is \(newValue?.user?.name)")
            self.labelName.text = newValue?.user?.name
            self.labelScreenName.text = "@\(newValue!.user!.screenName!)"
            self.labelText.text = newValue?.text
            let imgURL = newValue?.user?.profileImageURL
            self.imgViewProfileImg.setImageWithURL( NSURL(string:imgURL!) )
            self.labelTime.text = newValue?.createAt!.timeAgo()!
            //println("from Cell: tweet is \(newValue?.user?.name) , favorite \(newValue?.favorited), retweeted: \(newValue?.retweeted)")
            if newValue?.favorited == 1 {
                 self.imgFavorite.image = UIImage(named: "favorite_on.png")
            } else {
                self.imgFavorite.image = UIImage(named: "favorite.png")
            }
            if newValue?.retweeted == 1 {
                 self.imgRetweet.image = UIImage(named: "retweet_on.png")
            } else {
                self.imgRetweet.image = UIImage(named: "retweet.png")
            }
            }
    }
    
    
     

}
