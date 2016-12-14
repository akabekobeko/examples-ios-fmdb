//
//  ViewController.m
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/11/21.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import "BooksViewController.h"
#import "EditBookViewController.h"
#import "AppDelegate.h"
#import "AppDAO.h"
#import "BookDAO.h"
#import "Book.h"

/** Segur fot the edit book. */
static NSString * const kSegueEditBook = @"EditBook";

////////////////////////////////////////////////////////////////////////////////
@interface BooksViewController () <EditBookViewDelegate>

/** A collection of author names. */
@property (nonatomic) NSMutableArray *authors;

/** Dictionary of book collection (NSMutableArray.<Book>) classified by author name. */
@property (nonatomic) NSMutableDictionary *booksByAuthorName;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation BooksViewController

#pragma mark - UIViewController

/**
 * Called after the controller's view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Books";

    self.authors           = [NSMutableArray array];
    self.booksByAuthorName = [NSMutableDictionary dictionary];

    AppDelegate *app   = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray     *books = [app.appDAO.bookDAO read];
    for (NSInteger i = 0, max = [books count]; i < max; ++i) {
        [self addBook:[books objectAtIndex:i]];
    }

    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTouchCreateBookButton:)];
    self.navigationItem.leftBarButtonItem = button;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/**
 * Notifies the view controller that its view is about to be removed from a view hierarchy.
 *
 * @param animated If YES, the disappearance of the view is being animated.
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self setEditing:NO];

    [super viewWillDisappear:animated];
}

/**
 * Sent to the view controller when the app receives a memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

/**
 * Occurs when the book creation button is touched.
 *
 * @param sender Target of the event.
 */
- (void)didTouchCreateBookButton:(id)sender {
    [self performSegueWithIdentifier:kSegueEditBook sender:self];
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
    return [self.authors count];
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
    NSString *author = [self.authors objectAtIndex:section];
    NSArray  *books  = [self.booksByAuthorName objectForKey:author];
    return [books count];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel         *label          = [cell viewWithTag:1];

    NSString *author = [self.authors objectAtIndex:indexPath.section];
    NSArray  *books  = [self.booksByAuthorName objectForKey:author];
    Book     *book   = [books objectAtIndex:indexPath.row];

    label.text         = book.title;
    cell.clipsToBounds = YES;

    return cell;
}

#pragma mark - EditBookViewDelegate

/**
 * Occurs when editing or creation of a book is completed.
 *
 * @param bookId      Identifier, If it  kBookIdNone is specified for new creation.
 * @param author      Author.
 * @param title       Title.
 * @param releaseDate Release date.
 */
- (void)didFinishEditBook:(NSInteger)bookId author:(NSString *)author title:(NSString *)title releaseDate:(NSDate *)releaseDate {
    // TODO: Update or Create
}

#pragma mark - Private

/**
 * Add the new book.
 *
 * @param book Book.
 */
- (void)addBook:(Book *)book {
    NSMutableArray *books = [self.booksByAuthorName objectForKey:book.author];
    if (books) {
        [books addObject:book];
    } else {
        books = [NSMutableArray array];
        [books addObject:book];
        [self.booksByAuthorName setObject:books forKey:book.author];
        [self.authors addObject:book.author];
    }
}

@end
