//
//  IndoorMapViewController.m
//  SmartOffice
//
//  Created by FNSPL on 30/01/17.
//  Copyright © 2017 FNSPL. All rights reserved.
//

#import "IndoorMapViewController.h"
#import "Common.h"
#import "ZoneDetails.h"

@interface IndoorMapViewController (){
    
    NSString *zoneIdStr;
    NSString *userId;
    BOOL isDrawZone;
    int i;
    
}

@property (nonatomic, strong) UIBezierPath   *uipath;
@property (nonatomic, strong) CAShapeLayer   *routeLayer;

@property (nonatomic, strong) MapPin *pressedPin;
@property (nonatomic, assign) BOOL isRouting;
@property (nonatomic, strong) NavigineCore *navigineCore;
@property (nonatomic, strong) NSMutableArray *arrNames;
@property (nonatomic, strong) NSMutableArray *arrPointx;
@property (nonatomic, strong) NSMutableArray *arrPointy;
@property (nonatomic, strong) NSDictionary *ProfInfo;
@property (nonatomic, assign) BOOL isDrawingPath;

@end


@implementation IndoorMapViewController

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setHidden:YES];
    
    self.ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%@",[self.ProfInfo objectForKey:@"id"]];
    
    NSLog(@"USERID==%@",userId);
    
    NSLog(@"zoneId==%@",_zoneId);
    
    api = [APIManager sharedManager];
    
    _calculate.hidden = YES;
    
//    self.arrNames = [[NSMutableArray alloc] initWithObjects:@"conference area",@"marketing room",@"Developers 1",@"conference room small",@"Developers 2",@"service desk",nil];

//    self.arrPointx = [[NSMutableArray alloc] initWithObjects:@"22.63",@"13.38",@"13.18",@"15.53",@"13.32",@"13.83", nil];
//
//    self.arrPointy = [[NSMutableArray alloc] initWithObjects:@"20.00",@"12.40",@"26.75",@"39.21",@"21.60",@"32.51", nil];


    self.arrNames = [[NSMutableArray alloc] initWithObjects:@"conference room small",@"service desk",@"Developers 1",@"conference area",@"Developers 2",@"marketing room",nil];

    
    self.arrPointx = [[NSMutableArray alloc] initWithObjects:@"14.19",@"14.42",@"11.81",@"22.43",@"11.53",@"14.23", nil];
    
    self.arrPointy = [[NSMutableArray alloc] initWithObjects:@"39.24",@"34.25",@"26.63",@"19.69",@"21.31",@"12.20", nil];
//    [Userdefaults setObject:self.arrNames forKey:@"arrzoneName"];
    
//    [Userdefaults synchronize];
    
//    [[ZoneDetection sharedZoneDetection] navigineSetup];
    
    self.isMenu = [Userdefaults objectForKey:@"isMenu"];
    
    if ([self.isMenu isEqualToString:@"true"])
    {
        /*UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Welcome to CXC, your nativation is starting."
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
//                                     [self navigateForProduct];
                                     
                                 });
                                 
                             }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];*/
        /*if ([[ZoneDetection sharedZoneDetection] delegate] == self) {
            
        } else {
            
            [[ZoneDetection sharedZoneDetection] setDelayInSeconds:2];
            [[ZoneDetection sharedZoneDetection] setDelegate:self];
            [[ZoneDetection sharedZoneDetection] navigationTick:nil];
        }*/
        
    }
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    [[ZoneDetection sharedZoneDetection] navigationTick:nil];
    [[ZoneDetection sharedZoneDetection] navigineSetup];
    [self loadMap];
//    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
//    [self zoneDetection];
    
   // [self navigationStart];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    /*UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Welcome to CXC, your nativation is starting."
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             dispatch_async(dispatch_get_main_queue(), ^{

//                                [self navigateForProduct];

                             });

                         }];

    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];*/

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
//    [_imageView removeAllSubviews];
    /*if ([[ZoneDetection sharedZoneDetection] delegate] == self) {
        
    } else {
        
        [[ZoneDetection sharedZoneDetection] setDelayInSeconds:2];
        [[ZoneDetection sharedZoneDetection] setDelegate:self];
        [[ZoneDetection sharedZoneDetection] navigationTick:nil];
    }*/
    
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
}

