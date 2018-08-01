//
//  ProductCategoryViewController.m
//  Jing
//
//  Created by fnspl3 on 13/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "ProductCategoryViewController.h"
#import "UIImageView+WebCache.h"
#import "ProductCategoryCollectionViewCell.h"
#import "QuickCheckOutViewController.h"
#import "SubCategoryViewController.h"
#import "ProductDetailsViewController.h"
#import "IndoorMapViewController.h"
#import "YourCartViewController.h"
#import "CartDetails.h"
#import "ProductbycatViewController.h"
//For Search
#import "UIImageView+WebCache.h"
#import "Common.h"

@interface ProductCategoryViewController (){
    
    NSMutableArray *bannerImages;
    NSMutableArray *viewsArray;
    NSArray *bannerFeatured;
    NSMutableArray *catlistInfo;
    NSDictionary *catlistfoDict;
    NSMutableArray *subCatlistInfo;
    NSDictionary *subCatlistfoDict;
    
    //For search
    NSArray *productlistingSearch;
    bool isTextFieldReturn;
    NSString *productId;
    NSMutableArray *productbyDetailslistInfo;
    NSDictionary *productbyDetailslistfoDict;
    
    NSMutableArray *offerslistInfo;
    NSDictionary *offerslistDict;
    
    NSString *countStr;
    UITextField *txtField;
    
    NSMutableArray *arrNames;
    NSMutableArray *arrPointx;
    NSMutableArray *arrPointy;
    NSString *zoneIdStr;
    
    
    NSString *userId;
    
    NSDictionary *productbyCatlistfoDict;
    NSMutableArray *productbyCatlistInfo;


}
@property (nonatomic, strong) MapPin *pressedPin;
@property (nonatomic, assign) BOOL isRouting;
@property (nonatomic, strong) NSDictionary *ProfInfo;
//@property (nonatomic, strong) NavigineCore *navigineCore;

@end

@implementation ProductCategoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%@",[self.ProfInfo objectForKey:@"id"]];
    _tableViewSearch.hidden=YES;
    [self textFieldShouldReturn:(UITextField *)txtField];
    _viewCount.layer.cornerRadius= _viewCount.frame.size.height/2;
    
    api = [APIManager sharedManager];
    
    bannerImages = [[NSMutableArray alloc]init];
    
//    arrNames = [[NSMutableArray alloc] initWithObjects:@"conference area",@"marketing room",@"Developers 1",@"conference room small",@"Developers 2",@"service desk",nil];
    
//    arrPointx = [[NSMutableArray alloc] initWithObjects:@"22.63",@"13.38",@"13.18",@"15.53",@"13.32",@"13.83", nil];
//
//    arrPointy = [[NSMutableArray alloc] initWithObjects:@"20.00",@"12.40",@"26.75",@"39.21",@"21.60",@"32.51", nil];
    
    
    arrNames = [[NSMutableArray alloc] initWithObjects:@"conference room small",@"service desk",@"Developers 1",@"conference area",@"Developers 2",@"marketing room",nil];
    
    
    arrPointx = [[NSMutableArray alloc] initWithObjects:@"14.19",@"14.42",@"11.81",@"22.43",@"11.53",@"14.23", nil];
    
    arrPointy = [[NSMutableArray alloc] initWithObjects:@"39.24",@"34.25",@"26.63",@"19.69",@"21.31",@"12.20", nil];
    

    
    [self getOfferList];
    
    _searchView.layer.cornerRadius = 20.0f;
    _searchView.clipsToBounds = YES;
    
    [self.navigationController.navigationBar setHidden:YES];
     //////////////for Navigine/////////////
    [self.productCategoryCollectionView registerNib:[UINib nibWithNibName:@"ProductCategoryCollectionViewCell" bundle:[NSBundle mainBundle]]
                     forCellWithReuseIdentifier:@"ProductCategoryCollectionViewCell"];
    
    [_productCategoryCollectionView setDataSource:self];
    
    [self categoriesProduct];
    NSInteger curtItems = [[CartDetails sharedInstanceCartDetails] countCartItems];
    countStr = [NSString stringWithFormat:@"%ld",curtItems];
    _lblCount.text = countStr;
    
    if([_lblCount.text isEqualToString:@"0"]){
        _viewCount.hidden=YES;
    }
    else{
        _viewCount.hidden=NO;
    }

    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(navigineSetupAdded:)
