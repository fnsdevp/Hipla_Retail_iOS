//
//  ZoneDetails.m
//  HiplaRetail
//
//  Created by fnspl3 on 29/03/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "ZoneDetails.h"

struct ZoneInfo
{
//    NSString* zoneName;
//    NSString* zoneId;
//    BOOL isNotify;
    
} zoneInfo;

static ZoneDetails *sharedZoneDetails = nil;

@implementation ZoneDetails

+(ZoneDetails *) sharedZoneDetails {
    
    @synchronized([ZoneDetails class])
    {
        if (!sharedZoneDetails) {
            
            sharedZoneDetails = [[self alloc] init];
            
        }
        
        return sharedZoneDetails;
    }
    
    return nil;
    
}

- (BOOL)notifyZoneWithZoneName:(NSString *)zoneName ZoneId:(NSString *)zoneId {
    
    BOOL isNotify = NO;
    if (!_zones) {
        
        _zones = [NSMutableArray array];
    } else {
        
    }
    
    NSPredicate *hasZonePred = [NSPredicate predicateWithFormat:
                              @"zoneId == %@",zoneId];
    NSArray *hasZones = [_zones filteredArrayUsingPredicate:hasZonePred];
    if (hasZones && [hasZones count]) {
        
        NSMutableDictionary* dic = [hasZones firstObject];
        NSNumber* notify = [dic objectForKey:@"isNotify"];
        _isNotify = [notify boolValue];
        
        NSNumber* enterZoneCount = [dic objectForKey:@"enterZoneCount"];
        NSInteger zoneCount = [enterZoneCount integerValue];
        zoneCount++;
        [dic setObject:[NSNumber numberWithInteger:zoneCount] forKey:@"enterZoneCount"];
        
        if (zoneCount >= 1 && !_isNotify) {
            
            isNotify = YES;
            _isNotify = YES;
            [dic setObject:[NSNumber numberWithBool:_isNotify] forKey:@"isNotify"];
            
        } else {
            
            isNotify = NO;
        }
        
    } else {

        _isNotify = NO;
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:zoneName forKey:@"zoneName"];
        [dic setObject:zoneId forKey:@"zoneId"];
        [dic setObject:[NSNumber numberWithBool:_isNotify] forKey:@"isNotify"];
        [dic setObject:[NSNumber numberWithInteger:1] forKey:@"enterZoneCount"];
        
        [_zones addObject:dic];
        
        isNotify = NO;
    }
    
    return isNotify;
}

@end