- (void)loadMap {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!_imageView.image) {
            
            _sv.delegate = self;
            _sv.pinchGestureRecognizer.enabled = YES;
            _sv.minimumZoomScale = 1.f;
            _sv.zoomScale = 1.f;
            _sv.maximumZoomScale = 2.f;
            
            //            [_sv addSubview:_imageView];
            
            // Point on map
            
            _current = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            _current.backgroundColor = [UIColor redColor];
            _current.layer.cornerRadius = _current.frame.size.height/2.f;
            
            [_imageView addSubview:_current];
            _imageView.userInteractionEnabled = YES;
            
            _isRouting = NO;
            
            NSData *pngData = [NSData dataWithContentsOfFile:[[Common sharedCommon] indorMapImagePath]];
            UIImage *image = [UIImage imageWithData:pngData];
            if (image) {
                
                //                _imageView.layer.sublayers = nil;
                //                [_imageView addSubview:_current];
                
                float scale = 1.f;
                
                if (image.size.width / image.size.height >
                    self.view.frame.size.width / self.view.frame.size.height) {
                    scale = self.view.frame.size.height / image.size.height;
                }
                else {
                    scale = self.view.frame.size.width / image.size.width;
                }
                
                _imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
                _imageView.image = image;
                _sv.contentSize = _imageView.frame.size;
                
                //                [self drawZones];
                //
                //                [self performSelector:@selector(navigateForProduct) withObject:nil afterDelay:0.3];
                
            } else {
                
            }
            
        } else {
            
        }
        
    });
}
/*
-(void)zoneDetection
{
    BOOL Maploaded = [Userdefaults boolForKey:@"Maploaded"];
    
    if (Maploaded) {
        
        [self getZone];
    }
    else
    {
        [self performSelector:@selector(zoneDetection) withObject:nil afterDelay:2.0];
    }
}

-(void)getZone{
    
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
            
            [self navigationStart];
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    
    [dataTask resume];
    
}*/

-(void)navigationStart
{
//    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
    //    _sv.frame = self.view.frame;
    //    self.view.frame = CGRectMake(0, self.firstView.frame.origin.y+self.firstView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    // _sv.frame = self.view.frame;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!_imageView.image) {
            
            _sv.delegate = self;
            _sv.pinchGestureRecognizer.enabled = YES;
            _sv.minimumZoomScale = 1.f;
            _sv.zoomScale = 1.f;
            _sv.maximumZoomScale = 2.f;
            
//            [_sv addSubview:_imageView];
            
            // Point on map
            if (_current) {
                [_current removeFromSuperview];
                _current = nil;
            } else {
                
            }
            _current = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            _current.backgroundColor = [UIColor redColor];
            _current.layer.cornerRadius = _current.frame.size.height/2.f;
            
            [_imageView addSubview:_current];
            _imageView.userInteractionEnabled = YES;
            
            _isRouting = NO;
            
            NSData *pngData = [NSData dataWithContentsOfFile:[[Common sharedCommon] indorMapImagePath]];
            UIImage *image = [UIImage imageWithData:pngData];
            if (image) {
                
//                [_imageView removeAllSubviews];
                
//                _imageView.layer.sublayers = nil;
                [_imageView addSubview:_current];
                
                float scale = 1.f;
                
                if (image.size.width / image.size.height >
                    self.view.frame.size.width / self.view.frame.size.height) {
                    scale = self.view.frame.size.height / image.size.height;
                }
                else {
                    scale = self.view.frame.size.width / image.size.width;
                }
                
                _imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
                _imageView.image = image;
                _sv.contentSize = _imageView.frame.size;
                
//                [self drawZones];
                
            } else {
             
                [self setupNavigine];
            }
            
        } else {
            
        }
        
    });
    
}

-(void) setupNavigine {

//    [_imageView removeAllSubviews];
    
//    _imageView.layer.sublayers = nil;
//    [_imageView addSubview:_current];
    
    //    [self presentViewController:_navigineCore.location.viewController animated:YES completion:nil];
    
    NCLocation *location = [ZoneDetection sharedZoneDetection].navigineCore.location;
    if ([location.sublocations count]) {
        
        NCSublocation *sublocation = location.sublocations[0];
//        NSData *imageData = sublocation.pngImage;
        UIImage *image = sublocation.image;//[UIImage imageWithData:imageData];
        if (image) {
            
            NSData *pngData = UIImagePNGRepresentation(image);
            NSString *filePath = [[Common sharedCommon] indorMapImagePath];
            [pngData writeToFile:filePath atomically:YES]; //Write the file
            
        } else {
            
        }
        
        float scale = 1.f;
        
        if (image.size.width / image.size.height >
            self.view.frame.size.width / self.view.frame.size.height) {
            scale = self.view.frame.size.height / image.size.height;
        }
        else {
            scale = self.view.frame.size.width / image.size.width;
        }
        
        _imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
        _imageView.image = image;
        _sv.contentSize = _imageView.frame.size;
        
    }
    
        [self drawZones];
}