//                                                 name:@"navigineSetup"
//                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
   [super viewWillAppear:YES];
    
    //For Search
//   [_txtFieldSearch becomeFirstResponder];
    
   _tableViewSearch.hidden=YES;
   isTextFieldReturn = NO;

    if([_txtFieldSearch hasText])
    {
        _txtFieldSearch.text = @"";
        _tableViewSearch.hidden=YES;
    }

//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"navigineSetup"
//     object:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //////////////for Navigine/////////////
     [[ZoneDetection sharedZoneDetection] setDelegate:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //////////////for Navigine/////////////
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
    
    if(!_imageView.image) {

        dispatch_async(dispatch_get_main_queue(), ^{

            NSData *pngData = [NSData dataWithContentsOfFile:[[Common sharedCommon] indorMapImagePath]];
            UIImage *image = [UIImage imageWithData:pngData];
            if (image) {

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
                
                NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
                if (res.error.code == 0) {
                    
                    _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
                                                  _imageView.height / _sv.zoomScale * (1. - res.ky));
                    
                } else {
                    
                }

                NSData *pngData = UIImagePNGRepresentation(image);
                NSString *filePath = [[Common sharedCommon] indorMapImagePath];
                [pngData writeToFile:filePath atomically:YES];

                [_indicatorView setHidden:YES];

            } else {

            }


        });

    } else {

        [_indicatorView setHidden:YES];
    }
    
    
    
    
    
    //    [self zoneDetection];
    
}

//#pragma mark - NSNotification
//- (void) navigineSetupAdded:(NSNotification *) notification{
//
//   // [[ZoneDetection sharedZoneDetection] setDelegate:self];
//
//    [self setupNavigine];
//
//}

-(void)navigationStart
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _sv.delegate = self;
        _sv.pinchGestureRecognizer.enabled = YES;
        _sv.minimumZoomScale = 1.f;
        _sv.zoomScale = 1.f;
        _sv.maximumZoomScale = 2.f;
        
        [_sv addSubview:_imageView];
        
        // Point on map
        
        _current = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _current.backgroundColor = [UIColor redColor];
        _current.layer.cornerRadius = _current.frame.size.height/2.f;
        
        [_imageView addSubview:_current];
        _imageView.userInteractionEnabled = YES;
        
        _isRouting = NO;
        
        [self setupNavigine];
        
    });
    
}

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
    
}



