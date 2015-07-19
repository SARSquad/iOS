//
//  RowTableViewController.m
//  SARAssist
//
//  Created by V-FEXrt on 7/18/15.
//  Copyright (c) 2015 V-FEXrt. All rights reserved.
//

#import "RowTableViewController.h"
#import "RowTableViewCell.h"
#import <Parse/Parse.h>

#import "MapViewController.h"
@interface RowTableViewController ()
@property (nonatomic, strong)NSArray *blockRows;
@property (nonatomic, strong)PFGeoPoint *currentLocation;
@end

@implementation RowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (geoPoint) {
            //Save the current location
            self.currentLocation = geoPoint;
            
            PFQuery *query = [PFQuery queryWithClassName:@"Block"];
            
            [query whereKey:@"SearchAreaID" equalTo:self.selectedArea[@"SearchAreaID"]];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    
                    int max = -1;
                    for (PFObject *obj in objects) {
                        if ([obj[@"Row"] intValue] > max) {
                            max = [obj[@"Row"]intValue];
                        }
                    }
                    
                    //row starts at 0, therefore max is one less than expected
                    for (int i = 0; i <= max; i++) {
                        NSMutableArray *obj = [[NSMutableArray alloc]init];
                        [arr addObject:obj];
                    }
                    
                    for (PFObject *obj in objects) {
                        int index = [obj[@"Row"]intValue];
                        [arr[index] addObject:obj];
                    }
                    
                    self.blockRows = [arr copy];
                    
                    [self.tableView reloadData];
                    
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
        }
        else
        {
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.blockRows) {
        return [self.blockRows count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Get the first object in the current row
    PFObject *obj = [self.blockRows[indexPath.row]firstObject];
    
    if (obj[@"AssignedTo"] && ![obj[@"AssignedTo"] isEqualToString:@""]) {
        cell.title.text = obj[@"AssignedTo"];
        cell.subtitle.text = obj[@"updatedAt"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        cell.title.text = @"Not Assigned";
        double distance = [self.currentLocation distanceInMilesTo:obj[@"Location"]];
        cell.subtitle.text = [NSString stringWithFormat:@"%.1f miles away", distance];
    }

    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Row?" message:@"Are you sure you want to select this row?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Select Row" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [self performSegueWithIdentifier:@"segue" sender:self];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#warning Need to mark blocks as selected
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    MapViewController *controller = [segue destinationViewController];
    
    controller.selectedBlocks = self.blockRows[path.row];
}


@end
