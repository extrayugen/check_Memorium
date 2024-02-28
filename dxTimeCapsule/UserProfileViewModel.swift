//
//  UserProfileViewModel.swift
//  dxTimeCapsule
//
//  Created by t2023-m0051 on 2/28/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

// MARK: - UserViewModel
class UserProfileViewModel {

    // Properties to hold the user data
    var uid: String?
    var email: String?
    var nickname: String?
    var profileImageUrl: String?

    // Initialization with default values
    init(uid: String? = nil, email: String? = nil, nickname: String? = nil, profileImageUrl: String? = nil) {
        self.uid = uid
        self.email = email
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }

    // Mock method to simulate fetching user data from Firestore
    func fetchUserData() {
        // This is where you would typically make your Firestore database call.
        // For demonstration purposes, we're just assigning some dummy data.
        self.uid = "123456"
        self.email = "pandaruss@example.com"
        self.nickname = "PANDA RUSS"
        self.profileImageUrl = "https://example.com/profile/pandaruss.jpg"
        
        // Notify the view controller that data has been updated, typically via a delegate or notification
        // For example:
        // delegate?.didReceiveUserData(self)
    }
}
