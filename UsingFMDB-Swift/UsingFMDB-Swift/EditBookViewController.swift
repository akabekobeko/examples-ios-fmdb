//
//  EditBookViewController.swift
//  UsingFMDB-Swift
//
//  Created by akabeko on 2016/12/19.
//  Copyright © 2016年 akabeko. All rights reserved.
//

import UIKit

/// Notify the editing status of the book.
protocol EditBookViewControllerDelegate : class {
    /// Occurs when editing or creation of a book is completed.
    ///
    /// - Parameters:
    ///   - oldBook: Old book data.
    ///   - newBook: New book data.
    func didFinishEditBook(oldBook: Book?, newBook: Book) -> Void
}

/// Edit or create a book.
class EditBookViewController: UIViewController, UINavigationBarDelegate, UITextFieldDelegate {
    /// Books to edit, if it is created nil.
    weak var originalBook: Book?

    /// Notify the editing status of the book.
    weak var deletate: EditBookViewControllerDelegate?

    /// TextField to the edit of author.
    @IBOutlet weak var authorTextField: UITextField!

    /// TextField to the edit of title.
    @IBOutlet weak var titleTextField: UITextField!

    /// DatePicker to the edit of release date.
    @IBOutlet weak var releaseDatePicker: UIDatePicker!

    /// Button to complete editing.
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.authorTextField.delegate = self
        self.titleTextField.delegate  = self

        if (self.originalBook != nil) {
            self.authorTextField.text   = self.originalBook?.author
            self.titleTextField.text    = self.originalBook?.title
            self.releaseDatePicker.date = (self.originalBook?.releaseDate)!
        } else {
            self.authorTextField.text = "Sample Author"
            self.titleTextField.text  = "Sample Title"
        }
    }

    /// Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// Asks the delegate for the position of the specified bar in its new window.
    ///
    /// - Parameter bar: The bar that was added to the window.
    /// - Returns: The position of the bar.
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    /// Asks the delegate if the text field should process the pressing of the return button.
    ///
    /// - Parameter textField: The text field whose return button was pressed.
    /// - Returns: true if the text field should implement its default behavior for the return button; otherwise, false.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// Cancel the editing.
    ///
    /// - Parameter sender: Event target.
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Complete the editing.
    ///
    /// - Parameter sender: Event target.
    @IBAction func done(_ sender: Any) {
        let newBook = Book(bookId: Book.BookIdNone,
                           author: self.authorTextField.text!,
                           title: self.titleTextField.text!,
                           releaseDate: self.releaseDatePicker.date)
        self.deletate?.didFinishEditBook(oldBook: self.originalBook, newBook: newBook)
        self.dismiss(animated: true, completion: nil)
    }

    /// Occurs when the TextField to the author is edited.
    ///
    /// - Parameter sender: Event target.
    @IBAction func didEditingChangedAuthorTextField(_ sender: Any) {
        self.updateDoneButton()
    }

    /// Occurs when the TextField to the title is edited.
    ///
    /// - Parameter sender: Event target.
    @IBAction func didEditingChangedTitleTextField(_ sender: Any) {
        self.updateDoneButton()
    }

    /// Update the done button.
    func updateDoneButton() -> Void {
        self.doneButton.isEnabled = ( self.authorTextField.text != "" && self.titleTextField.text != "" );
    }
}
