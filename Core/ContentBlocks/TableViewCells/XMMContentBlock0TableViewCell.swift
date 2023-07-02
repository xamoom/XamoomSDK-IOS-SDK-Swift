//
//  XMMContent0TabelViewCell.swift
//  XamoomSDK
//
//  Created by Ivan Magda on 01.05.2023.
//  Copyright © 2023 xamoom GmbH. All rights reserved.


import Foundation
import UIKit
import WebKit

class XMMContentBlock0TableViewCell: UITableViewCell, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var copyrightHeight: NSLayoutConstraint!
    
    private var webView: WKWebView?
    static var contentFontSize: Int = 0
    var contentLinkColor: UIColor?
    
    override func awakeFromNib() {
        // Initialization code
        titleLabel.text = ""
        contentTextView.text = ""
        super.awakeFromNib()
    }
    
    @objc static func fontSize() -> Int {
        return contentFontSize
    }
    
    @objc static func setFontSize(_ fontSize: Int) {
        Self.contentFontSize = fontSize
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        contentTextView.text = ""
    }
    
    func configureForCell(block: XMMContentBlock, tabelView: UITableView?, indexPath: IndexPath?, style: XMMStyle, offline: Bool) {
        webViewContainer.isHidden = true
        copyrightLabel.text = nil
        titleLabel.text = nil
        if let foregroundFontColor = style.foregroundFontColor {
            titleLabel.textColor = UIColor(hexString: foregroundFontColor)
        }
        if let highlightFontColor = style.highlightFontColor {
            self.contentTextView.linkTextAttributes = [.foregroundColor: UIColor(hexString: highlightFontColor)!]
        }
        if let title = block.title, !title.isEmpty {
            titleLabel.isHidden = false
            titleLabel.text = title
        }
        displayContent(text: block.text, style: style)
        
        if let copyright = block.copyright, !copyright.isEmpty {
            copyrightLabel.isHidden = false
            copyrightLabel.text = copyright
            copyrightLabel.sizeToFit()
        }
        progressIndicator.stopAnimating()
        
    }
    
    private func displayTitle(title: String?, block: XMMContentBlock) {
        if let title = title, !title.isEmpty {
            contentTextViewTopConstraint.constant = 8
            titleLabel.text = title
        } else {
            contentTextViewTopConstraint.constant = 0
        }
    }
    
    private func displayContent(text: String?, style: XMMStyle) {
        if let text = text, !text.isEmpty {
            resetTextViewInsets(contentTextView)
            
            var color = UIColor(hexString: style.foregroundFontColor!)
            if color == nil {
                color = contentTextView.textColor
            }
            if text == "<p></p>" {
                disappear(textView: contentTextView)
            } else if text.contains("iframe") {
                embedWebView(text: text)
            } else {
                contentTextView.attributedText = attributedStringFromHTML(html: text, fontSize: Self.fontSize(), color: color!)
            }
            contentTextView.sizeToFit()
        } else {
            disappear(textView: contentTextView)
        }
    }
    
    private func embedWebView(text: String) {
        webViewContainer.isHidden = false
        progressIndicator.startAnimating()
        let webConfiguration = WKWebViewConfiguration()
        webViewContainer.heightAnchor.constraint(equalToConstant: 183.0).isActive = true
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: webViewContainer.bounds.size.width, height: 183),
                            configuration: webConfiguration)
        webView?.scrollView.isScrollEnabled = false
        webView?.scrollView.bounces = false
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        DispatchQueue.main.async(execute: { [self] in
            webView?.loadHTMLString(text, baseURL: nil)
            if let webView = webView {
                webViewContainer.addSubview(webView)
            }
        })
    }
    
    private func resetTextViewInsets(_ textView: UITextView) {
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: -5)
    }
    
    private func disappear(textView: UITextView) {
        textView.font = UIFont.systemFont(ofSize: 0.0)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 20, right: -5)
        contentTextViewTopConstraint.constant = 0
    }
    
    private func attributedStringFromHTML(html: String, fontSize: Int, color: UIColor) -> NSMutableAttributedString {
        
        var err: Error? = nil
        var html = html
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(pattern: "\n{2,}", options: [])
        } catch {
            err = error
        }
        html = (regex?.stringByReplacingMatches(in: html, options: [], range: NSRange(location: 0, length: html.count), withTemplate: "\n"))!
        var attributedString: NSMutableAttributedString? = nil
        do {
            if let data = "".data(using: .utf8) {
                attributedString = try NSMutableAttributedString(
                    data: data,
                    options: [
                        NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                        NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                    ], documentAttributes: nil)
            }
        } catch {
            err = error
        }
        if html.contains("<ul>") || html.contains("<ol>") {
            var splitedText: [String] = []
            if html.contains("<ul>") && !(html.contains("<ol>")) {
                splitedText.append(contentsOf: getArrayOfHtmlStrings(text: html, fontSize: fontSize, listType: "<ul>"))
            } else if html.contains("<ol>") && !(html.contains("<ul>")) {
                splitedText.append(contentsOf: getArrayOfHtmlStrings(text: html, fontSize: fontSize, listType: "<ol>"))
            } else {
                splitedText.append(contentsOf: getArrayOfHtmlStrings(text: html, fontSize: fontSize, listType: "<ul>"))
            }
            for textPart in splitedText {
                let modifiedTextPart = getStyledHtmlString(html: textPart, fontSize: fontSize)
                if modifiedTextPart.contains("<ul>") || modifiedTextPart.contains("<ol>") {
                    var listAttributedString: NSMutableAttributedString? = nil
                    do {
                        if let data = modifiedTextPart.data(using: .utf8) {
                            listAttributedString = try NSMutableAttributedString(
                                data: data,
                                options: [
                                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                ],
                                documentAttributes: nil)
                        }
                    } catch {
                        err = error
                    }
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.baseWritingDirection = .natural
                    
                    if #available(iOS 9.0, *) {
                        paragraphStyle.addTabStop(NSTextTab(textAlignment: .left, location: 10))
                    }
                    paragraphStyle.headIndent = 28
                    paragraphStyle.paragraphSpacing = 5
                    paragraphStyle.alignment = .natural
                    
                    listAttributedString?.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: listAttributedString?.length ?? 0))
                    
                    attributedString?.append(listAttributedString!)
                } else {
                    var ordinaryAttributedStringNearList: NSMutableAttributedString? = nil
                    do {
                        if let data = modifiedTextPart.data(using: .utf8) {
                            ordinaryAttributedStringNearList = try NSMutableAttributedString(
                                data: data,
                                options: [
                                    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                    NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                                ],
                                documentAttributes: nil)
                        }
                    } catch {
                        err = error
                    }
                    let ordinaryParagraphStyleNearList = NSMutableParagraphStyle()
                    ordinaryParagraphStyleNearList.baseWritingDirection = .natural
                    ordinaryAttributedStringNearList?.addAttribute(.paragraphStyle, value: ordinaryParagraphStyleNearList, range: NSRange(location: 0, length: ordinaryAttributedStringNearList?.length ?? 0))
                    
                    attributedString?.append(ordinaryAttributedStringNearList!)
                }
            }
        } else {
            let modifiedTextPartOrdinary = getStyledHtmlString(html: html, fontSize: fontSize)
            var ordinaryAttributedString: NSMutableAttributedString? = nil
            do {
                if let data = modifiedTextPartOrdinary.data(using: .utf8) {
                    ordinaryAttributedString = try NSMutableAttributedString(
                        data: data,
                        options: [
                            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                            NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
                        ],
                        documentAttributes: nil)
                }
            } catch {
                err = error
            }
            let ordinaryParagraphStyle = NSMutableParagraphStyle()
            ordinaryParagraphStyle.baseWritingDirection = .natural
            ordinaryAttributedString?.addAttribute(.paragraphStyle, value: ordinaryParagraphStyle, range: NSRange(location: 0, length: ordinaryAttributedString?.length ?? 0))
            
            attributedString?.append(ordinaryAttributedString!)
        }
        
        if (err != nil) {
            print("Unable to parse label text:", err!.localizedDescription)
        }
        
        if color != nil {
            attributedString?.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: attributedString?.length ?? 0))
        }
        
        var isNewLineExist: Bool = true
        
        print("\(String(describing: attributedString?.string))")
        if attributedString?.string == "" {
            return attributedString!
        }
        
        while isNewLineExist {
            let last = attributedString?.string.last
            if last == "\n" {
                attributedString?.deleteCharacters(in: NSRange(location: attributedString!.length - 1, length: 1))
            } else {
                isNewLineExist = false
            }
        }
        return attributedString!
    }
    
    private func getStyledHtmlString(html: String, fontSize: Int) -> String {
        var html = html
        let style = String(format: "<style>body{font-family: \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif; font-size:%d; margin:0 !important;} p:last-child{text-align:right;}, p:last-of-type{margin:0px !important;} </style>", fontSize)
        html = html.replacingOccurrences(of: "<p></p>", with: "")
        html = html.replacingOccurrences(of: "<br></li>", with: "</li>")
        html = html.replacingOccurrences(of: "<br></p>", with: "</p>")
        html = html.replacingOccurrences(of: "</p>", with: "</p><br>")
        html = html.replacingOccurrences(of: "</p><br><br><p>", with: "</p><br><p>")
        html = html.replacingOccurrences(of: "</p><p>", with: "</p><p>")
        
        html = "\(style)\(html)"
        
        if !(html.contains("<ul>")) {
            if (html as NSString).substring(from: (html.count) - 12) == "<br></p><br>" {
                html = (html as NSString).substring(to: (html.count) - 12)
                html = html + "</p>"
            } else if (html as NSString).substring(from: (html.count) - 4) == "<br>" {
                html = (html as NSString).substring(to: (html.count) - 4)
                html = html + "</p>"
            } else if ((html as NSString).substring(from: (html.count) - 8) == "</p><br>") || ((html as NSString).substring(from: (html.count) - 8) == "<br></p>") {
                html = (html as NSString).substring(to: (html.count) - 8)
                html = html + "</p>"
            }
        }
        html = html.replacingOccurrences(of: "</p></p>", with: "</p>")
        html = html.replacingOccurrences(of: "</p><br><br><p>", with: "</p><br><p>")
        html = html.replacingOccurrences(of: "<br><br>", with: "<br>")
        
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(pattern: "\\s+<p>", options: [])
        } catch let error {
            print("Get style html error: \(error.localizedDescription)")
        }
        html = (regex?.stringByReplacingMatches(in: html, options: [], range: NSRange(location: 0, length: html.count), withTemplate: "<p>"))!
        
        return html
    }
    
    private func getEndTag(tag: String) -> String {
        var endTag = tag
        endTag.insert("/", at: endTag.index(after: endTag.startIndex))
        return endTag
    }
    
    private func getArrayOfHtmlStrings(text: String, fontSize: Int, listType: String) -> [String] {
        
        var result: [String] = []
        let pattern = "\(listType)((.|\n|\r)*)\(getEndTag(tag: listType))"
        var regex: NSRegularExpression? = nil
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch let error {
            print("Get array of html strings error: \(error.localizedDescription)")
        }
        let matches = regex?.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
        
        for i in 0..<(matches?.count ?? 0) {
            let currentMatchRange = matches?[i].range
            let thisListStartIndex = currentMatchRange?.location ?? 0
            let thisListEndIndex = (currentMatchRange?.location ?? 0) + (currentMatchRange?.length ?? 0)
            var nextMatchRange: NSRange
            var nextListStartIndex: Int = 0
            var nextListEndIndex: Int = 0
            if i != ((matches?.count ?? 0) - 1) {
                if let range = matches?[i + 1].range {
                    nextMatchRange = range
                    nextListStartIndex = nextMatchRange.location
                    nextListEndIndex = nextMatchRange.location + nextMatchRange.length
                }
                // adding first befor <ul> element
                if i == 0 && thisListStartIndex != 0 {
                    let headString = text[text.startIndex..<text.index(text.startIndex, offsetBy: thisListStartIndex)]
                    result.append(getStyledHtmlString(html: String(headString), fontSize: fontSize))
                }
                // adding <ul> element
                let listString = text[text.index(text.startIndex, offsetBy: thisListStartIndex)..<text.index(text.startIndex, offsetBy: thisListEndIndex)]
                result.append(getStyledHtmlString(html: String(listString), fontSize: fontSize))
                
                // Adding string after <ul> element
                if i == (matches!.count - 1) && thisListEndIndex != text.count {
                    let tailString = text[text.index(text.startIndex, offsetBy: thisListEndIndex)..<text.index(text.endIndex, offsetBy: 0)]
                    result.append(getStyledHtmlString(html: String(tailString), fontSize: fontSize))
                } else if i != (matches!.count - 1) && thisListEndIndex != nextListStartIndex {
                    let stringAfterListString = text[text.index(text.startIndex, offsetBy: thisListEndIndex)..<text.index(text.startIndex, offsetBy: nextListStartIndex)]
                    result.append(getStyledHtmlString(html: String(stringAfterListString), fontSize: fontSize))
                }
            }
        }
        return result
    }
}

