import UIKit

let twitterConsumerKey = "dQbFF4CNT3URLPK4cCkplujYS"
let twitterConsumerSecret = "Qw8aCAJQamraxbQli9gznScuSM3RCgDFDCSrAXyZHnxoKB5yOO"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    //define a block as parameter, so it can be used for a later intervention from caller
    var loginCompletion: ((user:User?, error:NSError?) -> ())?
    
    //use class calculation property with static struc to create singleton property
    class var sharedInstance : TwitterClient {
    //since there is no static class property, we have to use this class property with static struct
    struct Static {
        static  let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    func homeTimelineCompletionWithParams (params:NSDictionary?, completion: (tweets:[Tweet]?, error:NSError?) ->()) {
         GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("timeline is \(response)")
            var tweets = Tweet.tweetsWithArray(  response as [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error : NSError!) -> Void in
                println("error getting timeline \(error)")
            completion (tweets: nil, error: error)
        })
    }
    func postNewTweetCompletionWithParams (params:NSDictionary?, completion: (tweet:Tweet?, error:NSError?) ->()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("timeline is \(response)")
            var Newtweet = Tweet(dictionary: response as NSDictionary)
            
            completion(tweet:Newtweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error : NSError!) -> Void in
                println("error post new tweet \(error)")
                completion (tweet: nil, error: error)
        })
    }
    func postFavoriteCompletionWithParams (params:NSDictionary?, completion: (tweet:Tweet?, error:NSError?) ->()) {
        POST("1.1/favorites/create.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("favorite is \(response)")
            var Newtweet = Tweet(dictionary: response as NSDictionary)
            
            completion(tweet:Newtweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error : NSError!) -> Void in
                println("error post favorite \(error)")
                completion (tweet: nil, error: error)
        })
    }
    func postunFavoriteCompletionWithParams (params:NSDictionary?, completion: (tweet:Tweet?, error:NSError?) ->()) {
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("favorite is \(response)")
            var Newtweet = Tweet(dictionary: response as NSDictionary)
            
            completion(tweet:Newtweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error : NSError!) -> Void in
                println("error post favorite \(error)")
                completion (tweet: nil, error: error)
        })
    }
    //example: GET : https://api.twitter.com/1.1/statuses/retweets/509457288717819904.json
    func postRetweetCompletionWithParams (params:NSDictionary?, completion: (tweet:Tweet?, error:NSError?) ->()) {
        let idretweet  = params?.objectForKey("id") as NSNumber
        
        POST("1.1/statuses/retweet/\(idretweet).json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var Newtweet = Tweet(dictionary: response as NSDictionary)
            completion(tweet:Newtweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error : NSError!) -> Void in
                println("error post retweet \(error)")
                completion (tweet: nil, error: error)
        })
    }
 
    func loginWithCompletion (completion: (user:User?, error:NSError?) -> ()) {
        loginCompletion = completion
        //fetch reqeuest token , redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterclient://oauth"), scope: nil,
        success: {(requestToken: BDBOAuthToken!) -> Void in
            println ("get the request token")
            var authURL = NSURL (string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            //url link configuration required in the project for handler :cptwitterclient
            UIApplication.sharedApplication().openURL(authURL)
        }) { (error:NSError!) -> Void in
                println ("error to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    func  openURL(url:NSURL) {
        //first, getting access token
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken:BDBOAuthToken(queryString: url.query),
            success: { (accessToken: BDBOAuthToken!) -> Void in
                println("success get acces token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
 
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:  AnyObject!) -> Void in
                    var user = User(dictionary: response as NSDictionary)
                    //store current user information in usdatadefault for later use
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                }, failure : { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                       self.loginCompletion! (user: nil , error: error)
                })
                             }) { (error: NSError!) -> Void in
                println ("error getting access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
}
