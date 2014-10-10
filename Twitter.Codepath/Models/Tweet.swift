import UIKit

class Tweet : NSObject {
    var user: User?
    var text :String?
    var createAtString:String?
    var createAt: NSDate?
    var favorite_count: NSNumber?
    var favorited : NSNumber?
    var retweet_count : NSNumber?
    var retweeted :NSNumber?
    var id :NSNumber?
    init (dictionary:NSDictionary) {
        //println(dictionary)
        user = User(dictionary:dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createAtString = dictionary ["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createAt = formatter.dateFromString(createAtString!)
        favorited = dictionary ["favorited"] as? NSNumber
        favorite_count = dictionary["favorite_count"] as? NSNumber
        retweet_count = dictionary["retweet_count"] as? NSNumber
        retweeted = dictionary["retweeted"] as? NSNumber
        id = dictionary["id"] as? NSNumber
    }
    class func tweetsWithArray(array: [NSDictionary] )  -> [Tweet] {   
        var tweets = [Tweet]()
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
         return tweets
    }    
}