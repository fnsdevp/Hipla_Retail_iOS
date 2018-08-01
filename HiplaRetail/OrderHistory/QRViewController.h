//
//  QRViewController.h
//  Jing
//
//  Created by fnspl3 on 22/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property NSString *orderUniqueIdStr;
@property NSMutableArray *orderhistoryDetailsArr;
@property (weak, nonatomic) IBOutlet UITableView *tblOrdDetails;


@end
