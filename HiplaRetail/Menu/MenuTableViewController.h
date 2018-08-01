//
//  MenuTableViewController.h
//  Jing
//
//  Created by FNSPL on 14/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewCell.h"
#import "NSDictionary+NullReplacement.h"
#import "APIManager.h"

@class KYDrawerController;
@interface MenuTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    APIManager *api;
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
}

@property (weak,nonatomic) IBOutlet UITableView *tblMenu;
@property (retain, nonatomic) NSArray *browseListArray;
@property (retain, nonatomic) NSArray *browseimageArray;

@property (retain, nonatomic) NSArray *forUArray;
@property (retain, nonatomic) NSArray *forUimageArray;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) KYDrawerController *elDrawer;

- (IBAction)btnProfile:(id)sender;


@end
