import UIKit

//persistance by class property (type property)
var _currentUser:User?
let kCurrentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User :NSObject {
    var name: String?
    var screenName: String?
    var profileImageURL: String?
    var tagLine: String?
    //store this for persistence handling, object needs to be able to serilized to store in either nsuserDefault or cloud
    var dictionary : NSDictionary?
    
    init(dictionary : NSDictionary){
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String!
        profileImageURL =   dictionary ["profile_image_url"]  as? String
        tagLine = dictionary["description"] as? String
        self.dictionary = dictionary
    }
    
    class var currentUser:User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(kCurrentUserKey) as? NSData
                if data != nil {  //user just boot up with previously login already
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
            }
        }
        return _currentUser
        }
        set (user) {
            _currentUser = user
            if _currentUser != nil { //persistantly store login use information
                println ("store user info")
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: kCurrentUserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else { //log out basically
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: kCurrentUserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
}







