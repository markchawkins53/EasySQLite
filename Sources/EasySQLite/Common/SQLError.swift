//
//  SQLError.swift
//  iRevatureTrainingRoomMaintenanceScheduler
//
//  Created by Mark Hawkins on 2/13/20.
//  Copyright © 2020 revature. All rights reserved.
//

import SQLite3

//Used for throwing errors
internal enum SQLiteError: Error {
    case OpenDatabase(message: String)
    
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
    
    case Create(message: String)
    case Insert(message: String)
    case Update(message: String)
    case Delete(message: String)
    case Query(message: String)
    case Drop(message: String)
    case Truncate(message: String)
    
    case DataType(message: String)
}

internal struct SQLiteErrorMessage {
    static let InsertStatement = "Unable to produce Insert Statement"
    static let UpdateStatement = "Unable to produce Update Statement"
    static let DeleteStatement = "Unable to produce Delete Statement"
    
    static func CreateTableStatement(tableName: String) -> String {
        return String(format: "Unable to produce Create %s Statement" , tableName)
    }
    
    static func DropTable(tableName: String) -> String {
        return String(format: "Failed to drop %s table", tableName)
    }
    
    static let Query = "Unable to perform query with Select Statement"
    static let QueryTable = "Unable to access stored table during query"
    static let QueryValues = "No values returned from query"
}
