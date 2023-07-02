//
//  XMMContentBlock1TableViewCell.swift
//  XamoomSDKExamle
//
//  Created by Ivan Magda on 03.05.2023.
//

import UIKit

class XMMContentBlock1TableViewCell: UITableViewCell, XMMMediaFileDelegate {
    
    @IBOutlet weak var audioPlayerView: UIView?
    @IBOutlet weak var artistLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var remainingTimeLabel: UILabel?
    @IBOutlet weak var audioControlButton: UIButton?
    @IBOutlet weak var forwardButton: UIButton?
    @IBOutlet weak var backwardButton: UIButton?
    @IBOutlet weak var backwardLabel: UILabel?
    @IBOutlet weak var forwardLabel: UILabel?
    @IBOutlet weak var movingBarView: XMMMovingBarsView?
    @IBOutlet weak var progressBar: XMMProgressBar?
    
    var playImage: UIImage?
    var pauseImage: UIImage?
    var playing: Bool = false
    var mediaFile: XMMMediaFile?
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pauseAllXMMMusicPlayer),
                                               name: Notification.Name("pauseAllSounds"),
                                               object: nil)
        
        setupImage()
        audioControlButton?.setImage(playImage, for: .normal)
        audioControlButton?.tintColor = UIColor.black
        
        forwardButton?.setImage(forwardButton?.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        forwardButton?.tintColor = UIColor.black
        
        backwardButton?.setImage(backwardButton?.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        backwardButton?.tintColor = UIColor.black
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressBar?.lineProgress = 0.0
        mediaFile?.delegate = nil
        movingBarView?.stop()
        audioControlButton?.setImage(playImage, for: .normal)
    }
    
    private func setupImage() {
        let bundle = Bundle(for: type(of: self))
        var imageBundle: Bundle?
        if let url = bundle.url(forResource: "XamoomSDK", withExtension: "bundle") {
            imageBundle = Bundle(url: url)
        } else {
            imageBundle = bundle
        }
        playImage = UIImage(named: "playbutton", in: imageBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        pauseImage = UIImage(named: "pausebutton", in: imageBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }
    
    func configureForCell(block: XMMContentBlock, tabelView: UITableView, indexPath: IndexPath, style: XMMStyle) {
        titleLabel!.text = block.title
        artistLabel!.text = block.artists
        
        guard let fileID = block.fileID else {
            return
        }
        let url = URL(string: fileID)
        
        mediaFile = 
    }
    
    //MARK: - Notification Handler
    
    @objc private func pauseAllXMMMusicPlayer() {
        movingBarView!.stop()
        playing = false
    }
    
    
    
}
