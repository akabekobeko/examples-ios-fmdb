//
//  ViewController.swift
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

    /// A collection of author names.
    private var authors = Array<String>()

    /// Dictionary of book collection classified by author name.
    private var booksByAuthorName = Dictionary<String, Array<Book>>()

    /// A value indicating that a new book should be created.
    private var creatingBook = false
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Books"

        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(didTouchCreateBookButton(sender:)))
        self.navigationItem.leftBarButtonItem  = button;
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        let app  = UIApplication.shared.delegate as! AppDelegate
        let books = app.appDAO.bookDAO?.read()
        books?.forEach({ book in
          self.addBook(book: book)
        })
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
            let vc = segue.destination as! EditBookViewController
            vc.originalBook = self.creatingBook ? nil : self.bookAtIndexPAth(indexPath: self.tableView.indexPathForSelectedRow!);
            vc.deletate     = self
        }
    }

    /// Occurs when editing or creation of a book is completed.
    ///
    /// - Parameters:
    ///   - oldBook: Old book data.
    ///   - newBook: New book data.
    func didFinishEditBook(oldBook: Book?, newBook: Book) {
        if (newBook.bookId == Book.BookIdNone) {
            self.createBook(book: newBook)
        } else {
            self.updateBook(oldBook: oldBook, newBook: newBook)
        }
    }

    /// Occurs when the book creation button is touched.
    ///
    /// - Parameter sender: Target of the event.
    func didTouchCreateBookButton(sender: Any?) -> Void {
        self.creatingBook = true
        self.performSegue(withIdentifier: BooksViewController.SegueEditBook, sender: self)
    }

    /// Asks the data source to return the number of sections in the table view.
    ///
    /// - Parameter tableView: An object representing the table view requesting this information.
    /// - Returns: The number of sections in tableView. The default value is 1.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.authors.count
    }

    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section:   An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let author = self.authors[section]
        let books  = self.booksByAuthorName[author]

        return (books?.count)!
    }

    /// Asks the data source for the title of the header of the specified section of the table view.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object asking for the title.
    ///   - section:   An index number identifying a section of tableView.
    /// - Returns: A string to use as the title of the section header. If you return nil , the section will have no title.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.authors[section]
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
        let book  = self.bookAtIndexPAth(indexPath: indexPath)

        label.text         = book.title
        cell.clipsToBounds = true

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
            let app  = UIApplication.shared.delegate as! AppDelegate
            let book = self.bookAtIndexPAth(indexPath: indexPath)
            if (app.appDAO.bookDAO?.remove(bookId: book.bookId))! {
                self.removeBook(book: book)
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
    private func bookAtIndexPAth(indexPath: IndexPath) -> Book {
        let author = self.authors[indexPath.section]
        let books  = self.booksByAuthorName[author]

        return books![indexPath.row]
    }

    /// Add the new book.
    ///
    /// - Parameter book: Book data.
    private func addBook(book: Book) -> Void {
        if var books = self.booksByAuthorName[book.author] {
            books.append(book)
            self.booksByAuthorName.updateValue(books, forKey: book.author)
        } else {
            var newBooks = Array<Book>()
            newBooks.append(book)
            self.booksByAuthorName[book.author] = newBooks
            self.authors.append(book.author)
        }
    }

    /// Create the book.
    ///
    /// - Parameter book: Book data.
    private func createBook(book: Book) -> Void {
        let app = UIApplication.shared.delegate as! AppDelegate
        if let newBook = app.appDAO.bookDAO?.add(author: book.author, title: book.title, releaseDate: book.releaseDate) {
            self.addBook(book: newBook)
            self.tableView.reloadData()
        }
    }

    /// Remove the author.
    ///
    /// - Parameter author: Name of the author.
    private func removeAuthor(author: String) -> Void {
        self.booksByAuthorName.removeValue(forKey: author)
        for i in 0..<self.authors.count {
            let existAuthor = self.authors[i]
            if existAuthor == author {
                self.authors.remove(at: i)
                break;
            }
        }
    }

    /// Remove the book.
    ///
    /// - Parameter book: Book data.
    private func removeBook(book: Book) -> Void {
        if var books = self.booksByAuthorName[book.author] {
            for i in 0..<books.count {
                let existBook = books[i]
                if existBook.bookId == book.bookId {
                    books.remove(at: i)
                    self.booksByAuthorName.updateValue(books, forKey: book.author)
                    break
                }
            }

            if books.count == 0 {
                self.removeAuthor(author: book.author)
            }
        }
    }

    /// Update the book.
    ///
    /// - Parameter oldBook: New book data.
    /// - Parameter newBook: Old book data.
    private func updateBook(oldBook: Book?, newBook: Book) -> Void {
        let app = UIApplication.shared.delegate as! AppDelegate
        if (app.appDAO.bookDAO?.update(book: newBook))! == false {
            return
        }

        if oldBook?.author == newBook.author {
            // Replace
            if var books = self.booksByAuthorName[(oldBook?.author)!] {
                for i in 0..<books.count {
                    let existBook = books[i]
                    if existBook.bookId == existBook.bookId {
                        books[i] = newBook
                        self.booksByAuthorName.updateValue(books, forKey: (oldBook?.author)!)
                    }
                }
            }
        } else {
            // Change author
            self.removeBook(book: oldBook!)
            self.addBook(book: newBook)
        }

        self.tableView.reloadData()
    }
}

