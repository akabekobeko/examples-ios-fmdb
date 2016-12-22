//
//  BooksViewController.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/17.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit

/// List view for a books.
class BooksViewController: UITableViewController, EditBookViewControllerDelegate {
    /// Segue fot the edit book.
    private static let SegueEditBook = "EditBook"

    /// Name for the cell.
    private static let CellIdentifier = "Cell"

    /// A value indicating that a new book should be created.
    private var creatingBook = false

    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Books"

        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(didTouchCreateBookButton(sender:)))
        self.navigationItem.leftBarButtonItem  = button
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    /// Notifies the view controller that its view is about to be removed from a view hierarchy.
    ///
    /// - Parameter animated: If true, the disappearance of the view is being animated.
    override func viewWillAppear(_ animated: Bool) {
        self.setEditing(false, animated: animated)
        super.viewWillAppear(animated)
    }

    /// Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Notifies the view controller that a segue is about to be performed.
    ///
    /// - Parameters:
    ///   - segue: The segue object containing information about the view controllers involved in the segue.
    ///   - sender: The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == BooksViewController.SegueEditBook {
            let vc  = segue.destination as! EditBookViewController
            vc.originalBook = self.creatingBook ? nil : self.bookAtIndexPath(indexPath: self.tableView.indexPathForSelectedRow!)
            vc.deletate     = self
        }
    }

    /// Occurs when editing or creation of a book is completed.
    ///
    /// - Parameters:
    ///   - viewController: Sender.
    ///   - oldBook:        Old book data.
    ///   - newBook:        New book data.
    func didFinishEditBook(viewController: EditBookViewController, oldBook: Book?, newBook: Book) {
        let store   = self.bookStore()
        var success = false;
        if (newBook.bookId == Book.BookIdNone) {
            success = store.add(book: newBook)
        } else {
            success = store.update(oldBook: oldBook!, newBook: newBook)
        }
  
        if success {
            self.tableView.reloadData()
        }
    }

    /// Occurs when the book creation button is touched.
    ///
    /// - Parameter sender: Target of the event.
    func didTouchCreateBookButton(sender: Any?) {
        self.creatingBook = true
        self.performSegue(withIdentifier: BooksViewController.SegueEditBook, sender: self)
    }

    /// Asks the data source to return the number of sections in the table view.
    ///
    /// - Parameter tableView: An object representing the table view requesting this information.
    /// - Returns: The number of sections in tableView. The default value is 1.
    override func numberOfSections(in tableView: UITableView) -> Int {
        let store  = self.bookStore()
        return store.authors.count
    }

    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section:   An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let store  = self.bookStore()
        let author = store.authors[section]
        let books  = store.booksByAuthor[author]

        return (books?.count)!
    }

    /// Asks the data source for the title of the header of the specified section of the table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object asking for the title.
    ///   - section:   An index number identifying a section of tableView.
    /// - Returns: A string to use as the title of the section header. If you return nil , the section will have no title.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let store = self.bookStore()
        return store.authors[section]
    }

    /// Asks the data source for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: BooksViewController.CellIdentifier, for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        let book  = self.bookAtIndexPath(indexPath: indexPath)

        label.text = book.title

        return cell
    }

    /// Asks the data source to commit the insertion or deletion of a specified row in the receiver.
    ///
    /// - Parameters:
    ///   - tableView:    The table-view object requesting the insertion or deletion.
    ///   - editingStyle: The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are UITableViewCellEditingStyleInsert or UITableViewCellEditingStyleDelete.
    ///   - indexPath:    An index path locating the row in tableView.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let store = self.bookStore()
            let book  = self.bookAtIndexPath(indexPath: indexPath)
            if store.remove(book: book) {
                self.tableView.reloadData()
            }
        }
    }

    /// Tells the delegate that the specified row is now selected.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object informing the delegate about the new row selection.
    ///   - indexPath: An index path locating the new selected row in tableView.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.creatingBook = false
        self.performSegue(withIdentifier: BooksViewController.SegueEditBook, sender: self)
    }

    /// Get the book at index path.
    ///
    /// - Parameter indexPath: An index path locating a row in tableView.
    /// - Returns: Book data.
    private func bookAtIndexPath(indexPath: IndexPath) -> Book {
        let store  = self.bookStore()
        let author = store.authors[indexPath.section]
        let books  = store.booksByAuthor[author]

        return books![indexPath.row]
    }

    /// Get the book sore.
    ///
    /// - Returns: Instance of the book store.
    func bookStore() -> BookStore {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.appStore.bookStore
    }
}

