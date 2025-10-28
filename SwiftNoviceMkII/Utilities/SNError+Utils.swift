//  File: SNError+Utils.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 7/28/25.

import Foundation

enum SNError: String, Error
{
    //-------------------------------------//
    // MARK: - LOGIN ERROR MESSAGES
    

    case pwdAndCpwdMismatch = "Your password and confirmed password do not match"

    case emptyFields = "One or more fields have been left blank."
    
    case wrongUsernameOrPwd = "The username or password is incorrect. Please try again or sign up if you do not have an account"
    
    case noBiometry = "Your device is not configured for biometric authentication"
    
    case authFail = "You could not be verified; please try again."
    
    //-------------------------------------//
    // MARK: - DATA SAVING & FETCHING ERROR MESSAGES
    
    case failedToSaveUser = "Failed to save this new user. Please try signing up again."
    
    case failedToLoadUser = "Failed to find this user. Please try signing in again."
    
    case failedToLoadExistingUsers = "Failed to find a set of existing users on this device."
    
    case badURL = "Invalid URL, please try again."
    
    case badResponse = "Failed to get a valid response from the server. Please try again."
    
    case badData = "There was an issue with the data given by the response. Please try again."
    
    case errorDecodingData = "There was an issue decoding your data."
    
    case failedToSaveProgress = "We failed to save your progress. Please try toggling the completion slider again."
    
    case failedToLoadProgress = "We failed to retrieve your progress. Please try signing out and signing in again."
}
