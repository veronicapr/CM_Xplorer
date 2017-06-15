//
//  LandmarkTableController.m
//  Xplorer
//
//  Created by Miguel Ferreira on 14/06/2017.
//  Copyright © 2017 something. All rights reserved.
//

#import "LandmarkTableController.h"

@implementation LandmarkTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _database_manager = [(AppDelegate*)[[UIApplication sharedApplication] delegate] database_manager];
    // Make self the delegate and datasource of the table view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Load landmarks
    [self loadLandmarks];
}
/*  */
-(void)loadLandmarks{
    _query = nil;
    _query_results = nil;
    // Form the query.
    _query = @"Select * from Areas where Active = 1";
    // Get the results.
    _query_results = [[NSArray alloc] initWithArray:[_database_manager loadDataFromDB:_query]];
    // Reload the table view.
    [self.tableView reloadData];
}
/*  */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
/*  */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _query_results.count;
}
/*  */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}/*  */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idLandmarkCell" forIndexPath:indexPath];
    // Get indexes
    NSInteger index_of_landmark = [_database_manager.array_column_names indexOfObject:@"Landmark"];
    NSInteger index_of_zone = [_database_manager.array_column_names indexOfObject:@"Zone"];
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[_query_results objectAtIndex:indexPath.row] objectAtIndex:index_of_landmark]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[_query_results objectAtIndex:indexPath.row] objectAtIndex:index_of_zone]];
    cell.imageView.image = [UIImage imageNamed:@"Obelisk-2x.png"];
    return cell;
}

@end
