//
//  ProductCategoryCollectionViewCell.m
//  Jing
//
//  Created by fnspl3 on 13/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ProductCategoryCollectionViewCell.h"
#import "AsynccronusImageView.h"

@implementation ProductCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCell {
    
    [self.lblProductName setText:_productName];
    [_productImgView loadImageWithImgUrl:_productImgUrl];
    
}

@end
