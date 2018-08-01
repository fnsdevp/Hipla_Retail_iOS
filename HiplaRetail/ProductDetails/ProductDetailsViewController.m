//
//  ProductDetailsViewController.m
//  Jing
//
//  Created by fnspl3 on 12/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//
#import "ProductDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "ProductCategoryViewController.h"
#import "ProductbycatViewController.h"
#import "IndoorMapViewController.h"
#import "ProductCategoryViewController.h"
#import "QuickCheckOutViewController.h"
#import "UIImageView+WebCache.h"


@interface ProductDetailsViewController (){
    
    CGFloat viewSecondHeight;
    NSString *lblCountStr;
    NSDictionary *ProfInfo;
    NSString *userId;
    NSString *productId;
    NSMutableArray *viewsArray;
    NSMutableArray *bannerImages;
    NSString *zoneId;

}

@end


@implementation ProductDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    api = [APIManager sharedManager];
    _navigateView.layer.cornerRadius = 5.0f;
    _viewProduct.layer.cornerRadius = 5.0f;
    _navigateView.clipsToBounds = YES;
    
    bannerImages = [[NSMutableArray alloc]init];
    NSMutableArray *images = [[NSMutableArray alloc]init];
    
    ProfInfo = [Userdefaults objectForKey:@"ProfInfo"];
    userId = [NSString stringWithFormat:@"%@",[ProfInfo objectForKey:@"id"]];
    
    NSLog(@"productbyDetailslistInfo===%@",_productbyDetailslistInfo);
    NSDictionary *dict = (NSDictionary*)[_productbyDetailslistInfo objectAtIndex:0];
    
    _lblProductDetails.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
    _lblProductName.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
    _lblRupees.text=[NSString stringWithFormat:@"Rs/-%@ ",[dict objectForKey:@"price"]];
    productId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    zoneId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"zone_id"]];
    
     images=[dict objectForKey:@"images"];
    
    for (int i=0;i<[images count];i++) {
        
        NSString *imgURL= [NSString stringWithFormat:@"%@/%@",[dict objectForKey:@"url"],[images objectAtIndex:i]];
        
        [bannerImages addObject:imgURL];
        
    }
 
    [self addBannerSliderWithArray:bannerImages];
    
//    _imgView.image = nil;
//
//    NSString *imgURL= [NSString stringWithFormat:@"http://www.eegrab.com/retails/admin/hiplaretailadmin/resources/image/product/%@/%@",[dict objectForKey:@"product_image_folder"],[dict objectForKey:@"product_image"]];
//    imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
//                                _imgView.image = image;
//
//                                //                                [cell.indicatorView setHidden:YES];
//                                //                                [cell.indicatorView stopAnimating];
//
//                            }
//                        }];
//
//    [_imgView setContentMode:UIViewContentModeScaleAspectFit];
    
    _lblProductDetails.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    CGRect newFrame = _lblProductDetails.frame;
    
    newFrame.size = [self heigtForLabelwithString:_lblProductDetails.text withFont:_lblProductDetails.font andWidth:_lblProductDetails.frame.size.width];
    
    _lblProductDetails.frame = newFrame;
    
    
    _viewSecond.frame = CGRectMake(_viewSecond.frame.origin.x, _viewFirst.frame.origin.y + _viewFirst.frame.size.height+5, (_viewSecond.frame.size.width - 20),(_lblProductDetails.frame.origin.y+_lblProductDetails.frame.size.height+20));
    
    viewSecondHeight = _viewSecond.frame.origin.y + _viewSecond.frame.size.height;
    
    //    _scrollVW.frame = CGRectMake(_scrollVW.frame.origin.x, _scrollVW.frame.origin.y, _scrollVW.frame.size.width, viewSecondHeight);
    
    _scrollVW.contentSize = CGSizeMake(_viewSecond.frame.size.width, viewSecondHeight);
    
}


