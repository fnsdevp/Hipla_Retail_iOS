//
//  YourCartTableViewCell.h
//  Jing
//
//  Created by fnspl3 on 11/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YourCartTableViewCellDelegate
@optional
// list of optional methods
- (void)plusBtnAction:(id)sender;
- (void)minusBtnAction:(id)sender;
- (void)deleteBtnAction:(id)sender;
@end

@interface YourCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblRupees;
@property (weak, nonatomic) IBOutlet UILabel *lblEach;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) IBOutlet UIButton *minusBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *plusBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtnOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;
@property (weak, nonatomic) IBOutlet UIButton *btnPlusOutlet;
@property (weak, nonatomic) IBOutlet UIButton *btnMinusOutlet;
@property (strong, nonatomic) NSMutableDictionary* prdDict;
@property (nonatomic, weak) id <YourCartTableViewCellDelegate> delegate;

@property (nonatomic, assign) NSInteger productPrice;

@end
