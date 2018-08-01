//
//  ProductbycatViewController.h
//  Jing
//
//  Created by fnspl3 on 20/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "NSDictionary+NullReplacement.h"
#import "MenuTableViewController.h"
#import "MapPin.h"
#import "APIManager.h"
#import "ZoneDetection.h"

@interface ProductbycatViewController :ViewController<UICollectionViewDataSource,UICollectionViewDelegate,sharedZoneDetectionDelegate>{
    
    APIManager *api;
    KYDrawerController *drawer;
    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
}

@property (weak, nonatomic) IBOutlet UICollectionView *subcategoryCollectionView;
@property NSMutableArray* productbyCatlistInfo;
@property (weak, nonatomic) IBOutlet UIView *viewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@property (nonatomic, strong) NSString* currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;

- (IBAction)menuBtn:(id)sender;
- (IBAction)addToCart:(id)sender;
- (IBAction)searchBtn:(id)sender;
- (IBAction)homeBtn:(id)sender;

@end
