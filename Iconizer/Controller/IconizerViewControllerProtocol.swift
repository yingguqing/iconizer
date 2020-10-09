//
// IconizerViewControllerProtocol.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//

import Cocoa

// Adds some required functionality/requirements to NSViewController.
protocol IconizerViewControllerProtocol {

    var view: NSView { get set }

    /// Save the asset catalog.
    ///
    /// - Parameters:
    ///   - name: Name of the asset catalog to be generated.
    ///   - url: File path to the directory to save the asset catalog to.
    /// - Throws: An IconizerViewControllerError
    func saveAssetCatalog(named name: String, toURL url: URL) throws

    var saveURL:URL? { get }
    
    /// Open an image and insert it into the currently
    /// active image well.
    ///
    /// - Parameter image: The selected image.
    /// - Throws: An error, in case the selected image couldn't be opened.
    func openSelectedImage(_ image: NSImage?) throws
    
    var saveOptions:(name:String, url:URL)? { get }
}


extension IconizerViewControllerProtocol {
    var saveOptions:(name:String, url:URL)? {
        return nil
    }
    
    var saveURL:URL? {
        return nil
    }
}
