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
#import "AppStore.h"
#import "BookStore.h"
#import "Book.h"

/** Segur fot the edit book. */
static NSString * const kSegueEditBook = @"EditBook";

////////////////////////////////////////////////////////////////////////////////
@interface BooksViewController () <EditBookViewDelegate>

/** A value indicating that a new book should be created. */
@property (nonatomic) BOOL creatingBook;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation BooksViewController

#pragma mark - UIViewController

/**
 * Called after the controller's view is loaded into memory.
 *
 * @see https://developer.apple.com/reference/uikit/uiviewcontroller/1621495-viewdidload?language=objc
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Books";

    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTouchCreateBookButton:)];
    self.navigationItem.leftBarButtonItem = button;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/**
 * Notifies the view controller that its view is about to be removed from a view hierarchy.
 *
 * @param animated If YES, the disappearance of the view is being animated.
 *
 * https://developer.apple.com/reference/uikit/uiviewcontroller/1621485-viewwilldisappear?language=objc
 */
- (void)viewWillDisappear:(BOOL)animated {
    [self setEditing:NO];

    [super viewWillDisappear:animated];
}

/**
 * Sent to the view controller when the app receives a memory warning.
 *
 * @see https://developer.apple.com/reference/uikit/uiviewcontroller/1621409-didreceivememorywarning?language=objc
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * Notifies the view controller that a segue is about to be performed.
 *
 * @param segue  The segue object containing information about the view controllers involved in the segue.
 * @param sender The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
 *
 * @see https://developer.apple.com/reference/uikit/uiviewcontroller/1621490-prepareforsegue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [[segue identifier] isEqualToString:kSegueEditBook] ) {
        EditBookViewController *vc = [segue destinationViewController];
        vc.originalBook = self.creatingBook ? nil : [self bookAtIndexPath:self.tableView.indexPathForSelectedRow];
        vc.delegate     = self;
    }
}

#pragma mark - Action

/**
 * Occurs when the book creation button is touched.
 *
 * @param sender Target of the event.
 */
- (void)didTouchCreateBookButton:(id)sender {
    self.creatingBook = YES;
    [self performSegueWithIdentifier:kSegueEditBook sender:self];
}

#pragma mark - UITableViewDataSource

/**
 * Asks the data source to return the number of sections in the table view.
 *
 * @param tableView An object representing the table view requesting this information.
 *
 * @return The number of sections in tableView. The default value is 1.
 *
 * @see https://developer.apple.com/reference/uikit/uitableviewdatasource/1614860-numberofsectionsintableview?language=objc
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    BookStore *store = [self bookStore];
    return [store.authors count];
}

/**
 * Tells the data source to return the number of rows in a given section of a table view.
 *
 * @param tableView The table-view object requesting this information.
 * @param section   An index number identifying a section in tableView.
 *
 * @return The number of rows in section.
 *
 * @see https://developer.apple.com/reference/uikit/uitableviewdatasource/1614931-tableview?language=objc
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BookStore *store  = [self bookStore];
    NSString  *author = [store.authors objectAtIndex:section];
    NSArray   *books  = [store.booksByAuthor objectForKey:author];

    return [books count];
}

/**
 * Asks the data source for the title of the header of the specified section of the table view.
 *
 * @param tableView The table-view object asking for the title.
 * @param section   An index number identifying a section of tableView.
 *
 * @return A string to use as the title of the section header. If you return nil , the section will have no title.
 *
 * @see https://developer.apple.com/reference/uikit/uitableviewdatasource/1614850-tableview?language=objc
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BookStore *store = [self bookStore];
    return [store.authors objectAtIndex:section];
}

/**
 * Asks the data source for a cell to insert in a particular location of the table view.
 *
 * @param tableView A table-view object requesting the cell.
 * @param indexPath An index path locating a row in tableView.
 *
 * @return An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil.
 *
 * @see https://developer.apple.com/reference/uikit/uitableviewdatasource/1614861-tableview?language=objc
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel         *label          = [cell viewWithTag:1];
    Book            *book           = [self bookAtIndexPath:indexPath];

    label.text = book.title;

    return cell;
}

/**
 * Asks the data source to commit the insertion or deletion of a specified row in the receiver.
 *
 * @param tableView    The table-view object requesting the insertion or deletion.
 * @param editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are UITableViewCellEditingStyleInsert or UITableViewCellEditingStyleDelete.
 * @param indexPath    An index path locating the row in tableView.
 *
 * @see https://developer.apple.com/reference/uikit/uitableviewdatasource/1614871-tableview?language=objc
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BookStore *store = [self bookStore];
        Book      *book  = [self bookAtIndexPath:indexPath];

        if ([store remove:book]) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDelegate

/**
 * Tells the delegate that the specified row is now selected.
 *
 * @param tableView A table-view object informing the delegate about the new row selection.
 * @param indexPath An index path locating the new selected row in tableView.
 *
 * @see https://developer.apple.com/reference/uikit/uitableviewdelegate/1614877-tableview?language=objc
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.creatingBook = NO;
    [self performSegueWithIdentifier:kSegueEditBook sender:self];
}

#pragma mark - EditBookViewDelegate

/**
 * Occurs when editing or creation of a book is completed.
 *
 * @param oldBook Old book data.
 * @param newBook New book data.
 */
- (void)didFinishEditBook:(Book *)oldBook newBook:(Book *)newBook{
    BookStore *store    = [self bookStore];
    BOOL      succeeded = NO;

    if (newBook.bookId == kBookIdNone) {
        succeeded = [store add:newBook];
    } else {
        succeeded = [store update:oldBook newBook:newBook];
    }

    if (succeeded) {
        [self.tableView reloadData];
    }
}

#pragma mark - Private

/**
 * Get the book at index path.
 *
 * @param indexPath An index path locating a row in tableView.
 *
 * @return Book data.
 */
- (Book *)bookAtIndexPath:(NSIndexPath *)indexPath {
    BookStore *store  = [self bookStore];
    NSString  *author = [store.authors objectAtIndex:indexPath.section];
    NSArray   *books  = [store.booksByAuthor objectForKey:author];

    return [books objectAtIndex:indexPath.row];
}

/**
 * Get the book sore.
 *
 * @return Instance of the book store.
 */
- (BookStore *)bookStore {
    AppDelegate *app   = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return app.appStore.bookStore;
}

@end
