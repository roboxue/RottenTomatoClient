//
//  MovieViewController.swift
//  RottenTomatoes
//
//  Created by Robert Xue on 10/26/15.
//  Copyright © 2015 roboxue. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireImage

class MovieViewController: UIViewController {
    private var _backgroundImage: UIImageView!
    private var _synopsisSlider: UIScrollView!
    private var _blur: UIVisualEffectView!
    private var _synopsisBackgroundView: UIView!
    private var _titleLabel: UILabel!
    private var _ratingLabel: UILabel!
    private var _synopsisLabel: UILabel!
    var movie: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        view.addSubview(synopsisSlider)
        
        backgroundImage.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }

        let anchorView = UIView()
        view.addSubview(anchorView)
        anchorView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_topLayoutGuideBottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(snp_bottomLayoutGuideTop)
        }

        synopsisSlider.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(anchorView)
            make.left.equalTo(anchorView)
            make.right.equalTo(anchorView)
            make.bottom.equalTo(anchorView)
        }

        synopsisSlider.addSubview(synopsisBackgroundView)
        synopsisSlider.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(synopsisBackgroundView).offset(-400)
            make.left.equalTo(synopsisBackgroundView)
            make.right.equalTo(synopsisBackgroundView)
            make.bottom.equalTo(synopsisBackgroundView)
        }
        synopsisBackgroundView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(anchorView).offset(400)
            make.left.equalTo(anchorView).offset(RTSpan)
            make.right.equalTo(anchorView).offset(-RTSpan)
        }

        synopsisBackgroundView.addSubview(blur)
        synopsisBackgroundView.sendSubviewToBack(blur)
        blur.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(synopsisBackgroundView)
            make.left.equalTo(anchorView)
            make.right.equalTo(anchorView)
            make.bottom.equalTo(synopsisBackgroundView)
        }
        
        titleLabel.text = movie[RTTitle].stringValue
        ratingLabel.text = "audience: \(movie[RTRatings][RTAudienceScore].stringValue) critics: \(movie[RTRatings][RTCriticsScore].stringValue)"
        synopsisLabel.text = movie[RTSynopsis].stringValue
        title = movie[RTTitle].stringValue
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let thumbnailUrl = RottenTomatoDataSource.getPicUrl(movie[RTPosters][RTThumbnail].stringValue, highResolution: false)
        let originUrl = RottenTomatoDataSource.getPicUrl(movie[RTPosters][RTThumbnail].stringValue, highResolution: true)
        
        backgroundImage.af_setImageWithURL(NSURL(string: originUrl)!, placeholderImage: RTDataSource.getImageForUrl(thumbnailUrl))
    }
}

extension MovieViewController {
    var backgroundImage: UIImageView {
        if _backgroundImage == nil {
            _backgroundImage = UIImageView()
            _backgroundImage.contentMode = .ScaleToFill
        }
        return _backgroundImage
    }
    
    var synopsisSlider: UIScrollView {
        if _synopsisSlider == nil {
            _synopsisSlider = UIScrollView()
            _synopsisSlider.scrollEnabled = true
        }
        return _synopsisSlider
    }
    
    var blur: UIVisualEffectView {
        if _blur == nil {
            _blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        }
        return _blur
    }

    var synopsisBackgroundView: UIView {
        if _synopsisBackgroundView == nil {
            let stackView = UIStackView(arrangedSubviews: [titleLabel, ratingLabel, synopsisLabel])
            stackView.axis = .Vertical
            stackView.distribution = .EqualSpacing
            stackView.spacing = CGFloat(RTSpan)
            stackView.alignment = .Leading
            _synopsisBackgroundView = stackView
        }
        return _synopsisBackgroundView
    }
    
    var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel.font = RTTitleFontBold
            _titleLabel.textColor = RTPrimaryTextColor
        }
        return _titleLabel
    }
    
    var ratingLabel: UILabel {
        if _ratingLabel == nil {
            _ratingLabel = UILabel()
            _ratingLabel.font = RTContentFont
            _ratingLabel.textColor = RTPrimaryTextColor
        }
        return _ratingLabel
    }
    
    var synopsisLabel: UILabel {
        if _synopsisLabel == nil {
            _synopsisLabel = UILabel()
            _synopsisLabel.font = RTContentFont
            _synopsisLabel.numberOfLines = 0
            _synopsisLabel.lineBreakMode = .ByWordWrapping
            _synopsisLabel.textColor = RTPrimaryTextColor
        }
        return _synopsisLabel
    }
}
