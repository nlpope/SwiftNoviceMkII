//  File: SNError+Utils.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/28/25.

import Foundation

enum SNError: String, Error
{
    case badURL = "Invalid URL, please try again."
    case badResponse = "Failed to get a valid response from the server. Please try again."
    case badData = "There was an issue with the data given by the response. Please try again."
    case errorDecodingData = "There was an issue decoding your data."
    
    case failedToSaveProgress = "We failed to save your progress. Please try toggling the completion slider again."
    case failedToLoadProgress = "We failed to retrieve your progress. Please try signing out and signing in again."
}
