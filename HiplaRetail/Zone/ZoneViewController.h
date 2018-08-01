//
//  ZoneViewController.h
//  Jing
//
//  Created by fnspl3 on 04/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "NSDictionary+NullReplacement.h"
#import "MenuTableViewController.h"


@interface ZoneViewController : ViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    APIManager *api;
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
}
@property (weak, nonatomic) IBOutlet UICollectionView *subcategoryCollectionView;
//@property NSMutableArray* favoriteProductlistInfo;
@property (weak, nonatomic) IBOutlet UIView *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (strong, nonatomic) NSDictionary *discountlist;

- (IBAction)menuBtn:(id)sender;
- (IBAction)addToCart:(id)sender;
- (IBAction)searchBtn:(id)sender;
- (IBAction)homeBtn:(id)sender;

@end
