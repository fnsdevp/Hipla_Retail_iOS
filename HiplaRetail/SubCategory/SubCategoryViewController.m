//
//  SubCategoryViewController.m
//  Jing
//
//  Created by fnspl3 on 12/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "SubCategoryViewController.h"
#import "SubCategoryCollectionViewCell.h"
#import "ProductDetailsViewController.h"
#import "YourCartViewController.h"
#import "ProfileViewController.h"
#import "ProductCategoryViewController.h"
#import "UIImageView+WebCache.h"
#import "ProductbycatViewController.h"
#import "CartDetails.h"
#import "IndoorMapViewController.h"

@interface SubCategoryViewController (){
    
    NSMutableArray *productbyCatlistInfo;
    NSDictionary *productbyCatlistfoDict;
    NSString *countStr;
    NSString *zoneId;
    
    NSString *userId;
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

@end

@implementation SubCategoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    
    userId = [NSString stringWithFormat:@"%@",[self.ProfInfo objectForKey:@"id"]];
    
    self.arrNames = [[NSMutableArray alloc] initWithObjects:@"conference room small",@"service desk",@"Developers 1",@"conference area",@"Developers 2",@"marketing room",nil];
    
    self.arrPointx = [[NSMutableArray alloc] initWithObjects:@"14.19",@"14.42",@"11.81",@"22.43",@"11.53",@"14.23", nil];
    
    self.arrPointy = [[NSMutableArray alloc] initWithObjects:@"39.24",@"34.25",@"26.63",@"19.69",@"21.31",@"12.20", nil];
    _viewCount.layer.cornerRadius= _viewCount.frame.size.height/2;
    
    [self.navigationController.navigationBar setHidden:YES];
    
    api = [APIManager sharedManager];
    
//    [self.subcategoryCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SubCategoryCollectionViewCell"];
//    
//    [self.subcategoryCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@" SubCategoryCollectionViewCell"];
    
//    [self.subcategoryCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCollectionViewCell" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SubCategoryCollectionViewCell"];
    
    [self.subcategoryCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCollectionViewCell" bundle:[NSBundle mainBundle]]
                     forCellWithReuseIdentifier:@"SubCategoryCollectionViewCell"];
    
    [_subcategoryCollectionView setDataSource:self];
    [_subcategoryCollectionView setDelegate:self];
    
//    number = 0;
//    totalCount = 0;
    
//    NSMutableArray *ProductInfo = [Userdefaults objectForKey:@"CartDetails"];
//
//    for (int i=0; i<[ProductInfo count]; i++)
//    {
//        number = (int)[[Userdefaults objectForKey:[NSString stringWithFormat:@"Product:%d",(int)i]] integerValue];
//
//        totalCount = number + totalCount;
//    }
//    countStr=[Userdefaults objectForKey:@"isCount"];
//    _lblCount.text = countStr;
    
    NSInteger curtItems = [[CartDetails sharedInstanceCartDetails] countCartItems];
    countStr = [NSString stringWithFormat:@"%ld",curtItems];
    //    countStr=[Userdefaults objectForKey:@"isCount"];
    _lblCount.text = countStr;
    
    if([_lblCount.text isEqualToString:@"0"]){
        _viewCount.hidden=YES;
    }
    else{
        _viewCount.hidden=NO;
    }
 
//    [[ZoneDetection sharedZoneDetection] navigineSetup];
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[ZoneDetection sharedZoneDetection] setDelegate:self];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[ZoneDetection sharedZoneDetection] setDelegate:nil];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//     return 4;
     return [_subCatlistInfo count];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"SubCategoryCollectionViewCell";
    
    SubCategoryCollectionViewCell *cell = (SubCategoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *dict = [_subCatlistInfo objectAtIndex:indexPath.row];
    
//    cell.lblSubName.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
    
//    [cell.indicatorView setHidden:NO];
//    [cell.indicatorView startAnimating];
    
    cell.btnNavigateOutlet.tag=indexPath.row;
    
    [cell.btnNavigateOutlet addTarget:self action:@selector(btnNavigate:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.imgView.image = nil;
    
    NSString *imgURL= [NSString stringWithFormat:@"%@",[dict objectForKey:@"image"]];
    imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell setProductImgUrl:imgURL];
    [cell setProductName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]]];
    
    [cell updateCell];
    
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadImageWithURL:[NSURL URLWithString:imgURL]
//                          options:0
//                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                             // progression tracking code
//                             NSLog(@"receivedSize %ld",(long)receivedSize);
//                         }
//                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//
//                            if (image) {
//                                // do something with image
//                                cell.imgView.image = image;
//
//                                [cell.indicatorView setHidden:YES];
//                                [cell.indicatorView stopAnimating];
//
//
//                            }
//                        }];
//
//    [cell.imgView setContentMode:UIViewContentModeScaleAspectFit];
    ///////////////////////////////////////////////////////////////////////////////////////////
    
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
    
    return CGSizeMake(SCREENWIDTH/3-9.0,211);
