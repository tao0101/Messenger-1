//
//  AddFriendNetworking.swift
//  mChat
//
//  Created by Vitaliy Paliy on 2/4/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Firebase

class AddFriendNetworking {
    
    var friend: FriendInfo!
    var controller: AddFriendVC!
    
    func addAsFriend() {
        let ref = Database.database().reference().child("friendsList").child("friendRequests").child(friend.id).child(CurrentUser.uid).child(CurrentUser.uid)
        ref.setValue(CurrentUser.uid)
    }
    
    func removeFriend() {
        let userRef = Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id).child(self.friend.id)
        let friendRef = Database.database().reference().child("friendsList").child(self.friend.id).child(CurrentUser.uid).child(CurrentUser.uid)
        userRef.removeValue()
        friendRef.removeValue()
    }
    
    func checkFriend(){
        checkForFriendRequest {
            self.checkFriendship()
        }
    }
    
    func removeFriendRequest() {
        Database.database().reference().child("friendsList").child("friendRequests").child(friend.id).child(CurrentUser.uid).child(CurrentUser.uid).removeValue()
    }
    
    func checkFriendship() {
        Database.database().reference().child("friendsList").child(CurrentUser.uid).child(friend.id).observe(.value) { (snapshot) in
            self.controller.addButton.isEnabled = true
            guard let values = snapshot.value as? [String: Any] else {
                self.controller.addButton.setTitle("Add Friend", for: .normal)
                self.controller.addButton.backgroundColor = .green
                return
            }
            let f = values
            if f[self.friend.id] as? Bool != nil && f[self.friend.id] as? Bool == true {
                self.controller.addButton.backgroundColor = .red
                self.controller.addButton.setTitle("Remove Friend", for: .normal)
            }
        }
    }
    
    func checkForFriendRequest(completion: @escaping () -> Void) {
        Database.database().reference().child("friendsList").child("friendRequests").child(friend.id).child(CurrentUser.uid).observeSingleEvent(of: .value) { (snap) in
            guard let _ = snap.value as? [String: Any] else { return completion() }
            self.controller.addButton.setTitle("Requested", for: .normal)
            self.controller.addButton.isEnabled = true
            self.controller.addButton.backgroundColor = .gray
        }
    }
    
}