-(void)addBannerSliderWithArray:(NSMutableArray *)arr{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        viewsArray = [[NSMutableArray alloc]init];
        
        for (int i=0; i<[arr count]; i++) {
//            [_indicatorView setHidden:NO];
//            [_indicatorView startAnimating];
//
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[arr objectAtIndex:i]]];
            
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
            
            [imgView setContentMode:UIViewContentModeScaleToFill];
            [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            
            [viewsArray addObject:imgView];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            JScrollView_PageControl_AutoScroll *view = [[JScrollView_PageControl_AutoScroll alloc]initWithFrame:self.vwPaging.bounds];
            [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            view.autoScrollDelayTime=3.0;
            view.delegate=self;
            [view setViewsArray:viewsArray];
            [self.vwPaging addSubview:view];
            [_indicatorView setHidden:YES];
            [_indicatorView stopAnimating];
            [view shouldAutoShow:YES];
        });
    });
    
}
- (void)didClickPage:(JScrollView_PageControl_AutoScroll *)view atIndex:(NSInteger)index
{
    NSLog(@"click at %ld",(long)index  );
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    return 9;
    return [catlistInfo count];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ProductCategoryCollectionViewCell";
    
    ProductCategoryCollectionViewCell *cell = (ProductCategoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if ([catlistInfo count]>0) {
        
        NSDictionary *dict = [catlistInfo objectAtIndex:indexPath.row];
        
        NSString *imgURL= [NSString stringWithFormat:@"%@",[dict objectForKey:@"thumb"]];
        imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell setProductImgUrl:imgURL];
        [cell setProductName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]]];
        
        [cell updateCell];
    }
    
    //    cell.backgroundColor = [UIColor greenColor];
    
    //    NSDictionary *dict = [[_subCategoryListing objectForKey:@"data"] objectAtIndex:indexPath.row];
    //    cell.lblCategoryName.text = [dict objectForKey:@"cat_name"];
    //    [cell.indicatorView setHidden:NO];
    //    [cell.indicatorView startAnimating];
    //    cell.transView.hidden = YES;
    
    //    if([[dict objectForKey:@"cat_image"] isEqualToString:@""]){
    //        //cell.imgViewCategory.image = [UIImage imageNamed:@"no-thumb.jpg"];
    //        cell.contentView.backgroundColor = [UIColor colorWithRed:227/255.0 green:33/255.0 blue:125/255.0 alpha:1.0];
    //        //cell.lblCategoryName.textColor = [UIColor blackColor];
    //        [cell.indicatorView setHidden:YES];
    //        [cell.indicatorView stopAnimating];
    //
    //    }else{
    //        NSString *imgURL = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[dict objectForKey:@"cat_image"]]];
    //        imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //        SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //        [manager downloadImageWithURL:[NSURL URLWithString:imgURL]
    //                              options:0
    //                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //                                 // progression tracking code
    //                                 NSLog(@"receivedSize %ld",(long)receivedSize);
    //                             }
    //                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    //                                if (image) {
    //                                    // do something with image
    //                                    //                                    cell.imgViewCategory.image = image;
    //
    //                                    [cell.indicatorView setHidden:YES];
    //                                    [cell.indicatorView stopAnimating];
    //
    //
    //                                }
    //                            }];
    //        [cell.imgViewCategory setContentMode:UIViewContentModeScaleAspectFill];
    //        cell.lblCategoryName.textColor = [UIColor whiteColor];
    //        //        cell.lblCategoryName.frame = CGRectMake(cell.lblCategoryName.frame.origin.x, cell.lblCategoryName.frame.origin.y+13.5, cell.lblCategoryName.frame.size.width, cell.lblCategoryName.frame.size.height);
    //
    //        cell.contentView.backgroundColor = [UIColor colorWithRed:227/255.0 green:33/255.0 blue:125/255.0 alpha:1.0];
    //
    //    }
    //
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width/3-19.0,87);
    //    return CGSizeMake(100, 211);
}

- (CGFloat)collectionView:(UICollectionView *) collectionView
                   layout:(UICollectionViewLayout *) collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger) section {
    
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //    return 0.5f;
    return 7;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6,6,6,6);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//        SubCategoryViewController *cartViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
//        [self.navigationController pushViewController:cartViewScreen animated:YES];
    
     NSDictionary *dict = [catlistInfo objectAtIndex:indexPath.row];
    NSString *hasChild = [NSString stringWithFormat:@"%@",[dict objectForKey:@"has_child"]];
     NSLog(@"hasChild=== %@",hasChild);
    
    if([hasChild isEqualToString:@"1"]){
        
        if (isclicked == NO)
        {
            isclicked = YES;
            
            [self getSubCategoryList:[[catlistInfo  objectAtIndex:indexPath.row] objectForKey:@"catid"]];
        }
        
    }
    else if([hasChild isEqualToString:@"0"]){
        
//        NSDictionary *dict = [catlistInfo  objectAtIndex:indexPath.row];
//
//        NSString *catIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"catid"]];
        
        [self getProductbyCategoryList:[[catlistInfo  objectAtIndex:indexPath.row] objectForKey:@"catid"]];
        
    }
    
    // NSDictionary *dict = [categoryListing objectAtIndex:indexPath.row];
    //  [self getSubCategoryList:[dict objectForKey:@"id"]];
    
    //    [self getBusinessListing:[NSString stringWithFormat:@"%@",[[[_subCategoryListing objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"id"]]];
    //    
    //    catName = [[[_subCategoryListing objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"cat_name"];
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    
    _productCategoryCollectionView.frame = CGRectMake(_productCategoryCollectionView.frame.origin.x, _lblSortbyCategory.frame.origin.y+_lblSortbyCategory.frame.size.height,_productCategoryCollectionView.frame.size.width, _productCategoryCollectionView.contentSize.height);
    
    _vwScroll.contentSize = CGSizeMake(_vwScroll.frame.size.width,(_productCategoryCollectionView.frame.origin.y+_productCategoryCollectionView.frame.size.height+20)
                                       );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickedOpen:(id)sender {
    
    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;

    [elDrawer setDrawerState:KYDrawerControllerDrawerStateOpened animated:YES];
    

    
}

