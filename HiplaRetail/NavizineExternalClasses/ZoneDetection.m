//
//  ZoneDetection.m
//  HiplaStudent
//
//  Created by FNSPL on 14/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "ZoneDetection.h"

static ZoneDetection *sharedZone = nil;

@implementation ZoneDetection

+(ZoneDetection *) sharedZoneDetection {
    
    @synchronized([ZoneDetection class])
    {
        if (!sharedZone) {
            
            sharedZone = [[self alloc] init];
            
            sharedZone.delayInSeconds = 5.0;

            [sharedZone navigationTick:nil];
            [sharedZone navigineSetup];
            
        }
        return sharedZone;
    }
    
    return nil;
    
}

-(void)getZone{
    
//    NSString *url = [NSString stringWithFormat:@"https://api.navigine.com/zone_segment/getAll?userHash=C213-85E7-2265-3F4B&sublocationId=3845"];
    NSString *url = [NSString stringWithFormat:@"https://api.navigine.com/zone_segment/getAll?userHash=0F17-DAE1-4D0A-1778&sublocationId=3247"];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              
                                              NSLog(@"The response is - %@",responseDictionary);
                                              
                                              _zoneArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"zoneSegments"]];
                                              
                                              // [sharedZone navigineSetup];
                                          }
                                          else
                                          {
                                              NSLog(@"Error");
                                              
                                              [sharedZone performSelector:@selector(getZone) withObject:nil afterDelay:0.3];
                                          }
                                      }];
    
    [dataTask resume];
    
}

- (void) navigationTick: (NSTimer *)timer {
    
    if (_delegate) {
        
        [_delegate navigationTicker];
    }
    if (![_zoneArray count]) {
        
        [sharedZone getZone];
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sharedZone.delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        // Your code here
        if (_delegate) {
            
            [sharedZone navigationTick:nil];
            
        } else {
            
        }
        
        
    });
    
}

- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
    
    NSDictionary* zone = nil;
    
    if (_zoneArray) {
        
        NSArray* arrZone = [NSArray arrayWithArray:_zoneArray];
        for (NSInteger i = 0; i < [arrZone count]; i++) {
            
            NSDictionary* dicZone = [NSDictionary dictionaryWithDictionary:[arrZone objectAtIndex:i]];
            
            NSArray* coordinates = [NSArray arrayWithArray:[dicZone objectForKey:@"coordinates"]];
            
            if ([coordinates count]>0) {
                
                UIBezierPath* path = [[UIBezierPath alloc]init];
                
                for (NSInteger j=0; j < [coordinates count]; j++) {
                    
                    NSDictionary* dicCoordinate = [NSDictionary dictionaryWithDictionary:[coordinates objectAtIndex:j]];
                    
                    if ([[dicCoordinate allKeys] containsObject:@"kx"]) {
                        
                        float xPoint = (float)[[dicCoordinate objectForKey:@"kx"] floatValue];
                        float yPoint = (float)[[dicCoordinate objectForKey:@"ky"] floatValue];
                        
                        CGPoint point = CGPointMake(xPoint, yPoint);
                        
                        if (j == 0) {
                            
                            [path moveToPoint:point];
                            
                        } else {
                            
                            [path addLineToPoint:point];
                        }
                    }
                }
                
                [path closePath];
                
                if ([path containsPoint:currentPoint]) {
                    
                    zone = [NSDictionary dictionaryWithDictionary:dicZone];
                    
                    break;
                    
                } else {
                    
                    zone = nil;
                    
                }
            }
        }
        
    } else {
        
    }
    
    return zone;
}

- (void) navigineSetup {
    
    /*if (_navigineCore) {
        [_navigineCore stopNavigine];
        _navigineCore = nil;
    }*/
    
    if (!_navigineCore) {
        
        _navigineCore = [[NavigineCore alloc] initWithUserHash: @"0F17-DAE1-4D0A-1778"
                                                        server: @"https://api.navigine.com"];
    }
//    _navigineCore = [[NavigineCore alloc] initWithUserHash: @"0F17-DAE1-4D0A-1778"
//                                                    server: @"https://api.navigine.com"];
    
    _navigineCore.delegate = sharedZone;
    
    [_navigineCore downloadLocationByName:@"Future Netwings"
                              forceReload:NO
                             processBlock:^(NSInteger loadProcess) {
                                 NSLog(@"%zd",loadProcess);
                             } successBlock:^(NSDictionary *userInfo) {
                                 
                                 [_navigineCore startNavigine];
                                 [_navigineCore startPushManager];
                                                                  
                             } failBlock:^(NSError *error) {
                                 NSLog(@"%@",error);
                             }];
    
}
@end
