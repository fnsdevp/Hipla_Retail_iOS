//
//  ZoneDetection.h
//  HiplaStudent
//
//  Created by FNSPL on 14/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MapPin.h"
#import "Constants.h"

@class NavigineCore;

@protocol sharedZoneDetectionDelegate
@optional

//-(void)enterZoneWithZoneName:(NSString *)zoneName;
//-(void)exitZoneWithZoneName:(NSString *)zoneName;
- (void) navigationTicker;
@end

@interface ZoneDetection : NSObject <NavigineCoreDelegate>

+(ZoneDetection *) sharedZoneDetection;
- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint;
- (void) navigineSetup;
- (void) navigationTick: (NSTimer *)timer;

@property (nonatomic, strong) id <sharedZoneDetectionDelegate> delegate;
@property (nonatomic, strong) NavigineCore *navigineCore;

@property (nonatomic, strong) NSString *currentZoneName;
@property (nonatomic, strong) NSArray *zoneArray;

@property (nonatomic, assign) BOOL isAbc;
@property (nonatomic, assign) double delayInSeconds;

@end
