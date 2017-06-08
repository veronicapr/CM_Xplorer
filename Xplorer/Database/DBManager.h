//
//  DBManager.h
//  Xplorer
//
//  Created by Miguel Ferreira on 08/06/2017.
//  Copyright © 2017 something. All rights reserved.
//

#import <sqlite3.h>
#import <Foundation/Foundation.h>

@interface DBManager : NSObject

// ====================================================================================== //
// Controler variables
// ====================================================================================== //
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

// ====================================================================================== //
// Public methods
// ====================================================================================== //
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@end
