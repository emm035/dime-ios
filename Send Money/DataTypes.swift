//
//  RLMObject.swift
//  College Expense Reporter
//
//  Created by Eric Marshall on 5/31/15.
//  Copyright (c) 2015 Eric Marshall. All rights reserved.
//

import Foundation
import RealmSwift

/// Object for saving Reports to a Realm
class Report: Object {
    /// The Report's Title
    dynamic var name = ""
    /// The Report's Status (Open, Submitted, Paid)
    dynamic var status = ReportStatus.open.rawValue
    /// The Report's Unique ID
    dynamic var id = UUID().uuidString
    /// The Date at which the report was paid, for finding when it should be deleted
    dynamic var deleteDateAndTime = Date()

    /**
    Gets the id of the Report, for use in checking that two expenses are identical

    - Returns: String?
    */
    override static func primaryKey() -> String? {
        return "id"
    }
}

/// Object for saving Expenses to a Realm
class Expense: Object {
    /// The Expense's Unique ID
    dynamic var id = UUID().uuidString
    /// The Expense's Report's Unique ID
    dynamic var reportID = ""
    /// The Expense's Vendor
    dynamic var vendor = ""
    /// The Expense's Cost
    dynamic var cost = ""
    /// The Expense's Date
    dynamic var date = ""
    /// Details contained in the Expense
    dynamic var details = ""
    /// NSData representation of the data for the Expense's image
    dynamic var imageData = Data()
    /// Whether or not the Expense contains an image
    dynamic var imageIsDefault = true
    /// The Expense's category type
    dynamic var category = ExpenseCategory.none.rawValue

    /**
    Gets the id of the Expense, for use in checking that two expenses are identical

    - Returns: String?
    */
    override static func primaryKey() -> String? {
        return "id"
    }
}


// ALL COMPARISONS ARE DONE USING THE ID -- THE ITEMS WILL BE UNIQUE


/**
Returns a boolean comparison of whether or not two Expenses are the same

- Returns: Bool
*/
func ==(lhs: Expense, rhs: Expense) -> Bool {
    return lhs.id == rhs.id
}

/**
Returns a boolean comparison of whether or not two Expenses are not the same

- Returns: Bool
*/
func !=(lhs: Expense, rhs: Expense) -> Bool {
    return lhs.id != rhs.id
}

/**
Returns a boolean comparison of whether or not two Reports are the same

- Returns: Bool
*/
func ==(lhs: Report, rhs: Report) -> Bool {
    return lhs.id == rhs.id
}

/**
Returns a boolean comparison of whether or not two Expenses are not the same

- Returns: Bool
*/
func !=(lhs: Report, rhs: Report) -> Bool {
    return lhs.id != rhs.id
}

/// Object for holding the app's Settings
class Settings: Object {
    /// The default selected value for when to delete paid reports
    dynamic var deleteIntervalRow = 6
    /// A list of the default recipients for submitting reports
    var emailList = List<EmailString>()
    /// Whether or not the tutorial should be shown on opening the app
    dynamic var showTutorial = true
}

/// A wrapper class for strings, allowing for containment in Realm Lists
class EmailString: Object, Comparable {
    dynamic var string = ""

    convenience init(string: String) {
        self.init()
        self.string = string
    }
}

func <(lhs: EmailString, rhs: EmailString) -> Bool {
    return lhs.string < rhs.string
}

func >(lhs: EmailString, rhs: EmailString) -> Bool {
    return lhs.string > rhs.string
}

func >=(lhs: EmailString, rhs: EmailString) -> Bool {
    return lhs.string >= rhs.string
}

func <=(lhs: EmailString, rhs: EmailString) -> Bool {
    return lhs.string <= rhs.string
}

func ==(lhs: EmailString, rhs: EmailString) -> Bool {
    return lhs.string == rhs.string
}

func !=(lhs: EmailString, rhs: EmailString) -> Bool {
    return lhs.string != rhs.string
}

/// Enum for evaluating the status of a report
enum ReportStatus: Int {
    case open = 0
    case submitted = 1
    case paid = 2
}

enum ExpenseCategory: Int {
    case none = 0
    case transportation = 1
    case lodging = 2
    case entertainment = 3
    case fuel = 4
    case food = 5
    case other = 6
}