-(IBAction)select:(id)sender
{
    [self navigateForProduct];
}

-(void)enterZoneWithZoneName:(NSString *)zoneName {
    
   // int zoneInt = (int)[_zoneId integerValue];
    
   // NSString *StrzoneName =  [self.arrNames objectAtIndex:(zoneInt - 1)];
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"] && [_zoneId isEqualToString:@"4"]) {
          
            [self zoneByUser];
            [self getDiscount];
            
            if ([[ZoneDetails sharedZoneDetails] notifyZoneWithZoneName:zoneName ZoneId:_zoneId]) {
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = @"do you need any asistance?";
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                //   notification.applicationIconBadgeNumber = 1;
                
                notification.repeatInterval=0;
                
                //                [Userdefaults setBool:YES forKey:@"isEntry"];
                //
                //                [Userdefaults synchronize];
                //
                //                _zoneId = @"";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            } else {
                
            }
            
     
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date];
//            notification.alertBody = @"Checkout the deals for you";
//            notification.timeZone = [NSTimeZone localTimeZone];
//            notification.userInfo = dict;
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            //   notification.applicationIconBadgeNumber = 1;
//
//            notification.repeatInterval=0;
//
//             _zoneId = @"";
//
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
           // [self getZoneIn];
            
            
            
        } else if ([zoneName isEqualToString:@"marketing room"] &&[_zoneId isEqualToString:@"6"]) {
            
//            NSDictionary *dict = [NSDictionary dictionaryWithObject:_zoneId forKey:@"ZoneIdInfo"];
//
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date];
//            notification.alertBody = @"Checkout the deals for you";
//            notification.timeZone = [NSTimeZone localTimeZone];
//            notification.userInfo = dict;
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            //   notification.applicationIconBadgeNumber = 1;
//
//            notification.repeatInterval=0;
//
//             _zoneId = @"";
//
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
          //  [self getZoneIn];
            [self zoneByUser];
            [self getDiscount];
            
            if ([[ZoneDetails sharedZoneDetails] notifyZoneWithZoneName:zoneName ZoneId:_zoneId]) {
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = @"do you need any asistance?";
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                //   notification.applicationIconBadgeNumber = 1;
                
                notification.repeatInterval=0;
                
                //                [Userdefaults setBool:YES forKey:@"isEntry"];
                //
                //                [Userdefaults synchronize];
                //
                //                _zoneId = @"";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            } else {
                
            }
            
            
        }
        else if ([zoneName isEqualToString:@"Developers 1"] &&[_zoneId isEqualToString:@"3"]) {
            
//            NSDictionary *dict = [NSDictionary dictionaryWithObject:_zoneId forKey:@"ZoneIdInfo"];
//
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date];
//            notification.alertBody = @"Checkout the deals for you";
//            notification.timeZone = [NSTimeZone localTimeZone];
//            notification.userInfo = dict;
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            //   notification.applicationIconBadgeNumber = 1;
//
//            notification.repeatInterval=0;
//
//             _zoneId = @"";
//
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
          //  [self getZoneIn];
            [self zoneByUser];
            [self getDiscount];
            
            if ([[ZoneDetails sharedZoneDetails] notifyZoneWithZoneName:zoneName ZoneId:_zoneId]) {
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = @"do you need any asistance?";
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                //   notification.applicationIconBadgeNumber = 1;
                
                notification.repeatInterval=0;
                
                //                [Userdefaults setBool:YES forKey:@"isEntry"];
                //
                //                [Userdefaults synchronize];
                //
                //                _zoneId = @"";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            } else {
                
            }
            
            
        }
        else if ([zoneName isEqualToString:@"conference room small"] &&[_zoneId isEqualToString:@"1"]) {
            
//            NSDictionary *dict = [NSDictionary dictionaryWithObject:_zoneId forKey:@"ZoneIdInfo"];
//
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date];
//            notification.alertBody = @"Checkout the deals for you";
//            notification.timeZone = [NSTimeZone localTimeZone];
//            notification.userInfo = dict;
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            //   notification.applicationIconBadgeNumber = 1;
//
//            notification.repeatInterval=0;
//
//             _zoneId = @"";
//
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
           // [self getZoneIn];
            [self zoneByUser];
            [self getDiscount];
            
            if ([[ZoneDetails sharedZoneDetails] notifyZoneWithZoneName:zoneName ZoneId:_zoneId]) {
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = @"do you need any asistance?";
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                //   notification.applicationIconBadgeNumber = 1;
                
                notification.repeatInterval=0;
                
                //                [Userdefaults setBool:YES forKey:@"isEntry"];
                //
                //                [Userdefaults synchronize];
                //
                //                _zoneId = @"";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            } else {
                
            }
            
            
        }
        else if ([zoneName isEqualToString:@"Developers 2"] && [_zoneId isEqualToString:@"5"]) {
            
//            NSDictionary *dict = [NSDictionary dictionaryWithObject:_zoneId forKey:@"ZoneIdInfo"];
//
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date];
//            notification.alertBody = @"Checkout the deals for you";
//            notification.timeZone = [NSTimeZone localTimeZone];
//            notification.userInfo = dict;
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            //   notification.applicationIconBadgeNumber = 1;
//
//            notification.repeatInterval=0;
//
//             _zoneId = @"";
//
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
           // [self getZoneIn];
            [self zoneByUser];
            [self getDiscount];
            
            if ([[ZoneDetails sharedZoneDetails] notifyZoneWithZoneName:zoneName ZoneId:_zoneId]) {
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = @"do you need any asistance?";
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                //   notification.applicationIconBadgeNumber = 1;
                
                notification.repeatInterval=0;
                
                //                [Userdefaults setBool:YES forKey:@"isEntry"];
                //
                //                [Userdefaults synchronize];
                //
                //                _zoneId = @"";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            } else {
                
            }
            
        }
        else if ([zoneName isEqualToString:@"service desk"] && [_zoneId isEqualToString:@"2"]) {
    
//            NSDictionary *dict = [NSDictionary dictionaryWithObject:_zoneId forKey:@"ZoneIdInfo"];
//
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date];
//            notification.alertBody = @"Checkout the deals for you";
//            notification.timeZone = [NSTimeZone localTimeZone];
//            notification.userInfo = dict;
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            //   notification.applicationIconBadgeNumber = 1;
//
//            notification.repeatInterval=0;
//
//             _zoneId = @"";
//
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
           // [self getZoneIn];
            [self zoneByUser];
            [self getDiscount];
            
            if ([[ZoneDetails sharedZoneDetails] notifyZoneWithZoneName:zoneName ZoneId:_zoneId]) {
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = @"do you need any asistance?";
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                //   notification.applicationIconBadgeNumber = 1;
                
                notification.repeatInterval=0;
                
                //                [Userdefaults setBool:YES forKey:@"isEntry"];
                //
                //                [Userdefaults synchronize];
                //
                //                _zoneId = @"";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            } else {
                
            }
            
            
        }
        else if ([zoneName isEqualToString:@"entry area"]) {
            
            BOOL isEntry = [Userdefaults boolForKey:@"isEntry"];
            
            if (isEntry==NO)
            {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date];
                notification.alertBody = @"Welcome to Future Netwings Solution Pvt Ltd.";
                notification.timeZone = [NSTimeZone localTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                //   notification.applicationIconBadgeNumber = 1;
                
                notification.repeatInterval=0;
                
                [Userdefaults setBool:YES forKey:@"isEntry"];
                
                [Userdefaults synchronize];
                
                _zoneId = @"";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            }
            
        }
        
    }
}

