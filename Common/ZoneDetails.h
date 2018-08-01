//
//  ZoneDetails.h
//  HiplaRetail
//
//  Created by fnspl3 on 29/03/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoneDetails : NSObject

+(ZoneDetails *) sharedZoneDetails;

@property (nonatomic, assign) BOOL isNotify;

@property (nonatomic, strong) NSMutableArray* zones;

- (BOOL)notifyZoneWithZoneName:(NSString *)zoneName ZoneId:(NSString *)zoneId;

@end
