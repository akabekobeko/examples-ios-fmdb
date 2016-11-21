//
//  ViewController.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/11/21.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "BooksViewController.h"

@interface BooksViewController ()

@end

@implementation BooksViewController

#pragma mark - UIViewController

/**
 * Called after the controller's view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Books";
}

/**
 * Sent to the view controller when the app receives a memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

/**
 * Asks the data source to return the number of sections in the table view.
 *
 * @param tableView An object representing the table view requesting this information.
 *
 * @return The number of sections in tableView. The default value is 1.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

/**
 * Tells the data source to return the number of rows in a given section of a table view.
 *
 * @param tableView The table-view object requesting this information.
 * @param section   An index number identifying a section in tableView.
 *
 * @return The number of rows in section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/**
 * Asks the data source for a cell to insert in a particular location of the table view.
 *
 * @param tableView A table-view object requesting the cell.
 * @param indexPath An index path locating a row in tableView.
 *
 * @return An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