-(void)exitZoneWithZoneName:(NSString *)zoneName {
    
    int zoneInt = (int)[_zoneId integerValue];
    
    NSString *StrzoneName =  @"";//[self.arrNames objectAtIndex:(zoneInt - 1)];
    if (zoneInt <= [self.arrNames count]) {
     
        StrzoneName =  [self.arrNames objectAtIndex:(zoneInt - 1)];
        
    } else {
        
    }

    if (zoneName) {

        if ([zoneName isEqualToString:StrzoneName])
        {
           // [self getZoneOut];
            
            [Userdefaults removeObjectForKey:@"ZoneNameInfo"];
            [Userdefaults synchronize];
        }
        else if ([zoneName isEqualToString:StrzoneName])
        {
           // [self getZoneOut];
            
            [Userdefaults removeObjectForKey:@"ZoneNameInfo"];
            [Userdefaults synchronize];
        }
        else if ([zoneName isEqualToString:StrzoneName])
        {
           // [self getZoneOut];
            
            [Userdefaults removeObjectForKey:@"ZoneNameInfo"];
            [Userdefaults synchronize];
        }
        else if ([zoneName isEqualToString:StrzoneName])
        {
           // [self getZoneOut];
            
            [Userdefaults removeObjectForKey:@"ZoneNameInfo"];
            [Userdefaults synchronize];
        }
        else if ([zoneName isEqualToString:StrzoneName])
        {
           // [self getZoneOut];
            
            [Userdefaults removeObjectForKey:@"ZoneNameInfo"];
            [Userdefaults synchronize];
        }
        else if ([zoneName isEqualToString:StrzoneName])
        {
           // [self getZoneOut];
            
            [Userdefaults removeObjectForKey:@"ZoneNameInfo"];
            [Userdefaults synchronize];
        }
        
//        else if ([zoneName isEqualToString:@"entry area"]) {
//
//            BOOL isEntry = [Userdefaults boolForKey:@"isEntry"];
//
//            if (isEntry==NO)
//            {
//                UILocalNotification *notification = [[UILocalNotification alloc] init];
//
//                notification.fireDate = [NSDate date];
//                notification.alertBody = @"Welcome to Future Netwings Solution Pvt Ltd.";
//                notification.timeZone = [NSTimeZone localTimeZone];
//                notification.soundName = UILocalNotificationDefaultSoundName;
//
//                // notification.applicationIconBadgeNumber = 1;
//
//                notification.repeatInterval=0;
//
//                [Userdefaults setBool:YES forKey:@"isEntry"];
//
//                [Userdefaults synchronize];
//
//                _zoneId = @"";
//
//                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//
//            }
//
//        }

    }
}

