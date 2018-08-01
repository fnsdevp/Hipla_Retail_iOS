//
//  SubCategoryCollectionViewCell.m
//  Jing
//
//  Created by fnspl3 on 12/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "SubCategoryCollectionViewCell.h"
#import "AsynccronusImageView.h"
@implementation SubCategoryCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
    
    _mainView.layer.cornerRadius = 5.0f;
    self.mainView.clipsToBounds = YES;
    
    CGRect frame = _boderView.bounds;
    frame.size.height += 0.1f;
    frame.size.width += self.boderView.frame.size.width;
    _boderView.bounds = frame;
    
}
- (void)updateCell {
    
    [self.lblSubName setText:_productName];
    [self.lblRupees setText:_rupees];
    [self.lblOriginalPrice setAttributedText:_originalPrice];
    [_productImgView loadImageWithImgUrl:_productImgUrl];
    
    
}

@end