- (IBAction)btnQuickCheckout:(id)sender {
    QuickCheckOutViewController *forgotpasswordScreen = [[QuickCheckOutViewController alloc]initWithNibName:@"QuickCheckOutViewController" bundle:nil];
    [self.navigationController pushViewController:forgotpasswordScreen animated:YES];
}

- (IBAction)btnIndoorNav:(id)sender {
    
    IndoorMapViewController *indoorMapScreen = [[IndoorMapViewController alloc]initWithNibName:@"IndoorMapViewController" bundle:nil];
    [self.navigationController pushViewController:indoorMapScreen animated:YES];
    
}

- (IBAction)btnAddtoCart:(id)sender {
    
    if([_lblCount.text isEqualToString:@"0"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No product added in your cart.Shop more to proceed."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else{
        YourCartViewController *cartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
        [self.navigationController pushViewController:cartViewScreen animated:YES];
    }
   
}
-(void)getProductbyCategoryList:(NSString *)catId
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"cat=%@",catId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"productbycat.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                productbyCatlistInfo = [dict objectForKey:@"productlist"];
                
                if ([productbyCatlistInfo count]>0) {
                    
                    productbyCatlistfoDict = (NSDictionary *)[productbyCatlistInfo objectAtIndex:0];
                    
                    
                    //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                    //                    NSLog(@"DICT=====%@",dict);
                    //
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        ProductbycatViewController *productbycatScreen = [[ProductbycatViewController alloc]initWithNibName:@"ProductbycatViewController" bundle:nil];
                        productbycatScreen.productbyCatlistInfo = productbyCatlistInfo;
                        [self.navigationController pushViewController:productbycatScreen animated:YES];
                        
                        
                    });
                    //
                    //                    //                }
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
                [SVProgressHUD dismiss];
                
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

/* --------------------------------Navigine--------------------------------------- */

