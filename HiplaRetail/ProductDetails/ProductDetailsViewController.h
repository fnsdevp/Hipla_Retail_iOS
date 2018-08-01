//
//  ProductDetailsViewController.h
//  Jing
//
//  Created by fnspl3 on 12/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDetails.h"
#import "JScrollView+PageControl+AutoScroll.h"
#import "APIManager.h"

@interface ProductDetailsViewController : UIViewController<JScrollViewViewDelegate>
{
    CartDetails* cartDetails;
    APIManager *api;
    
}
- (IBAction)btnBack:(id)sender;
- (IBAction)btnLike:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVW;
@property (weak, nonatomic) IBOutlet UIView *viewFirst;
@property (weak, nonatomic) IBOutlet UIView *viewSecond;
@property (weak, nonatomic) IBOutlet UIView *viewThird;
@property (weak, nonatomic) IBOutlet UILabel *lblRupees;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDetails;
@property (weak, nonatomic) IBOutlet UIView *navigateView;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigate;

@property NSMutableArray* productbyDetailslistInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *viewProduct;

@property (weak,nonatomic) IBOutlet UIView *vwPaging;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

- (IBAction)btnProductScan:(id)sender;


- (IBAction)btnClickNavigate:(id)sender;


@end
