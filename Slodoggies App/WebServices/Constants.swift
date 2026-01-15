//
//  Constant.swift
//  My Meeting Card
//
//  Created by pranjali kashyap on 04/03/22.
//


import UIKit

class UserDetail: NSObject {
    
static let shared = UserDetail()
    private override init() { }
    
    func setUserId(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.userid.rawValue)
        print(sUserId)
    }
    
    func setProfileImg(_ sProfileImg:String) -> Void {
        UserDefaults.standard.set(sProfileImg, forKey: UserKeys.profileImg.rawValue)
        print(sProfileImg)
    }
    
    func setNewNotification(_ sNewNotification:Bool) -> Void {
        UserDefaults.standard.set(sNewNotification, forKey: UserKeys.newNotification.rawValue)
        print(sNewNotification)
    }
    
    func getUserId() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.userid.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func getNewNotification() -> Bool {
        if let newNotification = UserDefaults.standard.value(forKey: UserKeys.newNotification.rawValue) as? Bool
        {
            return newNotification
        }
        return false
    }
    
    func getProfileImg() -> String {
        if let profileImg = UserDefaults.standard.value(forKey: UserKeys.profileImg.rawValue) as? String
        {
            return profileImg
        }
        return ""
    }
    
    func setSessntId(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.sessnid.rawValue)
        print(sUserId)
    }
    func getSessntId() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.sessnid.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    func setAddress(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.address.rawValue)
        print(sUserId)
    }
    func getAddress() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.address.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    func removeAddress() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.address.rawValue)
    }
    func removeProfileImg() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.profileImg.rawValue)
    }
    func setFcmToken(_ sFCMToken:String) -> Void {
        UserDefaults.standard.set(sFCMToken, forKey: UserKeys.fcmtoken.rawValue)
        print(sFCMToken)
    }
    func getFcmToken() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.fcmtoken.rawValue) as? String
        {
            return userId
        }
        return ""
    }

    func setlatitude(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.latitude.rawValue)
        print(sUserId)
    }
    func getlatitude() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.latitude.rawValue) as? String
        {
            return userId
        }
        return "28.63301499841065"
    }
    func removelatitude() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.latitude.rawValue)
    }
    func removeFcmToken() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.fcmtoken.rawValue)
    }
    func setlongitude(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.longitude.rawValue)
        print(sUserId)
    }
    func getlongitude() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.longitude.rawValue) as? String
        {
            return userId
        }
        return "77.431347448171"
    }
    func removelongitude() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.longitude.rawValue)
    }
    
    func setFistLogin(_ sFirstLogin:Bool) -> Void {
        UserDefaults.standard.set(sFirstLogin, forKey: UserKeys.FistLogin.rawValue)
        print(sFirstLogin)
    }
    func getFistLogin() -> Bool {
        if let FistLogin = UserDefaults.standard.value(forKey: UserKeys.FistLogin.rawValue) as? Bool
        {
            return FistLogin
        }
        return false
    }
    func removeFistLogin() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.FistLogin.rawValue)
    }
    
    
    func setScreenId(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.screenid.rawValue)
        print(sUserId)
    }
    func getScreenId() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.screenid.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeUserId() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.userid.rawValue)
    }
    //
    
    func setUserType(_ sUserType:String) -> Void {
        UserDefaults.standard.set(sUserType, forKey: UserKeys.UserType.rawValue)
        print(sUserType)
    }
    func getUserType() -> String {
        if let UserType = UserDefaults.standard.value(forKey: UserKeys.UserType.rawValue) as? String
        {
            return UserType
        }
        return ""
    }
    func removeUserType() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.UserType.rawValue)
    }
    
    func setLocationStatus(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.LocationStatus.rawValue)
        print(sUserId)
    }
    func getLocationStatus() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.LocationStatus.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func setNotiStatus(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.NotiStatus.rawValue)
        print(sUserId)
    }
    func getNotiStatus() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.NotiStatus.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeLocationStatus() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.LocationStatus.rawValue)
    }
    //
    
    
    //
    
        func setName(_ sName: String) -> Void {
            UserDefaults.standard.set(sName, forKey: UserKeys.name.rawValue)
        }
        
        func getName() -> String{
            if let name = UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as? String
            {
                return name
            }
            return ""
        }
    
    func removeName() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.name.rawValue)
    }
       
        
        func setEmailId(_ email: String) -> Void{
            UserDefaults.standard.set(email, forKey: UserKeys.emailId.rawValue)
        }
        
        func getEmailId() -> String{
            if let emailId = UserDefaults.standard.value(forKey: UserKeys.emailId.rawValue) as? String
            {
                return emailId
            }
            return ""
        }
    
    func removeEmailId() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.emailId.rawValue)
    }
    func setCountryCode(_ code: String) -> Void{
        UserDefaults.standard.set(code, forKey: UserKeys.countryCode.rawValue)
    }
    
    func getCountryCode() -> String{
        if let code = UserDefaults.standard.value(forKey: UserKeys.countryCode.rawValue) as? String
        {
           return code
        }
        return ""
    }
    
    func removeCountryCode() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.countryCode.rawValue)
    }
    
        func setphoneNo(_ phone: String) -> Void{
            UserDefaults.standard.set(phone, forKey: UserKeys.phoneNo.rawValue)
        }
        
        func getPhoneNo() -> String{
            if let phoneNo = UserDefaults.standard.value(forKey: UserKeys.phoneNo.rawValue) as? String
            {
               return phoneNo
            }
            return ""
        }
    
    func removePhoneNo() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.phoneNo.rawValue)
    }
    
    //
    func setTokenWith(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.Token.rawValue)
        print(sUserId)
    }
    func getTokenWith() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.Token.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeTokenWith() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.Token.rawValue)
    }
    
    //
  
}

enum UserKeys:String {
    case userid = "user_id"
    case sessnid = "sessnid"
    case screenid = "screenid"
    case UserType = "UserType"
    case name = "name"
    case emailId = "emailId"
    case countryCode = "countryCode"
    case phoneNo = "phoneNo"
    case Token = "Token"
    case LocationStatus = "LocationStatus"
    case NotiStatus = "NotiStatus"
    
    case address = "address"
    
    case latitude = "latitude"
    case fcmtoken = "fcmtoken"
    
    case longitude = "longitude"
    case profileImg = "profileImg"
    case newNotification = "NewNotification"
    case FistLogin = "FistLogin"
}
 