//-(void) setupNavigine{
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        if (!_imageView.image) {
//
//            NCLocation *location = [ZoneDetection sharedZoneDetection].navigineCore.location;
//            if ([location.sublocations count]) {
//
//                NCSublocation *sublocation = location.sublocations[0];
//
//                //    NSData *imageData = sublocation.pngImage;
//                UIImage *image = sublocation.image;//[UIImage imageWithData:imageData];
//
//                float scale = 1.f;
//
//                if (image.size.width / image.size.height >
//                    self.view.frame.size.width / self.view.frame.size.height) {
//                    scale = self.view.frame.size.height / image.size.height;
//                }
//                else {
//                    scale = self.view.frame.size.width / image.size.width;
//                }
//
//                _imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
//                _imageView.image = image;
//                _sv.contentSize = _imageView.frame.size;
//
//            } else {
//
//            }
//
//        } else {
//
//            NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
//                                              _imageView.height / _sv.zoomScale * (1. - res.ky));
//            });
//        }
//    });
//
//
//    //    [self drawZones];
//
//}


//-(void) setupNavigine {
//    if (!_imageView.image) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
////                    if (!_imageView.image) {
//
//            NSData *pngData = [NSData dataWithContentsOfFile:[[Common sharedCommon] indorMapImagePath]];
//            UIImage *image = [UIImage imageWithData:pngData];
//
//            if (!image) {
//
//
//                NCLocation *location = [ZoneDetection sharedZoneDetection].navigineCore.location;
//                if ([location.sublocations count]) {
//
//                    NCSublocation *sublocation = location.sublocations[0];
//
//                    //    NSData *imageData = sublocation.pngImage;
//                    UIImage *image = sublocation.image;//[UIImage imageWithData:imageData];
//
//                    float scale = 1.f;
//
//                    if (image.size.width / image.size.height >
//                        self.view.frame.size.width / self.view.frame.size.height) {
//                        scale = self.view.frame.size.height / image.size.height;
//                    }
//                    else {
//                        scale = self.view.frame.size.width / image.size.width;
//                    }
//
//                    _imageView.frame = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
//                    _imageView.image = image;
//                    _sv.contentSize = _imageView.frame.size;
//
//                    NSData *pngData = UIImagePNGRepresentation(image);
//                    NSString *filePath = [[Common sharedCommon] indorMapImagePath];
//                    [pngData writeToFile:filePath atomically:YES]; //Write the file
//
//                } else {
//
//                }
//
//            } else {
//
//                NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
//                                                  _imageView.height / _sv.zoomScale * (1. - res.ky));
//                });
//            }
////
////                    }
////                else {
////
////                }
//        });
//    }
//    else {
//
//    }
//
//
//
//
//
//
//    //    [self drawZones];
//
//}
-(void) setupNavigine{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!_imageView.image) {
            
            NSData *pngData = [NSData dataWithContentsOfFile:[[Common sharedCommon] indorMapImagePath]];
            UIImage *image = [UIImage imageWithData:pngData];
            
            if (!image) {
                
                NCLocation *location = [ZoneDetection sharedZoneDetection].navigineCore.location;
                if ([location.sublocations count]) {
                    
                    NCSublocation *sublocation = location.sublocations[0];
                    
                    //    NSData *imageData = sublocation.pngImage;
                    UIImage *image = sublocation.image;//[UIImage imageWithData:imageData];
                    
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
                    
                    NSData *pngData = UIImagePNGRepresentation(image);
                    NSString *filePath = [[Common sharedCommon] indorMapImagePath];
                    [pngData writeToFile:filePath atomically:YES]; //Write the file
                    
                } else {
                    
                }
                
            } else {
                
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
                
                NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
                if (res.error.code == 0) {
                    
                    _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
                                                  _imageView.height / _sv.zoomScale * (1. - res.ky));
                }
            }
            
        } else {
            
        }
        
    });
    
    
    
    
    //    [self drawZones];
    
}

/*- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
    
    NSDictionary* zone = nil;
    
    if (_zoneArray) {
        
        for (NSInteger i = 0; i < [_zoneArray count]; i++) {
            
            NSDictionary* dicZone = [_zoneArray objectAtIndex:i];
            
            NSArray* coordinates = [dicZone objectForKey:@"coordinates"];
            
            if ([coordinates count]>0) {
                
                UIBezierPath* path = [[UIBezierPath alloc]init];
                
                for (NSInteger j=0; j < [coordinates count]; j++) {
                    
                    NSDictionary* dicCoordinate = [coordinates objectAtIndex:j];
                    
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
*/
//- (void) navigationTicker {
//
//    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
//
//    NSLog(@"Error code:%zd",res.error.code);
//    if (res.error.code == 0) {
//
//        [self setupNavigine];
//
////        dispatch_async(dispatch_get_main_queue(), ^{
////
////            _current.center = CGPointMake(_imageView.width / _sv.zoomScale * res.kx,
////                                          _imageView.height / _sv.zoomScale * (1. - res.ky));
////        });
//
//    }
//    else {
//
//    }
//}
/*
-(void)enterZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"entry area"]) {
            
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
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            }
            
        }
        
    }
}*/


/* --------------------------------Navigine--------------------------------------- */
- (IBAction)backPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)postQRMatching:(NSString *)QRstr
-(void)categoriesProduct
{
    [SVProgressHUD show];
    
    //    NSString *userUpdate = [NSString stringWithFormat:@"bar_code=%@",QRstr];
    
    NSString *userUpdate = [NSString stringWithFormat:@""];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //    [api ApiRequestPOSTwithParameters:params WithUrlLastPart:@"login.php" completion:^(NSDictionary * dict, NSError *error) {
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"categories.php" completion:^(NSDictionary * dict, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                catlistInfo = [dict objectForKey:@"catlist"];
                
                if ([catlistInfo count]>0) {
                    
                    catlistfoDict = (NSDictionary *)[catlistInfo objectAtIndex:0];
                    
                    
                    //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                    //                    NSLog(@"DICT=====%@",dict);
                    //
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_productCategoryCollectionView reloadData];

//                        YourCartViewController *YourCartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
//
//                        YourCartViewScreen.ProductInfo = cartDetails.addToCartItems;
//                        //
//
//                        [self.navigationController pushViewController:YourCartViewScreen animated:YES];
                        
                    });
