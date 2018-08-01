//
//  QRViewController.m
//  Jing
//
//  Created by fnspl3 on 22/11/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "QRViewController.h"
#import "OrderHistoryViewController.h"
#import "OrderHistoryDetailTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface QRViewController ()

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setHidden:YES];
    NSLog(@"qrStr==%@",_orderUniqueIdStr);
    
    _imgView.image = [self createQRForString:_orderUniqueIdStr];
}


- (UIImage *)createQRForString:(NSString *)imagename {
    
    // Generation of QR code image
    NSData *qrCodeData = [imagename dataUsingEncoding:NSISOLatin1StringEncoding]; // recommended encoding
    CIFilter *qrCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrCodeFilter setValue:qrCodeData forKey:@"inputMessage"];
    [qrCodeFilter setValue:@"M" forKey:@"inputCorrectionLevel"]; //default of L,M,Q & H modes
    
    CIImage *qrCodeImage = qrCodeFilter.outputImage;
    
    CGRect imageSize = CGRectIntegral(qrCodeImage.extent); // generated image size
    CGSize outputSize = CGSizeMake(240.0, 240.0); // required image size
    CIImage *imageByTransform = [qrCodeImage imageByApplyingTransform:CGAffineTransformMakeScale(outputSize.width/CGRectGetWidth(imageSize), outputSize.height/CGRectGetHeight(imageSize))];
    
    UIImage *qrCodeImageByTransform = [UIImage imageWithCIImage:imageByTransform];
    
    return qrCodeImageByTransform;
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

- (IBAction)btnBack:(id)sender {
    [_orderUniqueIdStr stringByRemovingPercentEncoding];
    OrderHistoryViewController *orderHistoryCategoryScreen = [[OrderHistoryViewController alloc]initWithNibName:@"OrderHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:orderHistoryCategoryScreen animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_orderhistoryDetailsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"OrderHistoryDetailTableViewCell";
    
    OrderHistoryDetailTableViewCell *cell = (OrderHistoryDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderHistoryDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    if ([_orderhistoryDetailsArr count]>0) {
        
        NSDictionary *dict = [_orderhistoryDetailsArr objectAtIndex:indexPath.row];
        
        cell.lblCatName.text=[NSString stringWithFormat:@"%@",[dict objectForKey:@"category_name"]];
        cell.lblPrice.text=[NSString stringWithFormat:@"Rs. %@/-",[dict objectForKey:@"price"]];
        
        [cell.indicatorView startAnimating];
        cell.imgCatView.image = nil;
        
        NSString *imgURL= [NSString stringWithFormat:@"http://cxc.gohipla.com/retail/admin/resources/image/product/%@/%@",[dict objectForKey:@"product_image_folder"],[dict objectForKey:@"product_image"]];

        imgURL = [imgURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:imgURL]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 
                                 // progression tracking code
                                 NSLog(@"receivedSize %ld",(long)receivedSize);
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                
                                if (image) {
                                    // do something with image
                                    cell.imgCatView.image = image;
                                    
                                    [cell.indicatorView setHidden:YES];
                                    [cell.indicatorView stopAnimating];
                                    
                                }
                            }];
        
        [cell.imgCatView setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
    
//    if ([_orderhistoryDetailsArr count]>3)
//    {
//        return 85;
//    }
//    else
//    {
//        return tableView.frame.size.height/3;
//    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end
