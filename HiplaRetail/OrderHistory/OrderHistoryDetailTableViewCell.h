//
//  OrderHistoryDetailTableViewCell.h
//  HiplaRetail
//
//  Created by fnspl3 on 21/02/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCatName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgCatView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@end
