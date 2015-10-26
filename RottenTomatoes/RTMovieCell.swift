//
//  RTMovieCell.swift
//  RottenTomatoes
//
//  Created by Robert Xue on 10/25/15.
//  Copyright © 2015 roboxue. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class RTMovieCell: UITableViewCell {
    private var _thumbnailView: UIImageView!
    private var _titleLabel: UILabel!
    private var _mpaaRatingLabel: UILabel!
    
    func withMovie(movie: JSON) {
        let thumbnailUrl = RottenTomatoDataSource.getPicUrl(movie[RTPosters][RTThumbnail].stringValue, highResolution: false)
        let originUrl = RottenTomatoDataSource.getPicUrl(movie[RTPosters][RTThumbnail].stringValue, highResolution: true)
        debugPrint(thumbnailUrl)
        thumbnailView.af_setImageWithURL(NSURL(string: thumbnailUrl)!, placeholderImage: RTPlaceholderImage, filter: nil, imageTransition: .None) { (response) -> Void in
            self.thumbnailView.af_setImageWithURL(NSURL(string: originUrl)!)
        }
        titleLabel.text = movie[RTTitle].stringValue
        let mpaaRating = movie[RTMPAARating].stringValue
        let synopsis = movie[RTSynopsis].stringValue
        let content = NSMutableAttributedString(string: mpaaRating + " " + synopsis)
        content.addAttribute(NSFontAttributeName, value: RTContentFontBold, range: NSMakeRange(0, mpaaRating.characters.count))
        contentLabel.attributedText = content
        
    }
}

extension RTMovieCell {
    var thumbnailView: UIImageView {
        if _thumbnailView == nil {
            _thumbnailView = UIImageView(image: RTPlaceholderImage)
            _thumbnailView.contentMode = .ScaleAspectFit
            addSubview(_thumbnailView)
            _thumbnailView.snp_remakeConstraints(closure: { (make) -> Void in
                make.left.equalTo(self).offset(RTSpan)
                make.width.equalTo(RTMovieImageWidth)
                make.height.equalTo(RTMovieImageHeight)
            })
        }
        return _thumbnailView
    }
    
    var titleLabel: UILabel {
        if _titleLabel == nil {
            let label = UILabel()
            label.font = RTTitleFont
            addSubview(label)
            label.snp_remakeConstraints(closure: { (make) -> Void in
                make.left.equalTo(thumbnailView.snp_right).offset(RTSpan)
                make.top.equalTo(self).offset(RTSpan)
                make.height.equalTo(21)
            })
            _titleLabel = label
        }
        return _titleLabel
    }
    
    var contentLabel: UILabel {
        if _mpaaRatingLabel == nil {
            let label = UILabel()
            addSubview(label)
            label.numberOfLines = 0
            label.lineBreakMode = .ByTruncatingTail
            label.adjustsFontSizeToFitWidth = false
            label.snp_remakeConstraints(closure: { (make) -> Void in
                make.left.equalTo(thumbnailView.snp_right).offset(RTSpan)
                make.top.equalTo(titleLabel.snp_bottom).offset(2 * RTSpan)
                make.right.equalTo(self).offset(-RTSpan)
                make.bottom.equalTo(self).offset(-RTSpan)
            })
            _mpaaRatingLabel = label
        }
        return _mpaaRatingLabel
    }
}
