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
    return [self.authors count];
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
    NSString *author = [self.authors objectAtIndex:section];
    NSArray  *books  = [self.booksByAuthorName objectForKey:author];
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
    return [self.authors objectAtIndex:section];
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

    label.text         = book.title;
    cell.clipsToBounds = YES;

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
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        Book        *book = [self bookAtIndexPath:indexPath];
        if ([app.appDAO.bookDAO remove:book.bookId]) {
            [self removeBook:book];
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
 * @param newBook New book data.
 * @param oldBook Old book data.
 */
- (void)didFinishEditBook:(Book *)newBook oldBook:(Book *)oldBook {
    if (newBook.bookId == kBookIdNone) {
        [self createBook:newBook];
    } else {
        [self updateBook:newBook oldBook:oldBook];
    }
}

#pragma mark - Private

/**
 * Add the new book.
 *
 * @param book Book.
 */
- (void)addBook:(Book *)book {
    if (!(book)) { return; }

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

/**
 * Get the book at index path.
 *
 * @param indexPath An index path locating a row in tableView.
 *
 * @return Book data.
 */
- (Book *)bookAtIndexPath:(NSIndexPath *)indexPath {
    NSString *author = [self.authors objectAtIndex:indexPath.section];
    NSArray  *books  = [self.booksByAuthorName objectForKey:author];
    return [books objectAtIndex:indexPath.row];
}

/**
 * Create the book.
 *
 * @param book Book data.
 */
- (void)createBook:(Book *)book {
    AppDelegate *app     = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Book        *newBook = [app.appDAO.bookDAO add:book.author title:book.title releaseDate:book.releaseDate];
    if (!(newBook)) { return; }

    [self addBook:newBook];
    [self.tableView reloadData];
}

/**
 * Remove the author.
 *
 * @param author Name of the author.
 */
- (void)removeAuthor:(NSString *)author {
    [self.booksByAuthorName removeObjectForKey:author];
    for (NSInteger i = 0, max = self.authors.count; i < max; ++i) {
        NSString *existAuthor = [self.authors objectAtIndex:i];
        if ([existAuthor compare:author] == NSOrderedSame) {
            [self.authors removeObjectAtIndex:i];
            break;
        }
    }
}

/**
 * Remove the book.
 *
 * @param book Book data.
 */
- (void)removeBook:(Book *)book {
    NSMutableArray *books = [self.booksByAuthorName objectForKey:book.author];
    for (NSInteger i = 0, max = books.count; i < max; ++i) {
        Book *existBook = [books objectAtIndex:i];
        if (existBook.bookId == book.bookId) {
            [books removeObjectAtIndex:i];
            break;
        }
    }

    if (books.count == 0) {
        [self removeAuthor:book.author];
    }
}

/**
 * Update the book.
 *
 * @param newBook New book data.
 * @param oldBook Old book data.
 */
- (void)updateBook:(Book *)newBook oldBook:(Book *)oldBook {
    AppDelegate *app     = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!([app.appDAO.bookDAO update:newBook])) { return; }

    if ([newBook.author compare:oldBook.author] == NSOrderedSame) {
        // Replace
        NSMutableArray *books = [self.booksByAuthorName objectForKey:newBook.author];
        for (NSInteger i = 0, max = books.count; i < max; ++i) {
            Book *book = [books objectAtIndex:i];
            if (book.bookId == newBook.bookId) {
                [books replaceObjectAtIndex:i withObject:newBook];
                break;
            }
        }
    } else {
        // Change author
        [self removeBook:oldBook];
        [self addBook:newBook];
    }

    [self.tableView reloadData];
}

@end