//
//                    //                }
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
                [SVProgressHUD dismiss];
                
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

-(void)getSubCategoryList:(NSString *)subCatId
{
    
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"sub_cat_id=%@",subCatId];
 
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    //    [api ApiRequestPOSTwithParameters:params WithUrlLastPart:@"login.php" completion:^(NSDictionary * dict, NSError *error) {
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"subcategories.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        isclicked = NO;
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                subCatlistInfo = [dict objectForKey:@"catlist"];
                
                if ([subCatlistInfo count]>0) {
                    
                    subCatlistfoDict = (NSDictionary *)[subCatlistInfo objectAtIndex:0];
                    
                    
                    //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                    //                    NSLog(@"DICT=====%@",dict);
                    //
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                           [Userdefaults setObject:@"true" forKey:@"isMenu"];
                        
                           [Userdefaults synchronize];
                        
                            SubCategoryViewController *subCatViewScreen = [[SubCategoryViewController alloc]initWithNibName:@"SubCategoryViewController" bundle:nil];
                        
                            subCatViewScreen.subCatlistInfo = subCatlistInfo;
                            [self.navigationController pushViewController:subCatViewScreen animated:YES];
                        
                        
                    });
                    //
                    //                    //                }
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
                [SVProgressHUD dismiss];
                
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

//for search

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [productlistingSearch count];
    //    return 5;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //    cell.imageView.image= [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",[[productlistingSearch objectAtIndex:indexPath.row] objectForKey:@"title"]];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    productId =[[productlistingSearch objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    [self getProductDetails:[NSString stringWithFormat:@"%@",[[productlistingSearch objectAtIndex:indexPath.row] objectForKey:@"id"]]];
    
    //    NSString *businessId = [[instructorlistingSearch objectAtIndex:indexPath.row] objectForKey:@"business_id"];
    //    [self getBusinessDetailsListing:businessId];
    
    
//    instructorID =[[instructorlistingSearch objectAtIndex:indexPath.row] objectForKey:@"id"];
//    [self getInstructorDetailsListing:[NSString stringWithFormat:@"%@",[[instructorlistingSearch objectAtIndex:indexPath.row] objectForKey:@"id"]]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    isTextFieldReturn = YES;
//    [connection cancel];
    if (productlistingSearch.count>0)
    {
        isDataAvailable = 1;
    }
    else
    {
        isDataAvailable = 0;
    }
    _vwScroll.contentSize = CGSizeMake(_vwScroll.frame.size.width,(_productCategoryCollectionView.frame.origin.y+_productCategoryCollectionView.frame.size.height+20)
                                       );
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([_txtFieldSearch.text length]>1){
        _tableViewSearch.hidden=NO;
    }
    else if([_txtFieldSearch.text length] < 1){
        _tableViewSearch.hidden=YES;
    }
    _vwScroll.contentSize = CGSizeMake(_vwScroll.frame.size.width,(_productCategoryCollectionView.frame.origin.y+_productCategoryCollectionView.frame.size.height+256)
                                       );
}
- (IBAction)searchOnTermEntered:(id)sender {
    
    if([_txtFieldSearch.text length] <= 2){
        _tableViewSearch.hidden=YES;
        productlistingSearch = [NSArray new];
        
    }
    
    if ([_txtFieldSearch.text length]>1){
        
        [self performSelector:@selector(searchTerm) withObject:self afterDelay:1.0];
    }
    
}

-(void)searchTerm{
//    [connection cancel];
    
    NSString *searchStr = [_txtFieldSearch.text stringByReplacingOccurrencesOfString: @" " withString:@"+"];
    
    if (searchStr.length >2) {
        
        [self search:searchStr];
    }
}