//    return CGSizeMake(98.0,211);
    
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
    return UIEdgeInsetsMake(1,6,1,6);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    ProductDetailsViewController *productViewScreen = [[ProductDetailsViewController alloc]initWithNibName:@"ProductDetailsViewController" bundle:nil];
//    [self.navigationController pushViewController:productViewScreen animated:YES];
//    
//    ProfileViewController *cartViewScreen = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
//    [self.navigationController pushViewController:cartViewScreen animated:YES];
    
    // NSDictionary *dict = [categoryListing objectAtIndex:indexPath.row];
    //  [self getSubCategoryList:[dict objectForKey:@"id"]];
    
//    [self getBusinessListing:[NSString stringWithFormat:@"%@",[[[_subCategoryListing objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"id"]]];
//    
//    catName = [[[_subCategoryListing objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"cat_name"];
    
    NSDictionary *dict = [_subCatlistInfo objectAtIndex:indexPath.row];
    NSString *hasChild = [NSString stringWithFormat:@"%@",[dict objectForKey:@"has_child"]];
    NSLog(@"hasChild=== %@",hasChild);
    
    if([hasChild isEqualToString:@"0"]){
        
        NSDictionary *dict = [_subCatlistInfo  objectAtIndex:indexPath.row];
        
        NSString *catIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"catid"]];
        
        [self getProductbyCategoryList:catIdStr];
        
    }
    
}
- (void)btnNavigate:(UIButton *)sender{
    
    if ([_subCatlistInfo count] > (int)sender.tag) {
     
        NSDictionary *dict = [_subCatlistInfo objectAtIndex:(int)sender.tag];
        zoneId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"zoneId"]];
        if (_indoorMapScreen) {
            
            _indoorMapScreen = nil;
            
        } else {
            
        }
        _indoorMapScreen = [[IndoorMapViewController alloc]initWithNibName:@"IndoorMapViewController" bundle:nil];
        _indoorMapScreen.zoneId=zoneId;
        [self.navigationController pushViewController:_indoorMapScreen animated:YES];
        
    } else {
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menuBtn:(id)sender {
}

- (IBAction)addToCart:(id)sender {
    
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

- (IBAction)searchBtn:(id)sender {
    
}

- (IBAction)homeBtn:(id)sender {
    
//    [self.navigationController popViewControllerAnimated:YES];
    BOOL isHasProductCat = NO;
    NSArray* arrViewControllers = self.navigationController.viewControllers;
    for (id viewController in arrViewControllers) {
        if ([viewController isKindOfClass:[ProductCategoryViewController class]]) {
            
            isHasProductCat = YES;
            ProductCategoryViewController* prdCatVC = (ProductCategoryViewController *)viewController;
            [self.navigationController popToViewController:prdCatVC animated:YES];
            break;
        }
        
    }
    
    if (!isHasProductCat) {
        
        ProductCategoryViewController *productCategoryViewControllerScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
        [self.navigationController pushViewController:productCategoryViewControllerScreen animated:YES];
        
    } else {
        
    }
//    ProductCategoryViewController *productCategoryViewControllerScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
//    [self.navigationController pushViewController:productCategoryViewControllerScreen animated:YES];
    
}
- (IBAction)clickedOpen:(id)sender {
    
    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    [elDrawer setDrawerState:KYDrawerControllerDrawerStateOpened animated:YES];
}

///////////////////////////////////////////NAvigine///////////////////////////////////////////////////////////////////

- (void)navigationTicker
{
    NCDeviceInfo *res = [ZoneDetection sharedZoneDetection].navigineCore.deviceInfo;
    
    NSLog(@"Error code:%zd",res.error.code);
    
    if (res.error.code == 0) {
        
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
                
                BOOL offerDescription = [Userdefaults boolForKey:[NSString stringWithFormat:@"offerDescription:%@",zoneId]];
                
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
                
                                    [Userdefaults setBool:YES forKey:[NSString stringWithFormat:@"offerDescription:%@",zoneId]];
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