-(void)navigateForProduct
{
    if([_zoneId length]>0)
    {
        CGFloat xPoint = 0.0;
        CGFloat yPoint = 0.0;
        for (i=0; i<[self.arrNames count]; i++) {
            
            zoneIdStr = [NSString stringWithFormat:@"%d",i+1];
            
            if ([zoneIdStr isEqualToString:_zoneId] && (i < [self.arrPointx count] && i < [self.arrPointy count])) {
            
                xPoint = [[self.arrPointx objectAtIndex:i] floatValue];
                yPoint = [[self.arrPointy objectAtIndex:i] floatValue];
                _isRouting = YES;
                break;
            }
        }
        
        [self drawPathWithEndPoint:CGPointMake(xPoint, yPoint)];

    }
}

- (void)drawPathWithEndPoint:(CGPoint)endPoint
{
    
    if (!_isDrawingPath) {
        
        _isDrawingPath = YES;
        NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
        if (res.error.code == 0 && [_arrPointx count] && [_arrPointy count]) {
            
            CGFloat xPoint = endPoint.x;
            CGFloat yPoint = endPoint.y;
            
            NCLocationPoint *location = [NCLocationPoint pointWithLocation:res.location sublocation:res.sublocation x:[NSNumber numberWithFloat:xPoint] y:[NSNumber numberWithFloat:yPoint]];
            
            [[ZoneDetection sharedZoneDetection].navigineCore addTatget:location];
            
            CGFloat xPoint2 = [[_arrPointx objectAtIndex:0] floatValue];
            CGFloat yPoint2 = [[_arrPointy objectAtIndex:0] floatValue];
            
            NCLocationPoint *location2 = [NCLocationPoint pointWithLocation:res.location sublocation:res.sublocation x:[NSNumber numberWithFloat:xPoint2] y:[NSNumber numberWithFloat:yPoint2]];
            
            [[ZoneDetection sharedZoneDetection].navigineCore makeRouteFrom:location to:location2];
            _isRouting = YES;
            _isRouting = YES;
            
            if (_isRouting & [res.paths count]) {
                
                NCRoutePath *devicePath = res.paths.firstObject;
                NSArray *path = devicePath.points;
                float distance = devicePath.lenght;
                [self drawRouteWithPath:path andDistance:distance];
                
            }
            
        } else {
            
        }
        
        _isDrawingPath = NO;
        
    } else {
        
    }
    
    
}

- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
    
    NSDictionary* zone = nil;
    _zoneArray = [NSArray arrayWithArray:[ZoneDetection sharedZoneDetection].zoneArray];
    if (_zoneArray) {
        
        for (NSInteger i = 0; i < [_zoneArray count]; i++) {
            
            NSDictionary* dicZone = [NSDictionary dictionaryWithDictionary:[_zoneArray objectAtIndex:i]];
            
            NSArray* coordinates = [NSArray arrayWithArray:[dicZone objectForKey:@"coordinates"]];
            
            if ([coordinates count]>0) {
                
                UIBezierPath* path = [[UIBezierPath alloc]init];
                
                for (NSInteger j=0; j < [coordinates count]; j++) {
                    
                    NSDictionary* dicCoordinate = [NSDictionary dictionaryWithDictionary:[coordinates objectAtIndex:j]];
                    
                    if ([[dicCoordinate allKeys] containsObject:@"kx"]) {
                        
                        float xPoint = [[dicCoordinate objectForKey:@"kx"] floatValue];
                        float yPoint = [[dicCoordinate objectForKey:@"ky"] floatValue];
                        
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


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationTicker
{
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    NSLog(@"Error code:%zd",res.error.code);
    if (res.error.code == 0 && !isDrawZone) {
        
        //        isDrawZone = YES;
        
        [self navigationStart];
        
        if([_zoneId length]>0)
        {
            NSDictionary* dic = [self didEnterZoneWithPoint:CGPointMake(res.kx, res.ky)];
            
            if ([[dic allKeys] containsObject:@"name"]) {
                
                NSString* zoneName = [dic objectForKey:@"name"];
                
                if (!_currentZoneName) {
                    
                    _currentZoneName = zoneName;
                    
                    [self enterZoneWithZoneName:_currentZoneName];
                    
                } else {
                    
                    if (![zoneName isEqualToString:_currentZoneName]) {
                        
                        _currentZoneName = zoneName;
                        [self enterZoneWithZoneName:_currentZoneName];
                        
                    } else {
                        
                    }
                }
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self drawZones];
            _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
                                          _imageView.height / _sv.zoomScale * (1. - res.ky));
            
            
            [self performSelector:@selector(navigateForProduct) withObject:nil afterDelay:0.3];
            
        });
        
    } else if (res.error.code == 0) {
        
        [self navigationStart];
        
        if([_zoneId length]>0)
        {
            NSDictionary* dic = [self didEnterZoneWithPoint:CGPointMake(res.kx, res.ky)];
            
            if ([[dic allKeys] containsObject:@"name"]) {
                
                NSString* zoneName = [dic objectForKey:@"name"];
                
                if (!_currentZoneName) {
                    
                    _currentZoneName = zoneName;
                    
                    [self enterZoneWithZoneName:_currentZoneName];
                    
                } else {
                    
                    if (![zoneName isEqualToString:_currentZoneName]) {
                        
                        _currentZoneName = zoneName;
                        [self enterZoneWithZoneName:_currentZoneName];
                        
                    } else {
                        
                    }
                }
                
            }
        }
        

       dispatch_async(dispatch_get_main_queue(), ^{
            
            _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
                                          _imageView.height / _sv.zoomScale * (1. - res.ky));            
            [self performSelector:@selector(navigateForProduct) withObject:nil afterDelay:0.3];
            
        });
        
    } else {
        
    }
    
    NSLog(@"Error code:%zd",res.error.code);

    
}

-(void) drawRouteWithPath: (NSArray *)path
              andDistance: (float)distance {
    
    [_routeLayer removeFromSuperlayer];
    _routeLayer = nil;
    [_uipath removeAllPoints];
    _uipath = nil;
    
    _uipath     = [[UIBezierPath alloc] init];
    _routeLayer = [CAShapeLayer layer];
    if ([[ZoneDetection sharedZoneDetection].navigineCore.location.sublocations count]) {
        
        __block NCSublocation *sublocation = [ZoneDetection sharedZoneDetection].navigineCore.location.sublocations[0];
        //    // We check that we are close to the finish point of the route
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int i = 0; i < path.count; i++ ) {
                
                NCLocationPoint *point = path[i];
                CGSize imageSizeInMeters = CGSizeMake(sublocation.width, sublocation.height);
                
                CGFloat xPoint =  (point.x.doubleValue / imageSizeInMeters.width) * (_imageView.width / _sv.zoomScale);
                CGFloat yPoint =  (1. - point.y.doubleValue / imageSizeInMeters.height)  * (_imageView.height / _sv.zoomScale);
                if(i == 0) {
                    [_uipath moveToPoint:CGPointMake(xPoint, yPoint)];
                }
                else {
                    [_uipath addLineToPoint:CGPointMake(xPoint, yPoint)];
                }
            }
            //    }
            
            _routeLayer.hidden          = NO;
            _routeLayer.path            = [_uipath CGPath];
            if ([ZoneDetection sharedZoneDetection].isAbc) {
                
                [ZoneDetection sharedZoneDetection].isAbc = NO;
                _routeLayer.strokeColor     = [[UIColor redColor] CGColor];
                
            } else {
                
                [ZoneDetection sharedZoneDetection].isAbc = YES;
                _routeLayer.strokeColor     = [[UIColor blueColor] CGColor];
                
            }
            //        _routeLayer.strokeColor     = [[UIColor blueColor] CGColor];
            
            _routeLayer.lineWidth       = 5.0;
            _routeLayer.lineJoin        = kCALineJoinRound;
            _routeLayer.fillColor       = [[UIColor clearColor] CGColor];
            
            [_imageView.layer addSublayer:_routeLayer];
            [_imageView bringSubviewToFront:_current];
            
        });
        
    } else {
        
    }
    
}

