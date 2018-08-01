//
//  SubCategoryViewController.h
//  Jing
//
//  Created by fnspl3 on 12/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "JScrollView+PageControl+AutoScroll.h"
#import "ProductCategoryCollectionViewCell.h"
#import "NSDictionary+NullReplacement.h"
#import "MenuTableViewController.h"
#import "MapPin.h"
#import "APIManager.h"
#import "ZoneDetection.h"

@class IndoorMapViewController;
@interface SubCategoryViewController : ViewController<UICollectionViewDataSource,UICollectionViewDelegate,sharedZoneDetectionDelegate>{
    
    APIManager *api;
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
    int number;
    int totalCount;
}

@property (weak, nonatomic) IBOutlet UICollectionView *subcategoryCollectionView;
@property (nonatomic, strong) NSMutableArray* subCatlistInfo;
@property (weak, nonatomic) IBOutlet UIView *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@property (nonatomic, strong) NSString* currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;

@property (nonatomic, strong) IndoorMapViewController *indoorMapScreen;

- (IBAction)menuBtn:(id)sender;
- (IBAction)addToCart:(id)sender;
- (IBAction)searchBtn:(id)sender;
- (IBAction)homeBtn:(id)sender;


@end
