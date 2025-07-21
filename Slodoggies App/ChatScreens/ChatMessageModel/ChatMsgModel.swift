//
//  ChatMsgModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import Foundation
import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let userId: String
    let userName: String
    let avatar: String  // system image or URL
    let message: String
    let timestamp: Date
}
