//
//  DBManager.c
//  Xplorer
//
//  Created by Miguel Ferreira on 08/06/2017.
//  Copyright © 2017 something. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)database_filename{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documents_directory = [paths objectAtIndex:0];
        // Keep the database filename.
        self.database_filename = database_filename;
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destination_path = [self.documents_directory stringByAppendingPathComponent:self.database_filename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destination_path]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *source_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.database_filename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:source_path toPath:destination_path error:&error];
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)query_executable{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    // Set the database file path.
    NSString *database_path = [self.documents_directory stringByAppendingPathComponent:self.database_filename];
    // Initialize the results array.
    if (self.array_results != nil) {
        [self.array_results removeAllObjects];
        self.array_results = nil;
    }
    self.array_results = [[NSMutableArray alloc] init];
    // Initialize the column names array.
    if (self.array_column_names != nil) {
        [self.array_column_names removeAllObjects];
        self.array_column_names = nil;
    }
    self.array_column_names = [[NSMutableArray alloc] init];
    // Open the database.
    BOOL open_database_result = sqlite3_open([database_path UTF8String], &sqlite3Database);
    if(open_database_result == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiled_statement;
        // Load all data from database to memory.
        BOOL prepare_statement_result = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiled_statement, NULL);
        if(prepare_statement_result == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!query_executable){
                // In this case data must be loaded from the database.
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *array_data_row;
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiled_statement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    array_data_row = [[NSMutableArray alloc] init];
                    // Get the total number of columns.
                    int total_columns = sqlite3_column_count(compiled_statement);
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<total_columns; i++){
                        // Convert the column data to text (characters).
                        char *database_data_as_chars = (char *)sqlite3_column_text(compiled_statement, i);
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (database_data_as_chars != NULL) {
                            // Convert the characters to string.
                            [array_data_row addObject:[NSString  stringWithUTF8String:database_data_as_chars]];
                        }
                        // Keep the current column name.
                        if (self.array_column_names.count != total_columns) {
                            database_data_as_chars = (char *)sqlite3_column_name(compiled_statement, i);
                            [self.array_column_names addObject:[NSString stringWithUTF8String:database_data_as_chars]];
                        }
                    }
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (array_data_row.count > 0) {
                        [self.array_results addObject:array_data_row];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                // Execute the query.
                if (sqlite3_step(compiled_statement) == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affected_rows = sqlite3_changes(sqlite3Database);
                    // Keep the last inserted row ID.
                    self.last_inserted_row_ID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        // Release the compiled statement from memory.
        sqlite3_finalize(compiled_statement);
    }
    // Close the database.
    sqlite3_close(sqlite3Database);
}

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    // Returned the loaded results.
    return (NSArray *)self.array_results;
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
