//
//  APIManager.swift
//  Tradesman Tech
//  Created by YATIN  KALRA on 10/01/25.
//
//

import Combine
import Foundation
import Alamofire
import UIKit

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    // MARK: -  SendOtp API Call
    func sendOtp(email_Phone: String,apiType: String) -> AnyPublisher<BaseResponse<SendOtpDataModel>, Error> {
        let userType = UserDefaults.standard.string(forKey: "userType")
        let parameters: [String: Any] = [
            APIKeys.emailOrPhone: email_Phone,
            APIKeys.apiType: apiType,
            APIKeys.userType: userType ?? ""
        ]
        
        return APIServices<SendOtpDataModel>()
            .post(endpoint: .send_otp, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  UserRegister or VerifyOTP API Call
    func userRegisterAPi(fullName: String,emailOrPhone: String, password: String,fcm_token:String,userType: String, otp: String) -> AnyPublisher<BaseResponse<VerifyDataModel>, Error> {
        let parameters: [String: Any] = [
            APIKeys.fullName : fullName,
            APIKeys.emailOrPhone: emailOrPhone,
            APIKeys.password: password,
            APIKeys.fcm_token: fcm_token,
            APIKeys.userType: userType,
            APIKeys.deviceType: "ios",
            APIKeys.otp: otp
        ]
        
        return APIServices<VerifyDataModel>()
            .post(endpoint: .user_register, parameters: parameters)
            .eraseToAnyPublisher()
    }
    // MARK: - Login API Call
    func loginAPi(emailOrPhone: String, password: String,fcm_token:String) -> AnyPublisher<BaseResponse<VerifyDataModel>, Error> {
        let userType = UserDefaults.standard.string(forKey: "userType")
        let parameters: [String: Any] = [
            APIKeys.emailOrPhone: emailOrPhone,
            APIKeys.password: password,
            APIKeys.fcm_token: fcm_token,
            APIKeys.deviceType: "ios",
            APIKeys.userType: userType ?? ""
        ]
        
        return APIServices<VerifyDataModel>()
            .post(endpoint: .user_login, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  ForgotVerifyOTP API Call
    func ForgetOtpVerifyAPi(emailOrPhone: String, otp: String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
        let userType = UserDefaults.standard.string(forKey: "userType")
        let parameters: [String: Any] = [
            APIKeys.emailOrPhone: emailOrPhone,
            APIKeys.otp: otp,
            APIKeys.userType: userType ?? ""
        ]
        
        return APIServices<EmptyModel>()
            .post(endpoint: .verify_forgot_otp, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Reset Pass API Call
    func resetPasswordApi(email_Phone: String,password: String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
        let userType = UserDefaults.standard.string(forKey: "userType")
        let parameters: [String: Any] = [
            APIKeys.emailOrPhone: email_Phone,
            APIKeys.password: password,
            APIKeys.userType: userType ?? ""
        ]
        
        return APIServices<EmptyModel>()
            .post(endpoint: .reset_password, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    
    // MARK: -  SendEmailPhoneOtp API Call
    func sendEmailPhoneOtp(email_Phone: String) -> AnyPublisher<BaseResponse<SendOtpDataModel>, Error> {
        let userType = UserDefaults.standard.string(forKey: "userType")
        let parameters: [String: Any] = [
            APIKeys.emailOrPhone: email_Phone,
            APIKeys.user_id: UserDetail.shared.getUserId()
        ]
        
        return APIServices<SendOtpDataModel>()
            .post(endpoint: .send_email_phone_otp, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Verify Email Phone API Call
    func verifyEmailPhoneOtp(email_Phone: String,otp:String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
        let userType = UserDefaults.standard.string(forKey: "userType")
        let parameters: [String: Any] = [
            APIKeys.emailOrPhone: email_Phone,
            APIKeys.otp: otp,
            APIKeys.user_id: UserDetail.shared.getUserId()
        ]
        
        return APIServices<EmptyModel>()
            .post(endpoint: .verify_email_phone_otp, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  AddPetApi API Call
    func addPetApi(petName: String,petBreed: String,petAge:String,petBio:String,imgData:[String: Data],petId:String) -> AnyPublisher<BaseResponse<PetsDetailData>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
            APIKeys.pet_name: petName,
            APIKeys.pet_breed: petBreed,
            APIKeys.pet_age: petAge,
            APIKeys.pet_bio: petBio,
            APIKeys.pet_id: petId
        ]
        
        return APIServices<PetsDetailData>()
            .post(endpoint: .add_update_pet, parameters: parameters, images: imgData)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Your Detail API Call
    func getYourDetailApi() -> AnyPublisher<BaseResponse<OwnerDetails>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId()
        ]
        return APIServices<OwnerDetails>()
            .post(endpoint: .get_owner_details, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Add Your Detail Api API Call
    func AddYourDetailApi(name :String,email: String, phone: String,bio: String, imgData:[String: Data]) -> AnyPublisher<BaseResponse<OwnerDetails>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
            APIKeys.name: name,
            APIKeys.email: email,
            APIKeys.phone: phone,
            APIKeys.bio: bio
        ]
        return APIServices<OwnerDetails>()
            .post(endpoint: .update_owner_details, parameters: parameters,images: imgData)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Your Business Detail API Call
    func getYourBusinessDetailApi() -> AnyPublisher<BaseResponse<OwnerDetails>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId()
        ]
        return APIServices<OwnerDetails>()
            .post(endpoint: .get_business_details, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Add Business Detail Api API Call
    func AddBusinessApi(providerName:String,business_name :String,email: String, phone: String,LogoImg: [String: Data],business_category :String,business_address :String,city :String,state :String,zip_code :String,latitude :String,longitude :String,website_url :String,available_days:String,available_time:String, verification_docs:[UIImage]) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
        var imageDataArray: [UploadFileParameter] = []
        
        for (index, image) in verification_docs.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                let timestamp = Int(Date().timeIntervalSince1970)
                let fileName = "image_\(timestamp)_\(index).jpg"
                
                let fileParam = UploadFileParameter(
                    fileName: fileName,
                    key: APIKeys.verification_docs,
                    data: imageData,
                    mimeType: "image/jpeg",
                    id: ""
                )
                imageDataArray.append(fileParam)
            }
        }
        
        return APIServices<EmptyModel>()
            .uploadMultiData(para: ["user_id":UserDetail.shared.getUserId(),"provider_name":providerName,"business_name":business_name,"email":email,"contact_number":phone,"business_category":business_category,"business_address":business_address,"city":city,"state":state,"zip_code":zip_code,"latitude":latitude,"longitude":longitude,"website_url":website_url,"available_days":available_days,"available_time":available_time], images: LogoImg, imageData: imageDataArray, endpoint: .business_registration)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Add Service Api API Call
    func AddServiceApi(service_name :String,desc: String, price: String, imgs:[UIImage],serviceId:String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
        var imageDataArray: [UploadFileParameter] = []
        
        for (index, image) in imgs.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                let timestamp = Int(Date().timeIntervalSince1970)
                let fileName = "image_\(timestamp)_\(index).jpg"
                
                let fileParam = UploadFileParameter(
                    fileName: fileName,
                    key: APIKeys.images,
                    data: imageData,
                    mimeType: "image/jpeg",
                    id: "")
                imageDataArray.append(fileParam)
            }
        }
        
        return APIServices<EmptyModel>()
            .uploadMultiData(para: ["user_id":UserDetail.shared.getUserId(),"service_title":service_name,"description":desc,"price":price,"service_id":serviceId], imageData: imageDataArray, endpoint: .add_update_services)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Add Your Detail Api API Call
    func CreatePost(petID :String,imgs: [MediaTypes], postTitle: String,hashTags: String, address:String, lat:String, long:String,userType: String) -> AnyPublisher<BaseResponse<OwnerDetails>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
            APIKeys.pet_id: petID,
            APIKeys.post_title: postTitle,
            APIKeys.hash_tag: hashTags,
            APIKeys.address: address,
            APIKeys.latitude: lat,
            APIKeys.longitude: long,
            APIKeys.userType:userType
        ]
        
        var uploadArray: [UploadFileParameter] = []
        
        for (index, media) in imgs.enumerated() {
            
            let timestamp = Int(Date().timeIntervalSince1970)
            
            if let img = media.image,
               let imgData = img.jpegData(compressionQuality: 0.5) {
                let fileParam = UploadFileParameter(
                    fileName: "image_\(timestamp)_\(index).jpg",
                    key: APIKeys.images,         // SAME API KEY
                    data: imgData,
                    mimeType: "image/jpeg",
                    id: "")
                uploadArray.append(fileParam)
            }
            
            else if let videoURL = media.videoURL {
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    let fileParam = UploadFileParameter(
                        fileName: "video_\(timestamp)_\(index).mp4",
                        key: APIKeys.images,        // SAME KEY HERE ALSO
                        data: videoData,
                        mimeType: "video/mp4",
                        id: "")
                    uploadArray.append(fileParam)
                } catch {
                    print("⚠️ Error reading video file:", error)
                }
            }
        }
        print(uploadArray,"ImgUploaded")
        return APIServices<OwnerDetails>()
            .uploadMultiData(para: parameters, imageData: uploadArray, endpoint: .create_post)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Pet List API Call
    func getPetListApi() -> AnyPublisher<BaseResponse<[PetsDetailData]>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId()
        ]
        return APIServices<[PetsDetailData]>()
            .post(endpoint: .get_pet_lists, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Create Event API Call
    func CreateEvent(event_title :String,event_description: String,imgs: [MediaTypes], event_start_date: String,event_start_time: String, event_end_date:String, event_end_time:String, event_duration:String,address: String,city: String, state:String,zip_code:String, user_type: String, latitude: String, longitude: String) -> AnyPublisher<BaseResponse<OwnerDetails>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
            APIKeys.event_title: event_title,
            APIKeys.event_description: event_description,
            APIKeys.event_start_date: event_start_date,
            APIKeys.event_start_time: event_start_time,
            APIKeys.event_end_date: event_end_date,
            APIKeys.event_end_time: event_end_time,
            APIKeys.event_duration: event_duration,
            APIKeys.address: address,
            APIKeys.city: city,
            APIKeys.state: state,
            APIKeys.zip_code: zip_code,
            APIKeys.userType: user_type,
            APIKeys.latitude: latitude,
            APIKeys.longitude: longitude
        ]
        
        var uploadArray: [UploadFileParameter] = []
        
        for (index, media) in imgs.enumerated() {
            
            let timestamp = Int(Date().timeIntervalSince1970)
            
            // IMAGE
            if let img = media.image,
               let imgData = img.jpegData(compressionQuality: 0.5) {
                let fileParam = UploadFileParameter(
                    fileName: "image_\(timestamp)_\(index).jpg",
                    key: APIKeys.images,         // SAME API KEY
                    data: imgData,
                    mimeType: "image/jpeg",
                    id: "")
                uploadArray.append(fileParam)
            }
            // VIDEO
            else if let videoURL = media.videoURL {
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    let fileParam = UploadFileParameter(
                        fileName: "video_\(timestamp)_\(index).mp4",
                        key: APIKeys.images,        // SAME KEY HERE ALSO
                        data: videoData,
                        mimeType: "video/mp4",
                        id: "")
                    uploadArray.append(fileParam)
                } catch {
                    print("⚠️ Error reading video file:", error)
                }
            }
        }
        
        return APIServices<OwnerDetails>()
            .uploadMultiData(para: parameters, imageData: uploadArray, endpoint: .create_event)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get TNC API Call
    func getTnc() -> AnyPublisher<BaseResponse<PrivacyModel>, Error> {
        let parameters: [String: Any] = [:]
        return APIServices<PrivacyModel>()
            .get(endpoint: .term_and_condition, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get privacy policy API Call
    func getPrivacyPolicy() -> AnyPublisher<BaseResponse<PrivacyModel>, Error> {
        let parameters: [String: Any] = [:]
        return APIServices<PrivacyModel>()
            .get(endpoint: .privacy_policy, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get About us API Call
    func getAboutUs() -> AnyPublisher<BaseResponse<PrivacyModel>, Error> {
        let parameters: [String: Any] = [:]
        return APIServices<PrivacyModel>()
            .get(endpoint: .about_us, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get About us API Call
    func getHelpSupport() -> AnyPublisher<BaseResponse<PrivacyModel>, Error> {
        let parameters: [String: Any] = [:]
        return APIServices<PrivacyModel>()
            .get(endpoint: .help_support, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    
    // MARK: -  Get Followers List API Call
    func getFollowersListApi(id:String,page: String,search:String) -> AnyPublisher<BaseResponse<FollowersListResponse>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: id,
            APIKeys.page: page,
            APIKeys.search: search
        ]
        return APIServices<FollowersListResponse>()
            .post(endpoint: .get_followers, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Followers List API Call
    func getFollowingListApi(id:String,page: String,search:String) -> AnyPublisher<BaseResponse<FollowersListResponse>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: id,
            APIKeys.page: page,
            APIKeys.search: search
        ]
        return APIServices<FollowersListResponse>()
            .post(endpoint: .get_following, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Pet List API Call
    func getSavedAllListApi(page:String) -> AnyPublisher<BaseResponse<SavedPostsData>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
            APIKeys.page: page
        ]
        return APIServices<SavedPostsData>()
            .post(endpoint: .get_my_saved_posts, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Save Post List API Call
    func getSavedPostListApi(page:String) -> AnyPublisher<BaseResponse<SavedPostResponse>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
//            "limit": "20",
            APIKeys.page: page
        ]
        return APIServices<SavedPostResponse>()
            .post(endpoint: .get_my_saved_posts, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Owner Profile API Call
    func getOwnerProfileApi(UserId:String) -> AnyPublisher<BaseResponse<OwnerProfileDetail>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserId
        ]
        return APIServices<OwnerProfileDetail>()
            .post(endpoint: .get_owner_profile, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Owner Gallery API Call
    func getOwnerGallery(userID:String,page:String) -> AnyPublisher<BaseResponse<PostGalleryData>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: userID,
            APIKeys.page: page
        ]
        return APIServices<PostGalleryData>()
            .post(endpoint: .get_gallery, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Owner Events API Call
    func getDiscoverEvents(user_id:String,
                           page: Int,
                           search: String,
                           userType: String) -> AnyPublisher<BaseResponse<DiscoverEventsData>, Error> {
        
        let parameters: [String: Any] = [
            "user_id": UserDetail.shared.getUserId(),
            "search": search,
            "userType": userType,
            "page": page,
            "limit": 20
        ]
        
        return APIServices<DiscoverEventsData>()
            .post(endpoint: .discoverEvents, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Owner Pet Neaar You API Call
    func getPetNearYou(lat:String,
                       long:String,
                       search: String,
                       page: Int) -> AnyPublisher<BaseResponse<PetsNearYouData>, Error> {
        
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
            APIKeys.latitude: lat,
            APIKeys.longitude: long,
            "search": search,
            "page": page,
            "limit": 20
        ]
        
        return APIServices<PetsNearYouData>()
            .post(endpoint: .discoverPetNearMe, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Owner Activities API Call
    func getDiscoverActivities(id:String,
                           page: Int,
                           search: String) -> AnyPublisher<BaseResponse<ActivitiesData>, Error> {
        
        let parameters: [String: Any] = [
            "id": UserDetail.shared.getUserId(),
            "search": search,
            "page": page,
            "limit": 20
        ]
        
        return APIServices<ActivitiesData>()
            .post(endpoint: .discoverActivities, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Trending Hashtag API Call
    func getTrendingHashtag() -> AnyPublisher<BaseResponse<[TrendingHashtag]>, Error> {
        let parameters: [String: Any] = [:]
        return APIServices<[TrendingHashtag]>()
            .get(endpoint: .trendingHashtag, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Trending Hashtag API Call
    func getCategoryResponse() -> AnyPublisher<BaseResponse<[Category]>, Error> {
        let parameters: [String: Any] = [:]
        return APIServices<[Category]>()
            .get(endpoint: .getOwnerCategoryService, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Owner Activities API Call
    func getServiceProvider(id:String,
                           search: String) -> AnyPublisher<BaseResponse<[ServiceItem]>, Error> {
        
        let parameters: [String: Any] = [
            "user_id": UserDetail.shared.getUserId(),
            "search": search,
        ]
        
        return APIServices<[ServiceItem]>()
            .post(endpoint: .getOwnerServices, parameters: parameters)
            .eraseToAnyPublisher()
    }
        
    // MARK: -  Get Pet Places API Call
    func getPetPlaces(
        id: String,
        search: String,
        page: Int
    ) -> AnyPublisher<BaseResponse<PetPlacesData>, Error> {

        let parameters: [String: Any] = [
            "id": id,
            "search": search,
            "page": page,
            "limit": 20
        ]

        return APIServices<PetPlacesData>()
            .post(endpoint: .discoverPetPlaces, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get FAQ API Call
    func getFAQData() -> AnyPublisher<BaseResponse<[FAQItem]>, Error> {
        let parameters: [String: Any] = [:]
        return APIServices<[FAQItem]>()
            .get(endpoint: .faq, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Owner Activities API Call
    func getMyEventList(id:String,
                        page: Int,
                        type: String
                      ) -> AnyPublisher<BaseResponse<SavedEventPageData>, Error> {
        
        let parameters: [String: Any] = [
            "user_id": UserDetail.shared.getUserId(),
            "page": page,
            "limit": 20,
            "type": type
        ]
        
        return APIServices<SavedEventPageData>()
            .post(endpoint: .get_my_event_list, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  Get Your Detail API Call
        //Ravi Start
        func HomeDataApi(page:Int,limit:Int) -> AnyPublisher<BaseResponse<HomeModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id: UserDetail.shared.getUserId(),
                APIKeys.page: page,
                APIKeys.limit: limit
            ]
            return APIServices<HomeModel>()
                .post(endpoint: .homefeed, parameters: parameters)
                .eraseToAnyPublisher()
        }
   // Get mySavedPostApi
    func mySavedPostApi(page:Int,limit:Int) -> AnyPublisher<BaseResponse<HomeModel>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
            APIKeys.page: page,
            APIKeys.limit: limit
        ]
        return APIServices<HomeModel>()
            .post(endpoint: .get_my_saved_posts, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // Get myPostApi
    func myPostApi(userID:String,page:Int,limit:Int) -> AnyPublisher<BaseResponse<MyPostModel>, Error> {
         let parameters: [String: Any] = [
             APIKeys.user_id: userID,
             APIKeys.page: page,
             APIKeys.limit: limit
         ]
         return APIServices<MyPostModel>()
             .post(endpoint: .get_my_posts, parameters: parameters)
             .eraseToAnyPublisher()
     }
        
        //GetCommentApi
        func getCommentApi(postID: String, page:Int,limit:Int) -> AnyPublisher<BaseResponse<CommentModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id: UserDetail.shared.getUserId(),
                APIKeys.page: page,
                APIKeys.limit: limit,
                APIKeys.postid: postID
            ]
            return APIServices<CommentModel>()
                .post(endpoint: .getcomments, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
        // MARK: -  Get Follow/UnfollowApi
        func FollowUnfollowApi(followerID:String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id: UserDetail.shared.getUserId(),
                APIKeys.followedid: followerID
               
            ]
            return APIServices<EmptyModel>()
                .post(endpoint: .addremovefollower, parameters: parameters)
                .eraseToAnyPublisher()
        }
    // MARK: - RepotPOSTAPI
    
    func repostPostApi(userid: String,postId: String, report_reason: String,text:String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: userid,
            APIKeys.postid: postId,
            APIKeys.reportreason: report_reason,
            APIKeys.text: text
           
        ]
        return APIServices<EmptyModel>()
            .post(endpoint: .reportpost, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
        
        // MARK: -  addReplyApi
        func addReplyCommentApi(commentTxt:String,commentId:String,postID:String, ) -> AnyPublisher<BaseResponse<CommentReply>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id: UserDetail.shared.getUserId(),
                APIKeys.postid: postID,
                APIKeys.commentid: commentId,
                APIKeys.commenttxt: commentTxt
            ]
            return APIServices<CommentReply>()
                .post(endpoint: .replycomment, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
        
        
        // MARK: -  likeUnlikeCommentApi
        func likeUnlikeCommentApi(commentId:String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id: UserDetail.shared.getUserId(),
                APIKeys.commentid: commentId
               
            ]
            return APIServices<EmptyModel>()
                .post(endpoint: .commentlike, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
        
        // MARK: -  deleteCommentApi
        func deleteCommentApi(commentId:String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id: UserDetail.shared.getUserId(),
                APIKeys.commentid: commentId
               
            ]
            return APIServices<EmptyModel>()
                .post(endpoint: .deletecomment, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
        
        
        
        // MARK: -   addCommentApi
        func  addCommentApi(postid:String, commenttxt: String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id: UserDetail.shared.getUserId(),
                APIKeys.postid: postid,
                APIKeys.commenttxt : commenttxt
               
            ]
            return APIServices<EmptyModel>()
                .post(endpoint: .addnewcomment, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
        // MARK: -   addCommentApi
        func  editCommentApi(commentid:String, commenttxt: String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id: UserDetail.shared.getUserId(),
                APIKeys.commentid: commentid,
                APIKeys.commenttxt : commenttxt
               
            ]
            return APIServices<EmptyModel>()
                .post(endpoint: .editcomment, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
       
        // MARK: -  Get SaveUnsaveApi
        func SaveUnsaveApi(postId:String, postType:String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            var parameters: [String: Any] = [:]
            
            if postType == "Activity"{
                 parameters = [
                    APIKeys.user_id: UserDetail.shared.getUserId(),
                    APIKeys.postid: postId
                ]
            }
            
            if postType == "Post"{
                 parameters = [
                    APIKeys.user_id: UserDetail.shared.getUserId(),
                    APIKeys.postid: postId
                ]
            }
            
            if postType == "Event"{
                 parameters = [
                    APIKeys.user_id: UserDetail.shared.getUserId(),
                    APIKeys.eventid: postId
                ]
            }
           
            return APIServices<EmptyModel>()
                .post(endpoint: .savepost, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
        // MARK: -  Get Like/UnlikeApi
        func LikeUnlikeApi(postId:String, postType:String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            var parameters: [String: Any] = [:]
            
            if postType == "Post"{
                 parameters = [
                    APIKeys.user_id: UserDetail.shared.getUserId(),
                    APIKeys.postid: postId
                ]
            }
            
            if postType == "Event"{
                 parameters = [
                    APIKeys.user_id: UserDetail.shared.getUserId(),
                    APIKeys.eventid: postId
                ]
            }
            if postType == "Sponsor"{
                 parameters = [
                    APIKeys.user_id: UserDetail.shared.getUserId(),
                    APIKeys.addid: postId
                ]
            }
           
            return APIServices<EmptyModel>()
                .post(endpoint: .likeunlike, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
    // MARK: -  getBussinessProfile API Call
    func getBussinessProfile(userID:String) -> AnyPublisher<BaseResponse<BusiUser>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id :userID
            ]
            
            return APIServices<BusiUser>()
                .post(endpoint: .getbusinessprofile, parameters: parameters)
                .eraseToAnyPublisher()
        }
        
        // MARK: -  BussinessGalleryItem API Call
    func getGalleryItemApi(userID:String,page: Int, limit: Int) -> AnyPublisher<BaseResponse<GalleyResponse>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id : userID,
                APIKeys.page : page,
                APIKeys.limit : limit
                
            ]
            
            return APIServices<GalleyResponse>()
                .post(endpoint: .get_gallery, parameters: parameters)
                .eraseToAnyPublisher()
        }
            
        // MARK: -  getBussinessProfile API Call
        func removeFollowerFollowingApi(followedid: String, types: String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id : UserDetail.shared.getUserId(),
                APIKeys.followedid : followedid,
                APIKeys.typess  : types
                
            ]
            
            return APIServices<EmptyModel>()
                .post(endpoint: .removeFollowerFollowing, parameters: parameters)
                .eraseToAnyPublisher()
        }
    
    
    // MARK: -  removePost API Call
    func removePostApi(postID: String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id : UserDetail.shared.getUserId(),
            APIKeys.postid : postID
        ]
        
        return APIServices<EmptyModel>()
            .post(endpoint: .deletePost, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  removePost API Call
    func editPostApi(postID: String, text: String) -> AnyPublisher<BaseResponse<EditPostModel>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id : UserDetail.shared.getUserId(),
            APIKeys.postid : postID,
            APIKeys.postdescription : text
        ]
        
        return APIServices<EditPostModel>()
            .post(endpoint: .editpost, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    
    // MARK: -  getBussinessServiceDetails API Call
    func getBussinessServiceDetails(businessID: Int?) -> AnyPublisher<BaseResponse<BusinessServiceModel>, Error> {
            var parameters: [String: Any] = [:]
            if UserDefaults.standard.string(forKey: "userType") == "Owner"{
                parameters = [
                    APIKeys.businessuserid : businessID ?? 0
                ]
            }else{
                parameters = [
                    APIKeys.businessuserid : UserDetail.shared.getUserId()
                ]
            }
            return APIServices<BusinessServiceModel>()
                .post(endpoint: .ServiceDetail, parameters: parameters)
                .eraseToAnyPublisher()
        }
    
    // MARK: -  getBussinessServiceDetails API Call
        func getBussinessServiceDetails() -> AnyPublisher<BaseResponse<BusinessServiceModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.businessuserid : UserDetail.shared.getUserId()
            ]
            
            return APIServices<BusinessServiceModel>()
                .post(endpoint: .ServiceDetail, parameters: parameters)
                .eraseToAnyPublisher()
        }
    
        // Ravi End
    func CreateAds(adsData: adsDataModel) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId(),
            APIKeys.adTitle: adsData.adTitle ?? "",
            APIKeys.adDescription: adsData.adDescription ?? "",
            APIKeys.category: adsData.category ?? [],
            APIKeys.service: adsData.service ?? "",
            APIKeys.expiry_date: adsData.expiryDate ?? "",
            APIKeys.expiry_time: adsData.expiryTime ?? "",
            APIKeys.termAndConditions: adsData.tNc ?? "",
            APIKeys.lat: adsData.latitude ?? "",
            APIKeys.long: adsData.longitude ?? "",
            APIKeys.serviceLocation: adsData.address ?? "",
            APIKeys.contactNumber: adsData.contactInfo ?? "",
            APIKeys.mobile_visual: adsData.contactShowStatus ?? 0,
            APIKeys.budget: adsData.budget ?? ""
        ]
        
        var uploadArray: [UploadFileParameter] = []
        
        for (index, media) in (adsData.media ?? []).enumerated() {
            
            let timestamp = Int(Date().timeIntervalSince1970)
            
            if let img = media.image,
               let imgData = img.jpegData(compressionQuality: 0.5) {
                let fileParam = UploadFileParameter(
                    fileName: "image_\(timestamp)_\(index).jpg",
                    key: APIKeys.images,         // SAME API KEY
                    data: imgData,
                    mimeType: "image/jpeg",
                    id: "")
                uploadArray.append(fileParam)
            }
            
            else if let videoURL = media.videoURL {
                do {
                    let videoData = try Data(contentsOf: videoURL)
                    let fileParam = UploadFileParameter(
                        fileName: "video_\(timestamp)_\(index).mp4",
                        key: APIKeys.images,        // SAME KEY HERE ALSO
                        data: videoData,
                        mimeType: "video/mp4",
                        id: "")
                    uploadArray.append(fileParam)
                } catch {
                    print("⚠️ Error reading video file:", error)
                }
            }
        }
        print(uploadArray,"ImgUploaded")
        return APIServices<EmptyModel>()
            .uploadMultiData(para: parameters, imageData: uploadArray, endpoint: .create_ads)
            .eraseToAnyPublisher()
    }
    
    func GetService() -> AnyPublisher<BaseResponse<[ServiceListModel]>, Error> {
        let parameters: [String: Any] = [
            APIKeys.user_id: UserDetail.shared.getUserId()
        ]
        
        return APIServices<[ServiceListModel]>()
            .post(endpoint: .get_service_list, parameters: parameters)
            .eraseToAnyPublisher()
    }
    
    // MARK: -  getBussinessServiceDetails API Call
    func deleteBusinessService(serviceid: String) -> AnyPublisher<BaseResponse<EmptyModel>, Error> {
            let parameters: [String: Any] = [
                APIKeys.user_id : UserDetail.shared.getUserId(),
                APIKeys.serviceid :serviceid
                
            ]
            
            return APIServices<EmptyModel>()
                .post(endpoint: .delete_service, parameters: parameters)
                .eraseToAnyPublisher()
        }
    
    
}

