//
//  ProductCategoryCollectionViewCell.h
//  Jing
//
//  Created by fnspl3 on 13/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AsynccronusImageView;
@interface ProductCategoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet AsynccronusImageView* productImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;

@property (strong, nonatomic) NSString* productName;
@property (strong, nonatomic) NSString* productImgUrl;

- (void)updateCell;

@end
