//
//  EditBookViewController.h
//  UsingFMDB-Objective-C
//
//  Created by akabeko on 2016/12/13.
//  Copyright © 2016年 akabeko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;

////////////////////////////////////////////////////////////////////////////////
/**
 * Notify the editing status of the book.
 */
@protocol EditBookViewDelegate <NSObject>

/**
 * Occurs when editing or creation of a book is completed.
 *
 * @param oldBook Old book data.
 * @param newBook New book data.
 */
- (void)didFinishEditBook:(Book *)oldBook newBook:(Book *)newBook;

@end

////////////////////////////////////////////////////////////////////////////////
/**
 * Edit or create a book.
 */
@interface EditBookViewController : UIViewController

/** Notify the editing status of the book. */
@property (nonatomic, assign) id<EditBookViewDelegate> delegate;

/** Books to edit, if it is created nil. */
@property (nonatomic, assign) Book *originalBook;

@end
