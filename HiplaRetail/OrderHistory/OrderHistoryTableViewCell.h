//
//  OrderHistoryTableViewCell.h
//  Jing
//
//  Created by fnspl3 on 22/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOrderID;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRupees;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderStatus;

@end
