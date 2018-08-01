//
//  QuickCheckOutViewController.h
//  Jing
//
//  Created by fnspl3 on 14/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSDictionary+NullReplacement.h"
//#import "KYDrawerController.h"
#import "APIManager.h"
//#import "MenuTableViewController.h"
#import "UIColor+HexString.h"
#import "ViewController.h"

@interface QuickCheckOutViewController : ViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>{
    
    APIManager *api;
//    KYDrawerController *drawer;
//    MenuTableViewController *menu;
    UINavigationController *localNavigationController;
}
//@property (weak, nonatomic) IBOutlet UIView *vwQR;
@property (weak, nonatomic) IBOutlet UIView *addmoreView;
@property (weak, nonatomic) IBOutlet UIView *showCartView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;



//For barcode
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;

- (IBAction)btnAddMore:(id)sender;
- (IBAction)btnShowCart:(id)sender;
- (IBAction)btnBack:(id)sender;

@end
