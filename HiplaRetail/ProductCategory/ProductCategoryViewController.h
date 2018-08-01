//
//  ProductCategoryViewController.h
//  Jing
//
//  Created by fnspl3 on 13/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JScrollView+PageControl+AutoScroll.h"
#import "ProductCategoryCollectionViewCell.h"
#import "NSDictionary+NullReplacement.h"
#import "ViewController.h"
#import "MenuTableViewController.h"
#import "MapPin.h"
#import "ZoneDetection.h"

@interface ProductCategoryViewController : ViewController<JScrollViewViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,sharedZoneDetectionDelegate>{
    BOOL isclicked;
    APIManager *api;
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
    
//    NCSublocation *sub;
//
//    NCBeacon *beaconM;
//    NCBeacon *beacon1;
//    NCBeacon *beacon2;
//For search
    
    BOOL isDataAvailable;
    
}

//@property CMMotionManager *motionManager;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (nonatomic, strong) NSArray *zoneArray;
@property (nonatomic, strong) NSString* currentZoneName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIImageView *current;

@property (retain, nonatomic) NSArray *banners;

@property (weak, nonatomic) IBOutlet UIScrollView *vwScroll;
@property (weak, nonatomic) IBOutlet UIView *vwPaging;
@property (weak, nonatomic) IBOutlet UICollectionView *productCategoryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblSortbyCategory;
@property (weak, nonatomic) IBOutlet UIView *searchView;

- (IBAction)btnQuickCheckout:(id)sender;
- (IBAction)btnIndoorNav:(id)sender;
- (IBAction)btnAddtoCart:(id)sender;

//For Search
- (IBAction)searchOnTermEntered:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtFieldSearch;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (weak, nonatomic) IBOutlet UIView *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
