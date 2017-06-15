//
//  LandmarkTableController.h
//  Xplorer
//
//  Created by Miguel Ferreira on 15/06/2017.
//  Copyright © 2017 something. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LandmarkTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
// ====================================================================================== //
// Managers
// ====================================================================================== //
@property (strong, nonatomic) DBManager *database_manager;

// ====================================================================================== //
// Controler variables
// ====================================================================================== //
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSArray *query_results;

/* load landmarks to table */
-(void)loadLandmarks;
/*  */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
/*  */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
/*  */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
/*  */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