- (void)addPinToMapWithVenue:(NCVenue *)v andImage:(UIImage *)image{
    
    CGFloat xPoint = v.x.doubleValue * _imageView.width;
    CGFloat yPoint = (1. - v.y.doubleValue) * _imageView.height;
    
    CGPoint point = CGPointMake(xPoint, yPoint);
    MapPin *mapPin = [[MapPin alloc] initWithVenue:v];
    [mapPin setImage:image forState:UIControlStateNormal];
    [mapPin setImage:image forState:UIControlStateHighlighted];
    [mapPin addTarget:self action:@selector(mapPinPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapPin sizeToFit];
    [_imageView addSubview:mapPin];
    [_sv bringSubviewToFront:mapPin];
    
    mapPin.center  = point;
}

- (void)mapPinPressed:(id)sender {
    
    MapPin *mapPin = (MapPin *)sender;
    [_pressedPin.popUp removeFromSuperview];
    _pressedPin.popUp.hidden = YES;
    
    _pressedPin = mapPin;
    [_imageView addSubview:mapPin.popUp];
    mapPin.popUp.hidden = NO;
    
    mapPin.popUp.bottom   = mapPin.top - 9.0f;
    mapPin.popUp.centerX  = mapPin.centerX;
    
    [mapPin.popUp addTarget:self action:@selector(popUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)popUpPressed:(id)sender {
    
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    if ((res.error.code == 0) && [[ZoneDetection sharedZoneDetection].navigineCore.location.sublocations count]) {
        
        NCSublocation *sublocation = [ZoneDetection sharedZoneDetection].navigineCore.location.sublocations[0];
        
        CGSize imageSizeInMeters = CGSizeMake(sublocation.width, sublocation.height);
        
        CGFloat xPoint = _pressedPin.centerX /_imageView.width * imageSizeInMeters.width;
        CGFloat yPoint = (1. - _pressedPin.centerY /_imageView.height) * imageSizeInMeters.height;
        
        NCLocationPoint *location = [NCLocationPoint pointWithLocation:res.location sublocation:res.sublocation x:[NSNumber numberWithFloat:xPoint] y:[NSNumber numberWithFloat:yPoint]];
        
        [[ZoneDetection sharedZoneDetection].navigineCore addTatget:location];
        
        [_pressedPin.popUp removeFromSuperview];
        _pressedPin.popUp.hidden = YES;
        _isRouting = YES;
        
    } else {
        
    }
    
}

- (void)stopRoute {
    
    _isRouting = NO;
    
    [_routeLayer removeFromSuperlayer];
    _routeLayer = nil;
    
    [_uipath removeAllPoints];
    _uipath = nil;
    
    [[ZoneDetection sharedZoneDetection].navigineCore cancelTargets];
}

- (void)tapPress:(UITapGestureRecognizer *)gesture {
    [self navigateForProduct];
    
//    [_pressedPin.popUp removeFromSuperview];
//    _pressedPin.popUp.hidden = YES;
    
    
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _imageView;
}

#pragma mark NavigineCoreDelegate methods

- (void) didRangePushWithTitle:(NSString *)title
                       content:(NSString *)content
                         image:(NSString *)image
                            id:(NSInteger)id{
    
    // Your code
    
}


- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)getZoneIn
{
//    [SVProgressHUD show];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:locale];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *inTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [Userdefaults setObject:inTimeStr forKey:@"inTimeStr"];
    
    [Userdefaults synchronize];
    
    NSString *userUpdate = [NSString stringWithFormat:@"zoneid=%@&userid=%@",_zoneId,userId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"user_history_loc.php" completion:^(NSDictionary * dict, NSError *error) {
        
//        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
               
                
            } else {
                
//                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
            }
        }
    }];
    
}

