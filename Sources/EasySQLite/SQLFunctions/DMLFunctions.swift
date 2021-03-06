//
//  DDMFunctions.swift
//  iRevatureTrainingRoomMaintenanceScheduler
//
//  Created by Mark Hawkins on 2/13/20.
//  Copyright © 2020 revature. All rights reserved.
//

import SQLite3

extension DatabaseAccess {
//===============================================================================================
    //Insert into table
//===============================================================================================
    func insertRow (statement: InsertStatement) throws {
        //Prepare the SQL statement
        guard let statement = statement.makeStatement() else {
            throw SQLiteError.Insert(message: SQLiteErrorMessage.InsertStatement)
        }

        let insertStatement = try prepareStatement(sqlStatement: statement, statementType: .prepare_v2)

        //Run after function finished to destroy statement
        defer {
            sqlite3_finalize(insertStatement)
        }

        //Run the SQL statement
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Insert(message: String(cString: sqlite3_errmsg(insertStatement)))
        }
    }

//===============================================================================================
    //Update Table Row
//===============================================================================================
    func updateRow(statement: UpdateStatement) throws {
        //Prepare the SQL statement
        guard let statement = statement.makeStatement() else {
            throw SQLiteError.Update(message: SQLiteErrorMessage.UpdateStatement)
        }
        
        let updateStatement = try prepareStatement(sqlStatement: statement, statementType: .prepare_v2)

        //Call after function to destroy statement
        defer {
            sqlite3_finalize(updateStatement)
        }

        //Run the SQL statement
        guard sqlite3_step(updateStatement) == SQLITE_DONE else {
            throw SQLiteError.Update(message: String(cString: sqlite3_errmsg(updateStatement)))
        }
    }

//===============================================================================================
    //Delete Row From Table
//===============================================================================================
    func deleteRow(statement: DeleteStatement) throws {
        
        //Prepare the SQL statement
        guard let statement = statement.makeStatement() else {
            throw SQLiteError.Delete(message: SQLiteErrorMessage.DeleteStatement)
        }

        let deleteStatement = try prepareStatement(sqlStatement: statement, statementType: .prepare_v2)

        //Call after function to destroy statement
        defer {
            sqlite3_finalize(deleteStatement)
        }

        //Run the SQL statement
        guard sqlite3_step(deleteStatement) == SQLITE_DONE else {
            throw SQLiteError.Update(message: String(cString: sqlite3_errmsg(deleteStatement)))
        }
    }
}
