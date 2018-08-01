//
//  QuickCheckOutViewController.m
//  Jing
//
//  Created by fnspl3 on 14/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "QuickCheckOutViewController.h"
#import "YourCartViewController.h"
#import "CartDetails.h"
#import "Barcode.h"
#import "ProductCategoryViewController.h"
@import AVFoundation;   // iOS7 only import style



@interface QuickCheckOutViewController (){
    
    NSMutableArray *ProductInfo;
    NSDictionary *productInfoDict;
    CartDetails* cartDetails;
//    NSTimer *_timer;
    
}
@property (strong, nonatomic) NSMutableArray * foundBarcodes;
@property (weak, nonatomic) IBOutlet UIView *previewView;

@end

@implementation QuickCheckOutViewController{
    
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    api = [APIManager sharedManager];
    _addmoreView.layer.cornerRadius = 5.0f;
    _showCartView.layer.cornerRadius = 5.0f;
    _showCartView.clipsToBounds = YES;
    _addmoreView.clipsToBounds = YES;
    
//    _isReading = NO;
//    _captureSession = nil;
//
//    [self startStopReading];
    
    cartDetails = [CartDetails sharedInstanceCartDetails];
    cartDetails.addToCartItems = [NSMutableArray array];
    
//    [self.addmoreView setBackgroundColor:[UIColor colorWithHexString:@"#DADCD9"]];
    [self.addmoreView setBackgroundColor:[UIColor colorWithHexString:@"#50BBE8"]];
    
    
    NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
    
    for (NSDictionary *dict in ProductInfo)
    {
        [cartDetails.addToCartItems addObject:dict];
    }
    
    [Userdefaults setObject:cartDetails.addToCartItems forKey:@"CartDetails"];
    [Userdefaults synchronize];
    
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    self.foundBarcodes = [[NSMutableArray alloc] init];
    
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
    [self.allowedBarcodeTypes addObject:@"org.iso.QRCode"];
    [self.allowedBarcodeTypes addObject:@"org.iso.PDF417"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.UPC-E"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Aztec"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code39Mod43"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-13"];
    [self.allowedBarcodeTypes addObject:@"org.gs1.EAN-8"];
    [self.allowedBarcodeTypes addObject:@"com.intermec.Code93"];
    [self.allowedBarcodeTypes addObject:@"org.iso.Code128"];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//     [self startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}

#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue =
    dispatch_queue_create("com.1337labz.featurebuild.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self
                                          queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes =
    _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}

#pragma mark - Button action functions
- (IBAction)settingsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"toSettings" sender:self];
}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"toSettings"]) {
//        self.settingsVC = (SettingsViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SettingsViewController"];
//        self.settingsVC = segue.destinationViewController;
//        self.settingsVC.delegate = self;
//    }
//}


#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             
             for(NSString * str in self.allowedBarcodeTypes){
                 if([barcode.getBarcodeType isEqualToString:str]){
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }
     }];
}

- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    [self.foundBarcodes addObject:barcode];
    [self postQRMatching:barcode];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnAddMore:(id)sender {

    [self.addmoreView setBackgroundColor:[UIColor colorWithHexString:@"#DADCD9"]];
    
    [self addProductToCart];
    
    [self startRunning];
    
    _running = YES;
}

-(void)addProductToCart
{
    if ([ProductInfo count]>0) {
        
        productInfoDict = (NSDictionary *)[ProductInfo objectAtIndex:0];
        cartDetails = [CartDetails sharedInstanceCartDetails];
        [cartDetails addItemsInCard:productInfoDict];
    }
}

- (IBAction)btnShowCart:(id)sender {
    
dispatch_async(dispatch_get_main_queue(), ^{
        
if ([cartDetails.addToCartItems count]>0) {
        YourCartViewController *YourCartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
        
         YourCartViewScreen.ProductInfo = cartDetails.addToCartItems;

        [self.navigationController pushViewController:YourCartViewScreen animated:YES];
      }
        
   else {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Product are added in Your cart.Shop more to procced"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
     [alertView show];
     
       }
        
    });

//    [self postQRMatching];
    
}

- (IBAction)btnBack:(id)sender {
    
//  [self.navigationController popViewControllerAnimated:YES];
    ProductCategoryViewController *ProductCategoryViewScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
    
    [self.navigationController pushViewController:ProductCategoryViewScreen animated:YES];
    
}

-(void)postQRMatching:(Barcode *)QRstr
{
    
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"bar_code=%@",[QRstr getBarcodeData]];
    
    NSLog(@"%@",userUpdate);
    
//    NSString *userUpdate = [NSString stringWithFormat:@"bar_code=9771234567003"];

    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //    [api ApiRequestPOSTwithParameters:params WithUrlLastPart:@"login.php" completion:^(NSDictionary * dict, NSError *error) {
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"productbyproductbarcode.php" completion:^(NSDictionary * dict, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
    
                ProductInfo = [dict objectForKey:@"productlist"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.addmoreView setBackgroundColor:[UIColor colorWithHexString:@"#6FD04B"]];
                    
                });

//                if ([ProductInfo count]>0) {

//                productInfoDict = (NSDictionary *)[ProductInfo objectAtIndex:0];
//
//                cartDetails = [CartDetails sharedInstanceCartDetails];
//                    cartDetails.addToCartItems = [NSMutableArray array];
//
//                    [cartDetails.addToCartItems addObject:productInfoDict];
//
//                    //NSLog(@"%d",[cartDetails.addToCartItems count]);
//
//                    NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
//
////                    NSPredicate *bPredicate =
////                    [NSPredicate predicateWithFormat:@"bar_code=%@",[productInfoDict objectForKey:@"bar_code"]];
////                    NSArray* arr = [ProductInfo filteredArrayUsingPredicate:bPredicate];
//
//                    for (NSDictionary *dict in ProductInfo)
//                    {
//                        [cartDetails.addToCartItems addObject:dict];
//                    }
//
//                   // NSLog(@"%d",[cartDetails.addToCartItems count]);
//
//                    [Userdefaults setObject:cartDetails.addToCartItems forKey:@"CartDetails"];
//                    [Userdefaults synchronize];
                    
//                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
//                    NSLog(@"DICT=====%@",dict);
//
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        YourCartViewController *YourCartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
//
////                        YourCartViewScreen.productInfoDict = productInfoDict;
//                        YourCartViewScreen.ProductInfo = cartDetails.addToCartItems;
////
//
//                        [self.navigationController pushViewController:YourCartViewScreen animated:YES];                    });
                    
                    
               
//                }
                
//            }
//            else{
//
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"This product bar code not matched, please try again later."
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"Ok"
//                                                          otherButtonTitles:nil];
//                [alertView show];
//                [SVProgressHUD dismiss];
//
//
//            }
            
        } else {
            
            [SVProgressHUD dismiss];
            
            NSLog(@"Error: %@", error);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem to the  barcode scaning, try again later."
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        }
    }];
    
}

@end
