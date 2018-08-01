//
//  SubCategoryCollectionViewCell.h
//  Jing
//
//  Created by fnspl3 on 12/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsynccronusImageView;
@interface SubCategoryCollectionViewCell:UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblSubName;
@property (weak, nonatomic) IBOutlet UILabel *lblEach;
@property (weak, nonatomic) IBOutlet UILabel *lblOriginalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblRupees;
@property (weak, nonatomic) IBOutlet UILabel *lblNavigate;
@property (weak, nonatomic) IBOutlet UIView *boderView;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigateOutlet;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;




@property (weak, nonatomic) IBOutlet AsynccronusImageView* productImgView;

@property (strong, nonatomic) NSString* productName;
@property (strong, nonatomic) NSString* rupees;
@property (strong, nonatomic) NSString* productImgUrl;
@property (strong, nonatomic) NSAttributedString* originalPrice;


- (void)updateCell;
@end
