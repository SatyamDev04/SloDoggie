//
//  EndPoints.swift
//  RPG
//
//  Created by YATIN  KALRA on 12/02/24.
//

import Foundation

extension Notification.Name {
    static let locationDidUpdate = Notification.Name("locationDidUpdate")
}

struct AppKeys {
    static let  googleAPi = "AIzaSyC9NuN_f-wESHh3kihTvpbvdrmKlTQurxw"
    static let googleMapAPI = "AIzaSyBh1m5LWl-qV1nVkT1WZeWAzng5eP42RNk"
}
struct AppLocation {
    static var  lat = ""
    static var  long = ""
    static var  Address = ""
    static var  city = ""
    static var  state = ""
    static var  zip = ""
}
struct AppURL {
    static let baseURL = "https://slodoggies.tgastaging.com/api/"
    static let imageURL = "https://slodoggies.tgastaging.com"
}

extension AppURL {
    enum Endpoint: String {
        case send_otp        = "send_otp"
        case user_register   = "user_register"
        case user_login      = "user_login"
        case verify_forgot_otp = "verify_forgot_otp"
        case reset_password  = "reset_password"
        case send_email_phone_otp = "send_email_phone_otp"
        case verify_email_phone_otp = "verify_email_phone_otp"
        case add_update_pet        = "add_update_pet"
        case get_owner_details = "get_owner_details"
        case update_owner_details = "update_owner_details"
        case get_business_details = "get_business_details"
        case business_registration = "business_registration"
        case add_update_services = "add_update_services"
        case create_post        = "create_post"
        case get_pet_lists      = "get_pet_lists"
        case create_event       = "create_event"
        case term_and_condition = "term_and_condition"
        case privacy_policy     = "privacy_policy"
        case help_support       = "help_support"
        case about_us           = "about_us"
        case get_followers      = "get_followers"
        case get_following      = "get_following"
        case get_my_saved_posts = "get_my_saved_posts"
        case get_my_posts        = "get_my_posts"
        case get_owner_profile  = "get_owner_profile"
        case get_gallery        = "get_gallery"
        case discoverEvents     = "discoverEvents"
        case discoverPetNearMe  = "discoverPetNearMe"
        case discoverActivities = "discoverActivities"
        case trendingHashtag    = "trendingHashtag"
        case getOwnerCategoryService = "getOwnerCategoryService"
        case getOwnerServices   = "getOwnerServices"
        case discoverPetPlaces  = "discoverPetPlaces"
        case faq                = "faq"
        case get_my_event_list  = "get_my_event_list"
        
  
        case homefeed   = "home_feed"
        
        case addremovefollower   = "add_remove_follower"
        
        case likeunlike   = "like_unlike"
        
        case savepost   = "save_post"
        
        case getcomments   = "get_comments"
        
        case commentlike   = "comment_like"
        
        case addnewcomment   = "add_new_comment"
        
        case deletecomment   = "delete_comment"
        
        case replycomment   = "reply_comment"
        
        case editcomment   = "edit_comment"
        case getbusinessprofile = "get_business_profile"
        
        case removeFollowerFollowing = "removeFollowerFollowing"
        
        case get_service_list  = "get_service_list"
        
        case create_ads        = "create_ads"
        
        //Ravi
              
        case deletePost        = "deletePost"
        
        case editpost        = "edit_post"
        
        case ServiceDetail        = "ownerServiceDetail"
        
     
        case delete_service        = "delete_service"
        
        
          case reportpost        = "report_post"
        
        
        
        var path: String {
            let url = AppURL.baseURL
            return url + self.rawValue
        }
    }
}
  
extension String{
func imgFullPath() -> String{
    return "\(AppURL.imageURL)\(self)"
    }
}
