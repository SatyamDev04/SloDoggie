//
//  ViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import Foundation

class AboutUsViewModel: ObservableObject {
  @Published var aboutUsText: String = """
    Our app is designed to bring together pet lovers and pet service providers across San Luis Obispo County, California. Whether you're a devoted pet parent looking to connect with others, discover local events, or find trusted services like grooming, walking, or boarding — or a business looking to reach engaged pet owners — our platform is here to help. We believe in building a supportive, friendly, and informed pet community where users can share experiences, promote well-being, and celebrate the joy that pets bring into our lives.
    """
 }

class TermConditionViewModel: ObservableObject {
    @Published var termConditionText: String = """
    By using this app, you agree to engage respectfully and use it solely for its intended purpose: to connect with fellow pet enthusiasts, discover local pet service providers, share pet-related experiences, and explore pet-friendly events and activities.
    
    You are responsible for the accuracy and security of your account information. All content within the app — including text, images, and media — is owned by or licensed to the platform and may not be copied, modified, or distributed without written permission.
    
    You agree not to misuse the platform, post harmful or inappropriate content, or attempt to disrupt the app’s functionality or community experience.
    
    We are committed to protecting your privacy. Your personal information will never be sold or used outside the scope of providing and improving this app experience.
    
    Use of this app constitutes your acceptance of these Terms and any future updates. If you do not agree with any part of these Terms, please discontinue use of the app.
    
    For questions or concerns, contact us at support@petsloapp.com.
    """
}

class PrivacyPolicyViewModel: ObservableObject {
    @Published var privacyPolicyText: String = """
    We value your privacy and are committed to protecting your personal information. When you use our app, we may collect basic details such as your name, location, email, pet information, and activity within the app to provide a personalized experience and improve our services. Your information is never sold or shared with third parties without your consent, except as required by law or to ensure the safety and integrity of our platform. We use secure methods to store and manage your data and take reasonable steps to prevent unauthorized access. By using the app, you consent to the collection and use of your information as outlined in this policy. If you have any questions or concerns, please contact us at support@petsloapp.com.
    """
}