-(void)getDiscount
{
//    [SVProgressHUD show];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:locale];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *inTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [Userdefaults setObject:inTimeStr forKey:@"inTimeStr"];
    
    [Userdefaults synchronize];
    
    NSString *userUpdate = [NSString stringWithFormat:@"zone_code=%@",_zoneId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"discountbyzonecode.php" completion:^(NSDictionary * dict, NSError *error) {
        
//        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
//                BOOL offerDescription = [Userdefaults boolForKey:[NSString stringWithFormat:@"offerDescription:%@",_zoneId]];
//
//                if (offerDescription==NO)
//                {
                NSArray* arrDiscountlist = [dict objectForKey:@"Discountlist"];
                if ([arrDiscountlist count]) {
                    
                    NSDictionary *discountlist = [arrDiscountlist objectAtIndex:0];
                    
                    UILocalNotification *notification = [[UILocalNotification alloc] init];
                    notification.fireDate = [NSDate date];
                    notification.alertBody = [NSString stringWithFormat:@"%@",[discountlist objectForKey:@"offer_description"]];
                    notification.timeZone = [NSTimeZone localTimeZone];
                    notification.userInfo = discountlist;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    //   notification.applicationIconBadgeNumber = 1;
                    notification.repeatInterval=0;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                        
                    });
                    
                } else {
                    
                }
                
                    
//                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"offerDescription:%@",_zoneId]];
//                    [Userdefaults synchronize];
//
//                }
                
                
            } else {
                
//                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
            }
        }
    }];
    
}

-(void)getZoneOut
{
//    [SVProgressHUD show];
    
    NSString *time = [NSString stringWithFormat:@"%@",[Userdefaults objectForKey:@"inTimeStr"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:locale];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *dateFromString = [dateFormatter dateFromString:time];
    
    NSDate *currentDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    
    NSString *outTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSTimeInterval secondsBetween = [dateFromString timeIntervalSinceDate:currentDate];
    
    int minutes = secondsBetween / 60;
    
    NSString *userUpdate = [NSString stringWithFormat:@"zoneid=%@&userid=%@&out_time=%@&spent_time=%d",_zoneId,userId,outTimeStr,minutes];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"user_history_loc.php" completion:^(NSDictionary * dict, NSError *error) {
        
//        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                
            }
            else {
                
//                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
            }
        }
    }];
    
}
- (void) drawZones {
    
    if ([[ZoneDetection sharedZoneDetection].navigineCore.location.sublocations count]) {
        
        NCSublocation *sublocation = [ZoneDetection sharedZoneDetection].navigineCore.location.sublocations[0];
        NSArray *zones = [NSArray arrayWithArray:sublocation.zones];
        if ([zones count]) {
            
            isDrawZone = YES;
            for (NCZone *zone in zones) {
                UIBezierPath *zonePath     = [[UIBezierPath alloc] init];
                CAShapeLayer *zoneLayer = [CAShapeLayer layer];
                NSArray *points = zone.points;
                NCLocationPoint *point0 = points[0];
                
                [zonePath moveToPoint:CGPointMake(_imageView.width * point0.x.doubleValue / sublocation.width,
                                                  _imageView.height * (1. - point0.y.doubleValue / sublocation.height))];
                for (NCLocationPoint *point in zone.points) {
                    [zonePath addLineToPoint:CGPointMake(_imageView.width * point.x.doubleValue / sublocation.width,
                                                         _imageView.height * (1. - point.y.doubleValue / sublocation.height))];
                }
                [zonePath addLineToPoint:CGPointMake(_imageView.width * point0.x.doubleValue / sublocation.width,
                                                     _imageView.height *(1. - point0.y.doubleValue / sublocation.height))];
                unsigned int result = 0;
                NSScanner *scanner = [NSScanner scannerWithString:zone.color];
                [scanner setScanLocation:1];
                [scanner scanHexInt:&result];
                
                zoneLayer.hidden = NO;
                zoneLayer.path            = [zonePath CGPath];
                zoneLayer.strokeColor     = [kColorFromHex(result) CGColor];//[[UIColor clearColor] CGColor];
                zoneLayer.lineWidth       = 2.0;
                zoneLayer.lineJoin        = kCALineJoinRound;
                zoneLayer.fillColor       = [[kColorFromHex(result) colorWithAlphaComponent:0.5] CGColor];//[[UIColor greenColor] CGColor];
                
                [_imageView.layer addSublayer:zoneLayer];
                
                [_current removeFromSuperview];
                [_imageView addSubview:_current];
            }
            
        } else {
            
        }
        
    } else {
        
    }
    
}
-(void)zoneByUser
{
//    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&zone_id=%@",userId,_zoneId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"zone_by_user.php" completion:^(NSDictionary * dict, NSError *error) {
        
//        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"update successful."
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"Ok"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
                    
                });
            }
            else {
                
//                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
    
}

- (void)dealloc {
    
    NSLog(@"Dealloc: IndoorMapViewController");
}
@end