-(void)LoaderShow
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    spinner.tag = 7;
    
    _txtFieldSearch.rightView = spinner;
}

-(void)search:(NSString*)searchText
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"product_name=%@",searchText];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"productbyname.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                productlistingSearch = [dict objectForKey:@"productlist"];
                if ([[dict objectForKey:@"message"] isEqualToString:@"products are listed below"]) {
                    
                      productlistingSearch = [dict objectForKey:@"productlist"];
                    
                    if (isTextFieldReturn) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            _tableViewSearch.hidden=YES;
                            isTextFieldReturn = NO;
                            [SVProgressHUD dismiss];
                            
                        });
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [_tableViewSearch reloadData];
                            _tableViewSearch.hidden=NO;
                            isTextFieldReturn = NO;
                            
                        });
                        
                    }
                    //_txtFieldSearch.userInteractionEnabled =YES;
                    
                }
                
                else if ([[dict objectForKey:@"message"] isEqualToString:@"This name doesnot matched with any product, please try again later"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _tableViewSearch.hidden = YES;
                        productlistingSearch = [NSArray new];
                        
                        [_tableViewSearch reloadData];
                        
                    });
                    
                    // _txtFieldSearch.userInteractionEnabled =YES;
                    
                }
                
//                if ([productbyDetailslistInfo count]>0) {
//
//                    productbyDetailslistfoDict = (NSDictionary *)[productbyDetailslistInfo objectAtIndex:0];
//
//                    //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
//                    //                    NSLog(@"DICT=====%@",dict);
//                    //
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
////                        ProductDetailsViewController *productbyDetailsScreen = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
////                        productbyDetailsScreen.productbyDetailslistInfo = productbyDetailslistInfo;
////                        [self.navigationController pushViewController:productbyDetailsScreen animated:YES];
//
//
//                    });
//                    //
//                    //                    //                }
//
//                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        _tableViewSearch.hidden = YES;
                        productlistingSearch = [NSArray new];
                        
                        [_tableViewSearch reloadData];
                    
                    });
                    
//                    NSString *msg = [jsonDict objectForKey:@"message"];
//                    NSLog(@"msg::%@",msg);
//                    _messageTextView.text = msg ;
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
                _tableViewSearch.hidden = YES;
                
                [_tableViewSearch reloadData];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
               
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                     [alertView show];
                    
                });
            }
        }
    }];
    
}

-(void)getProductDetails:(NSString *)productId
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"product_id=%@",productId];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"productbyproductid.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                productbyDetailslistInfo = [dict objectForKey:@"productlist"];
                
                if ([productbyDetailslistInfo count]>0) {
                    
                    productbyDetailslistfoDict = (NSDictionary *)[productbyDetailslistInfo objectAtIndex:0];
                    
                    //                    NSDictionary *dict = [ProfDict dictionaryByReplacingNullsWithBlanks];
                    //                    NSLog(@"DICT=====%@",dict);
                    //
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        ProductDetailsViewController *productbyDetailsScreen = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
                        productbyDetailsScreen.productbyDetailslistInfo = productbyDetailslistInfo;
                        [self.navigationController pushViewController:productbyDetailsScreen animated:YES];
                        
                    });
                    //
                    //                    //                }
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
                [SVProgressHUD dismiss];
                
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

