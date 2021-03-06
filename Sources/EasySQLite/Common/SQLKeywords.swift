//
//  SQLKeywords.swift
//  iRevatureTrainingRoomMaintenanceScheduler
//
//  Created by Mark Hawkins on 2/13/20.
//  Copyright © 2020 revature. All rights reserved.
//

import Foundation

internal enum SQLiteKeyword: String {
    case CREATE
    case TABLE
    case INSERT
    case UPDATE
    case DELETE
    case INTO
    case WHERE
    case SET
    case VALUES
    case FROM
    case DROP
    case SELECT
    case AS
    case ON
}

internal enum SQLiteExpression: String {
    case LESSTHAN = "<"
    case GREATERTHAN = ">"
    case EQUALS = "="
    case LESSTHANEQUALS = "<="
    case GREATERTHANEQUALS = ">="
    case BETWEEN
    case IN
    case NOTIN = "NOT IN"
    case ISNULL = "IS NULL"
}

internal enum SQLiteClause: String {
    case AND
    case OR
    case NONE
}

internal enum SQLiteJoin: String {
    case INNER = "INNER JOIN"
    case OUTTER = "OUTTER JOIN"
    case CROSS = "CROSS JOIN"
}

internal enum SQLiteDataType: String {
    case INT
    case INTEGER
    case CHAR
    case BOOL
}

internal enum SQLiteConstraints: String {
    case PRIMARYKEY = "PRIMARY KEY"
    case NOTNULL = "NOT NULL"
    case UNIQUE
    case AUTOINCREMENT
}
