//  File: SNError+Utils.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/28/25.

import Foundation

//enum ErrorTypes
//{
//    case mismatchedPassword, emptyPwdField, emptyCPwdField, blankPwdPostSet, incorrectPassword, noBiometry, authFail
//}

enum SNError: String, Error
{
    //-------------------------------------//
    // MARK: - LOGIN ERROR MESSAGES
    
    case mismatchOnCreation     = "Your password and confirmed password do not match"
    case emptyPwdOnCreation     = "Set your password to continue"
    case emptyCPwdOnCreation    = "Confirm your password to continue"
    case incorrectPostCreation  = "The password entered is incorrect"
    case blankPwdPostSet        = "Enter your password to continue"
    
    case noBiometry             = "Your device is not configured for biometric authentication"
    case authFail               = "You could not be verified; please try again."
    
    //-------------------------------------//
    // MARK: - DATA SAVING & FETCHING ERROR MESSAGES
    
    case failedToSaveUser = "Failed to save this new user. Please try signing up again."
    case failedToLoadUser = "Failed to find this user. Please try signing in again."
    
    case badURL = "Invalid URL, please try again."
    case badResponse = "Failed to get a valid response from the server. Please try again."
    case badData = "There was an issue with the data given by the response. Please try again."
    case errorDecodingData = "There was an issue decoding your data."
    
    case failedToSaveProgress = "We failed to save your progress. Please try toggling the completion slider again."
    case failedToLoadProgress = "We failed to retrieve your progress. Please try signing out and signing in again."
}
