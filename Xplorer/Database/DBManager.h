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
@property (nonatomic, strong) NSString *documents_directory;
@property (nonatomic, strong) NSString *database_filename;
@property (nonatomic, strong) NSMutableArray *array_results;
@property (nonatomic, strong) NSMutableArray *array_column_names;
@property (nonatomic) int affected_rows;
@property (nonatomic) long long last_inserted_row_ID;

// ====================================================================================== //
// Public methods
// ====================================================================================== //
-(instancetype)initWithDatabaseFilename:(NSString *)database_filename;
-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)query_executable;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@end
