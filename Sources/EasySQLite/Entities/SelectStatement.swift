//
//  SelectStatement.swift
//  iRevatureTrainingRoomMaintenanceScheduler
//
//  Created by Mark Hawkins on 2/20/20.
//  Copyright © 2020 revature. All rights reserved.
//

struct SelectStatement {
    //Used for selecting all columns in a table
    private var selectAll: Bool = false
    
    //Used for selecting indiviual columns of a table or with a join
    private var columnNames: [String : (table: SQLiteTable, alias: String)]?
    private var joinStatement: JoinStatement?
    
    private var whereAt: WhereStatement?
    
    init() {
        
    }
    
    mutating func getAllColumns(fromTable table: SQLiteTable) {
        if self.columnNames != nil {
            self.columnNames!.removeAll()
        }
        
        self.selectAll = true

        for column in table.getAllColumns() {
            let columnName = table.addTableReferenceTo(columnName: column.columnName)
            specifyColumn(table: table, columnName: columnName, asName: columnName)
        }
    }
    
    mutating func specifyColumn(table: SQLiteTable, columnName: String, asName: String) {
        if selectAll {
            return
        }
        
        self.columnNames = self.columnNames ?? [String: (SQLiteTable, String)]()
        
        let tableReferenceColumnName = table.addTableReferenceTo(columnName: columnName)
        self.columnNames![tableReferenceColumnName] = (table, asName)
    }
    
    mutating func setJoinStatement(statement: JoinStatement) {
        self.joinStatement = statement
    }
    
    mutating func setWhereStatement(statement: WhereStatement) {
        self.whereAt = statement
    }
    
}

//Getters
extension SelectStatement {
    internal func getColumnNames() -> [String]? {
        guard let columnNames = self.columnNames else { return nil }
        
        var nameArray: [String] = [String]()
        
        for name in columnNames {
            nameArray.append(name.key)
        }
        
        return nameArray
    }
    
    internal func getColumnAliases() -> [String]? {
        guard let columnNames = self.columnNames else { return nil }
        
        var nameArray: [String] = [String]()
        
        for name in columnNames {
            nameArray.append(name.value.alias)
        }
        
        return nameArray
    }
    
    internal func getColumnAliasByName(columnName: String) -> String? {
        guard let column = self.columnNames?[columnName] else { return nil }
        return column.alias
    }
    
    internal func getColumnNameByAlias(columnAlias: String) -> String? {
        guard let columnNames = self.columnNames else { return nil }
        
        for (name, column) in columnNames {
            if column.alias == columnAlias {
                return name
            }
        }
        
        return nil
    }
    
    internal func getTableByColumnName(columnName: String) -> SQLiteTable? {
        guard let table = self.columnNames?[columnName]?.table else { return nil }
        return table
    }
}

//Make String
extension SelectStatement {
    //Makes a full Select Statement string for use in SQL
    internal func makeStatement() -> String? {
        
        var singleTableString = ""
        var joinString = ""
        var whereString = ""
        
        //If there is a JoinStatement, add it to the SelectStatement
        //If a JoinStatement does not exist, a table reference is required to get all columns
        //If a Table or JoinStatement are not found, fail out
        if self.joinStatement != nil {
            if let joinHolder = self.joinStatement?.makeStatement() {
                joinString = " " + joinHolder
            }
        }
        else if let tableName = self.columnNames?.first?.value.table.getTableName() {
            singleTableString = " \(SQLiteKeyword.FROM) \(tableName)"
        }
        else {
            return nil
        }
        
        //If the WhereStatement exists, add it to the SelectStatement
        if let whereHolder = self.whereAt?.makeStatement() {
            whereString = " " + whereHolder
        }
        
        //Return the full SQL string
        return "\(SQLiteKeyword.SELECT) \(makeColumnNamesString()) \(singleTableString)\(joinString)\(whereString);"
    }
    
    //Makes the column section of the Select Statement to access variables from SQL databse
    fileprivate func makeColumnNamesString() -> String {
        var columnNamesString: String = ""
        
        guard let columnNames = self.columnNames else { return "" }
        
        for (index, name) in columnNames.enumerated() {
            columnNamesString += name.key
            columnNamesString += " \(SQLiteKeyword.AS) "
            columnNamesString += name.value.alias

            if index < columnNames.count - 1 {
                columnNamesString += ", "
            }
        }
        
        return columnNamesString
    }
    
}
