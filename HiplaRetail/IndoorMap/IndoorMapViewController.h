//
//  IndoorMapViewController.h
//  SmartOffice
//
//  Created by FNSPL on 30/01/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MapPin.h"
#import "APIManager.h"
#import "ZoneDetection.h"
#import "ViewController.h"

@interface IndoorMapViewController : ViewController<UIScrollViewDelegate, sharedZoneDetectionDelegate>{
    
    APIManager *api;
    BOOL isNavigationRouteOn;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;
@property (nonatomic, strong) NSArray *zoneArray;
@property (nonatomic, strong) UIImageView *current;
@property (strong, nonatomic) IBOutlet UILabel *calculate;
@property (nonatomic, strong) NSString* currentZoneName;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (nonatomic, strong) NSString *isMenu;

- (IBAction)btnBack:(id)sender;

///////////////////////////////////////////from product details class
@property NSString* zoneId;
@property NSString* productId;

//////////////////////////////////////////

@end
