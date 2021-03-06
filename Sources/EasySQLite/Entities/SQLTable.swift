//
//  Table.swift
//  iRevatureTrainingRoomMaintenanceScheduler
//
//  Created by Mark Hawkins on 2/13/20.
//  Copyright © 2020 revature. All rights reserved.
//


struct Column {
    var dataType: SQLiteDataType
    var constraints: [SQLiteConstraints]?
}

struct SQLiteTable {
    private var tableName: String
    private var columnNames: [String]
    private var columnData: [(columnName: String, columnInfo: Column)]
    
    init(tableName: String) {
        self.columnData = [(columnName: String, columnInfo: Column)]()
        self.tableName = tableName
        self.columnNames = [String]()
    }
    
    mutating func addColumn(columnName: String, dataType: SQLiteDataType, constraints: SQLiteConstraints?...) {
        
        let columnInfo = Column(dataType: dataType, constraints: constraints as? [SQLiteConstraints])
        let fullColumnName = addTableReferenceTo(columnName: columnName)
    
        columnNames.append(columnName)
        
        for column in self.columnData {
            if column.columnName == fullColumnName {
                return
            }
        }
        
        self.columnData.append((fullColumnName, columnInfo))
    }
}

//===============================================================================================
    //Getters
//===============================================================================================
extension SQLiteTable {
    internal func getTableName() -> String {
        return tableName
    }
    
    internal func addTableReferenceTo(columnName: String) -> String {
        return "\(self.tableName).\(columnName)"
    }
    
    internal func getAllColumnNames(withTableReference: Bool) -> [String]? {
        let tableReferenceString = withTableReference ? "\(self.tableName)." : ""
        
        var columnNames: [String] = [String]()
        
        for (columnName) in self.columnNames {
            columnNames.append(tableReferenceString + columnName)
        }
        
        if columnNames.count != 0 {
            return columnNames
        }
        
        return nil
    }
    
    internal func getColumnData(columnName: String) -> Column? {
        for column in self.columnData {
            if column.columnName == columnName {
                return column.columnInfo
            }
        }
        
        return nil
    }
    
    internal func getAllColumns() -> [(columnName: String, columnInfo: Column)] {
        return self.columnData
    }
    
    internal func getColumnsCount() -> Int {
        return columnData.count
    }
}


extension SQLiteTable {
//===============================================================================================
    //Make A Table Statement
//===============================================================================================
    internal func makeStatement() -> String? {
        if columnNames.isEmpty {
            return nil
        }
        
        var columnString: String = "\(SQLiteKeyword.TABLE) \(tableName) "

        for (index, column) in getAllColumns().enumerated() {
            //Apply comma for new column
            if index == 0 {
                columnString += "("
            }
            else {
                columnString += ", "
            }

            //Assign column name
            columnString += self.columnNames[index]
            
            //Apply the data types
            columnString += makeDataTypeString(dataType: column.columnInfo.dataType)

            //Assign column constraints
            if column.columnInfo.constraints != nil {
                for i in 0 ..< column.columnInfo.constraints!.count {
                    columnString += " \(column.columnInfo.constraints![i].rawValue)"
                }
            }
        }

        columnString += ")"

        return columnString
    }
    
    fileprivate func makeDataTypeString(dataType: SQLiteDataType) -> String {
        //Assign datatype formatting
        switch dataType {
        case .CHAR:
            return " \(dataType.rawValue)(500)"
        case .INT, .BOOL:
            return " \(SQLiteDataType.INT.rawValue)"
        case .INTEGER:
            return " \(SQLiteDataType.INTEGER.rawValue)"
        default:
            return" \(dataType.rawValue)"
        }
    }
    
    fileprivate func makeConstraintString(constraints: [SQLiteConstraints]?) -> String {
        //Assign column constraints
        if constraints != nil {
            var constraintString = ""
            
            for i in 0 ..< constraints!.count {
                constraintString += " \(constraints![i].rawValue)"
            }
            
            return constraintString
        }
        
        return ""
    }
    
    internal func makeColumnNameString(withTableReference: Bool) -> String? {
        guard let columnNames = getAllColumnNames(withTableReference: withTableReference) else {
            return nil
        }
        
        var columnNamesString = ""
        
        for (index, name) in columnNames.enumerated() {
            //Add start statements
            if (index == 0) {
                columnNamesString += "("
            }

            //Add column name
            columnNamesString += name

            //Add spaces
            if index < columnNames.count - 1 {
                columnNamesString += ", "
            }
            else {
                columnNamesString += ")"
            }
        }
        
        return columnNamesString
    }
}

