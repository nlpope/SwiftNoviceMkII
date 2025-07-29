//  File: SNError+Utils.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/28/25.

import Foundation

enum SNError: String, Error
{
    case invalidURL = "Failed to get a response from the server. Please try again."
    case invalidResponse = "Failed to get a valid response from the server. Please try again."
    case invalidData = "The data retrieved was invalid."
    
    case failedToSaveProgress = "We failed to save your progress. Please try toggling the completion slider again."
    case failedToLoadProgress = "We failed to retrieve your progress. Please try signing out and signing in again."
}
