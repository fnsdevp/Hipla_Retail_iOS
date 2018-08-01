//
//  OrderHistoryViewController.h
//  Jing
//
//  Created by fnspl3 on 22/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "ViewController.h"
#import "NSDictionary+NullReplacement.h"
#import "MenuTableViewController.h"

@interface OrderHistoryViewController : ViewController<UITableViewDataSource,UITableViewDelegate>{
    
    APIManager *api;
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
    
}
- (IBAction)addToCart:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOrderHistory;
- (IBAction)btnJing:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@end