-(void)viewDidAppear:(BOOL)animated{
    
//    _lblProductDetails.frame = CGRectMake(_lblProductDetails.frame.origin.x, _lblProductName.frame.origin.y + _lblProductName.frame.size.height+5, _lblProductDetails.frame.size.width,_lblProductDetails.frame.size.height);
    
//    NSDictionary *dict = (NSDictionary*)[_productbyDetailslistInfo objectAtIndex:0];
//
//    _lblProductDetails.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
//    _lblProductName.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
//    _lblRupees.text=[NSString stringWithFormat:@"%@ Rs/- each",[dict objectForKey:@"price"]];
//    _imgView.image = nil;
//
//    NSString *imgURL= [NSString stringWithFormat:@"http://www.eegrab.com/retails/admin/hiplaretailadmin/resources/image/product/%@/%@",[dict objectForKey:@"product_image_folder"],[dict objectForKey:@"product_image"]];
//    imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
//                                _imgView.image = image;
//
//                                //                                [cell.indicatorView setHidden:YES];
//                                //                                [cell.indicatorView stopAnimating];
//
//
//                            }
//                        }];
//
//    [_imgView setContentMode:UIViewContentModeScaleAspectFit];
//    _lblProductDetails.text = @"Loved for their creamy texture and heart healthy unsaturated fat , versatile avocado can be added to everything from salad to smoothees and dessert recipes.";
    
//    _lblProductDetails.lineBreakMode = NSLineBreakByWordWrapping;
//
//
//    CGRect newFrame = _lblProductDetails.frame;
//
//    newFrame.size = [self heigtForLabelwithString:_lblProductDetails.text withFont:_lblProductDetails.font andWidth:_lblProductDetails.frame.size.width];
//
//    _lblProductDetails.frame = newFrame;
//
//
//    _viewSecond.frame = CGRectMake(_viewSecond.frame.origin.x, _viewFirst.frame.origin.y + _viewFirst.frame.size.height+5, (_viewSecond.frame.size.width - 20),(_lblProductDetails.frame.origin.y+_lblProductDetails.frame.size.height+20));
//
//    viewSecondHeight = _viewSecond.frame.origin.y + _viewSecond.frame.size.height;
//
////    _scrollVW.frame = CGRectMake(_scrollVW.frame.origin.x, _scrollVW.frame.origin.y, _scrollVW.frame.size.width, viewSecondHeight);
//
//    _scrollVW.contentSize = CGSizeMake(_viewSecond.frame.size.width, viewSecondHeight);

}

-(void)addBannerSliderWithArray:(NSMutableArray *)arr{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        //Background Thread
        viewsArray = [[NSMutableArray alloc]init];
        
        for (int i=0; i<[arr count]; i++) {
            
                        [_indicatorView setHidden:NO];
                        [_indicatorView startAnimating];
            //
            
            NSString *strImg = [NSString stringWithFormat:@"%@",[arr objectAtIndex:i]];
            NSString* encodedString = [strImg stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
            NSURL *url = [NSURL URLWithString:encodedString];
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
            
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            
            [viewsArray addObject:imageView];
            
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

-(CGSize)heigtForLabelwithString:(NSString *)stringValue withFont:(UIFont *)font andWidth:(CGFloat)Width{
    
    CGSize constraint = CGSizeMake((SCREENWIDTH- 20),9999);
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [stringValue boundingRectWithSize:constraint
                                            options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil];
    
    return rect.size;
    
}

- (IBAction)btnBack:(id)sender {
    
 [self.navigationController popViewControllerAnimated:YES];
    
//    ProductCategoryViewController *ProductCategoryScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
//    [self.navigationController pushViewController:ProductCategoryScreen animated:YES];
    
}

- (IBAction)btnLike:(id)sender {
    
//    NSDictionary *dict = (NSDictionary *)[_productbyDetailslistInfo objectAtIndex:0];
//    cartDetails = [CartDetails sharedInstanceCartDetails];
//    [cartDetails addItemsInCard:dict];
//    dispatch_async(dispatch_get_main_queue(), ^{
    
    [self addFavourite];
        
//     });
}

- (IBAction)btnProductScan:(id)sender {
    
    QuickCheckOutViewController *quickCheckOutScreen = [[QuickCheckOutViewController alloc]initWithNibName:@"QuickCheckOutViewController" bundle:nil];
    [self.navigationController pushViewController:quickCheckOutScreen animated:YES];
}

- (IBAction)btnClickNavigate:(id)sender {
    
    IndoorMapViewController *indoorMapScreen = [[IndoorMapViewController alloc]initWithNibName:@"IndoorMapViewController" bundle:nil];
    indoorMapScreen.zoneId=zoneId;
    indoorMapScreen.productId=productId;
    [self.navigationController pushViewController:indoorMapScreen animated:YES];
    
}
-(void)addFavourite

{
    
    [SVProgressHUD show];
    
    NSString *userUpdate = [NSString stringWithFormat:@"user_id=%@&product_id=%@",userId,productId];
    
    NSLog(@"userUpdate===%@",userUpdate);
    //Convert the String to Data
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    [api ApiRequestPOSTwithPostdata:data WithUrlLastPart:@"addfavourite.php" completion:^(NSDictionary * dict, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"%@",dict);
        
        NSLog(@"%@",error);
        
        if (!error) {
            
            NSString *successStr = [dict objectForKey:@"status"];
            
            if ([successStr isEqualToString:@"success"]) {
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@"Product is successfully added to the favourite."
                                             message:nil
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             
                                             ProductCategoryViewController *productCategoryScreen = [[ProductCategoryViewController alloc]initWithNibName:@"ProductCategoryViewController" bundle:nil];
                                             [self.navigationController pushViewController:productCategoryScreen animated:YES];
                                             
                                         });
                                         
                                     }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
                
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Product is successfully added to the favourite"
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"Ok"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
//                    [SVProgressHUD dismiss];
                
            }
            else if ([successStr isEqualToString:@"failure"]) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry! this already as favourite"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                [SVProgressHUD dismiss];
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
