//
//  ZoneViewController.m
//  Jing
//
//  Created by fnspl3 on 04/01/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "ZoneViewController.h"
#import "SubCategoryViewController.h"
#import "SubCategoryCollectionViewCell.h"
#import "ProductDetailsViewController.h"
#import "YourCartViewController.h"
#import "ProfileViewController.h"
#import "ProductCategoryViewController.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailsViewController.h"
#import "IndoorMapViewController.h"

@interface ZoneViewController (){
    
    NSMutableArray *productbyDetailslistInfo;
    NSDictionary *productbyDetailslistfoDict;
    NSString *countStr;
    
    NSMutableArray *productbyzonecodelistInfo;
    NSDictionary *productbyzonecodelistDict;
    NSString *zoneCodeStr;
    NSString *zoneId;
    
}

@end

@implementation ZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setHidden:YES];
    
    zoneCodeStr = [NSString stringWithFormat:@"%d",(int)[[self.discountlist objectForKey:@"zone_id"] integerValue]];
    
    NSLog(@"zoneCode==%@",zoneCodeStr);
    _viewCount.layer.cornerRadius = _viewCount.frame.size.height/2;
    api = [APIManager sharedManager];
    [self getProductbyZoneCode];
    
    //    [self.subcategoryCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SubCategoryCollectionViewCell"];
    //
    //    [self.subcategoryCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@" SubCategoryCollectionViewCell"];
    
    //    [self.subcategoryCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCollectionViewCell" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SubCategoryCollectionViewCell"];
    
    [self.subcategoryCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCollectionViewCell" bundle:[NSBundle mainBundle]]
                     forCellWithReuseIdentifier:@"SubCategoryCollectionViewCell"];
    
    [_subcategoryCollectionView setDataSource:self];
    [_subcategoryCollectionView setDelegate:self];
    
    //    countStr=[Userdefaults objectForKey:@"isCount"];
    //    _lblCount.text = countStr;
    NSInteger curtItems = [[CartDetails sharedInstanceCartDetails] countCartItems];
    countStr = [NSString stringWithFormat:@"%ld",curtItems];
    //    countStr=[Userdefaults objectForKey:@"isCount"];
    _lblCount.text = countStr;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //     return 4;
    
    return [productbyzonecodelistInfo count];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"SubCategoryCollectionViewCell";
    
    SubCategoryCollectionViewCell *cell = (SubCategoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSDictionary *dict = [productbyzonecodelistInfo objectAtIndex:indexPath.row];
    
//    cell.lblSubName.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"category_name"]];
    
    if (self.discountlist!=nil) {
        
        float OriginalPrice = ((int)[[dict objectForKey:@"price"] integerValue]*100)/(100 -(float)[[NSString stringWithFormat:@"%@",[self.discountlist objectForKey:@"discount_percentage"]] floatValue]);
        
        NSString *OriginalPriceStr = [NSString stringWithFormat:@"%0.2f",OriginalPrice];
        
        NSString *finalStr = [NSString stringWithFormat:@"Rs/-%@ ",OriginalPriceStr];
        
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:finalStr attributes:attributes];
        
        [cell setOriginalPrice:str];
    }
    
//    cell.lblRupees.text=[NSString stringWithFormat:@"%@ Rs/-",[dict objectForKey:@"price"]];
//    cell.lblEach.text=@"Each";
    
    cell.btnNavigateOutlet.tag=indexPath.row;
    [cell.btnNavigateOutlet addTarget:self action:@selector(btnNavigate:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//    cell.imgView.image = nil;
//
//    NSString *imgURL= [NSString stringWithFormat:@"http://www.eegrab.com/retails/admin/hiplaretailadmin/resources/image/product/%@/%@",[dict objectForKey:@"product_image_folder"],[dict objectForKey:@"product_image"]];
     NSString *imgURL= [NSString stringWithFormat:@"%@/%@",[dict objectForKey:@"url"],[dict objectForKey:@"product_image"]];
    imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell setProductImgUrl:imgURL];
    [cell setProductName:[NSString stringWithFormat:@"%@",[dict objectForKey:@"category_name"]]];
    [cell setRupees:[NSString stringWithFormat:@"Rs/-%@ ",[dict objectForKey:@"price"]]];
    cell.lblEach.text=@"";
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
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
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
    
    NSDictionary *dict = [productbyzonecodelistInfo objectAtIndex:indexPath.row];
    NSString *productIdStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSLog(@"productIdStr=== %@",productIdStr);
    
    [self getProductDetails:productIdStr];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)btnNavigate:(UIButton *)sender{
    NSDictionary *dict = [productbyzonecodelistInfo objectAtIndex:(int)sender.tag];
    zoneId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"zone_id"]];
    IndoorMapViewController *indoorMapScreen = [[IndoorMapViewController alloc]initWithNibName:@"IndoorMapViewController" bundle:nil];
    indoorMapScreen.zoneId=zoneId;
    [self.navigationController pushViewController:indoorMapScreen animated:YES];
}
- (IBAction)menuBtn:(id)sender {
    
}

- (IBAction)addToCart:(id)sender {
    
    YourCartViewController *cartViewScreen = [[YourCartViewController alloc]initWithNibName:@"YourCartViewController" bundle:nil];
    [self.navigationController pushViewController:cartViewScreen animated:YES];
}

- (IBAction)searchBtn:(id)sender {
    
}

- (IBAction)homeBtn:(id)sender {
    
    ProductCategoryViewController* prdCatVC = nil;
    NSArray* arrViewControllers = self.navigationController.viewControllers;
    for (id viewController in arrViewControllers) {
        if ([viewController isKindOfClass:[ProductCategoryViewController class]]) {
            prdCatVC = (ProductCategoryViewController *)viewController;
            break;
        }

    }
    
    if (prdCatVC) {
        
        [self.navigationController popToViewController:prdCatVC animated:YES];

    } else {
        
        ProductCategoryViewController *productCategoryViewControllerScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
        [self.navigationController pushViewController:productCategoryViewControllerScreen animated:YES];
        
    }
    
}

- (IBAction)clickedOpen:(id)sender {
    
    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    [elDrawer setDrawerState:KYDrawerControllerDrawerStateOpened animated:YES];
    
}
///////////////////////////////////////////////////////////////////////////////

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
-(void)getProductbyZoneCode
{
    [SVProgressHUD show];
    
//    NSString *userUpdate = [NSString stringWithFormat:@"zone_code=4"];
    NSString *userUpdate = [NSString stringWithFormat:@"zone_code=%@",zoneCodeStr];
    
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"productbyzonecode.php" completion:^(NSDictionary * dict, NSError *error) {
        
        //        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                
                productbyzonecodelistInfo = [dict objectForKey:@"productlist"];
                
                if ([productbyzonecodelistInfo count]>0) {
                    
                    productbyzonecodelistDict = (NSDictionary *)[productbyzonecodelistInfo objectAtIndex:0];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.subcategoryCollectionView reloadData];
                        
                    });
                    [SVProgressHUD dismiss];
                }
                else{
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [SVProgressHUD dismiss];
                    
                    
                }
                //               });
            } else {
                
                [SVProgressHUD dismiss];
                
                NSLog(@"Error: %@", error);
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There have some problem with order history, try again later."
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
    
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

@end