//Offer details Api
-(void)getOfferList
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@""];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"alloffers.php" completion:^(NSDictionary * dict, NSError *error) {
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                offerslistInfo = [dict objectForKey:@"offerslist"];
                
                if ([offerslistInfo count]>0) {
                    
                    offerslistDict = (NSDictionary *)[offerslistInfo objectAtIndex:0];
                    
                    for (NSDictionary *dict in offerslistInfo) {
                        
                        [bannerImages addObject:[dict objectForKey:@"imagepath"]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [_indicatorView setHidden:NO];
                        [_indicatorView startAnimating];
                        
                    });
                    
                    [self addBannerSliderWithArray:bannerImages];
                    
                       [SVProgressHUD dismiss];
                    
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with login, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                
            } else {
                
                [SVProgressHUD dismiss];
                
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

-(void)getDiscount
{
    [SVProgressHUD show];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:locale];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *inTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [Userdefaults setObject:inTimeStr forKey:@"inTimeStr"];
    
    [Userdefaults synchronize];
    
    NSString *userUpdate = [NSString stringWithFormat:@"zone_code=%@",@"1"];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"discountbyzonecode.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                BOOL offerDescription = [Userdefaults boolForKey:[NSString stringWithFormat:@"offerDescription:%@",@"1"]];
                
                if (offerDescription==NO)
                {
                    NSDictionary *discountlist = [[dict objectForKey:@"Discountlist"] objectAtIndex:0];
                    
                    UILocalNotification *notification = [[UILocalNotification alloc] init];
                    notification.fireDate = [NSDate date];
                    notification.alertBody = [NSString stringWithFormat:@"%@",[discountlist objectForKey:@"offer_description"]];
                    notification.timeZone = [NSTimeZone localTimeZone];
                    notification.userInfo = discountlist;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    //   notification.applicationIconBadgeNumber = 1;
                    notification.repeatInterval=0;
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    
                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"offerDescription:%@",@"1"]];
                    
                    [Userdefaults synchronize];
                    
                }
                
                
            } else {
                
                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
            }
        }
    }];
    
}


///////////////////////////////////////////NAvigine///////////////////////////////////////////////////////////////////

- (void)navigationTicker
{
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    
    NSLog(@"Error code:%zd",res.error.code);
    
    if (res.error.code == 0) {
         [self setupNavigine];
        
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // [self performSelector:@selector(navigateForProduct) withObject:nil afterDelay:0.3];
            
        });
        
    }
    else {
        
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


-(void)enterZoneWithZoneName:(NSString *)zoneName {
    
    // int zoneInt = (int)[_zoneId integerValue];
    
    // NSString *StrzoneName =  [self.arrNames objectAtIndex:(zoneInt - 1)];
    
    if (zoneName) {
        
        if ([zoneName isEqualToString:@"conference area"]) {
            
            [self zoneByUser:@"4"];
            [self getDiscount:@"4"];
            
        } else if ([zoneName isEqualToString:@"marketing room"]) {
            
            [self zoneByUser:@"6"];
            [self getDiscount:@"6"];
            
        }
        else if ([zoneName isEqualToString:@"Developers 1"]) {
            
            [self zoneByUser:@"3"];
            [self getDiscount:@"3"];
            
            
        }
        else if ([zoneName isEqualToString:@"conference room small"])
        {
            
            [self zoneByUser:@"1"];
            [self getDiscount:@"1"];
            
        }
        else if ([zoneName isEqualToString:@"Developers 2"]) {
            
            [self zoneByUser:@"5"];
            [self getDiscount:@"5"];
            
        }
        else if ([zoneName isEqualToString:@"service desk"]) {
            
            [self zoneByUser:@"2"];
            [self getDiscount:@"2"];
            
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
                
//                _zoneId = @"";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            }
            
        }
        
    }
}


-(void)exitZoneWithZoneName:(NSString *)zoneName {
    
    if (zoneName) {
        
    }
}
-(void)getDiscount:(NSString *)zoneID
{
    [SVProgressHUD show];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [dateFormatter setLocale:locale];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *inTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    
    [Userdefaults setObject:inTimeStr forKey:@"inTimeStr"];
    
    [Userdefaults synchronize];
    
    NSString *userUpdate = [NSString stringWithFormat:@"zone_code=%@",zoneID];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"discountbyzonecode.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                BOOL offerDescription = [Userdefaults boolForKey:[NSString stringWithFormat:@"offerDescription:%@",zoneID]];
                
                                if (offerDescription==NO)
                                {
                NSDictionary *discountlist = [[dict objectForKey:@"Discountlist"] objectAtIndex:0];
                
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
                
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"offerDescription:%@",zoneID]];
                                    [Userdefaults synchronize];
                
                                }
                
                
            } else {
                
                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
            }
        }
    }];
    
}
-(void)zoneByUser:(NSString *)zoneID
{
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&zone_id=%@",userId,zoneID];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"zone_by_user.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
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
                
                [SVProgressHUD dismiss];
                
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


@end
