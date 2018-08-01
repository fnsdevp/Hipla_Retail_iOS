//
//  AsynccronusImageView.m
//  HiplaRetail
//
//  Created by fnspl3 on 10/02/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "AsynccronusImageView.h"

@implementation AsynccronusImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
    }
    
    return self;
}

-(void)loadImageWithImgUrl:(NSString *)imgUrl {
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [imgView setBackgroundColor:[UIColor clearColor]];
    [imgView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addSubview:imgView];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:self.center];
    [self addSubview:spinner];
    
    [spinner startAnimating];

    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgUrl]];
        
        if ( data == nil )
            
            return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // WARNING: is the cell still using the same data by this point??
            UIImage *img = [UIImage imageWithData: data];
        
            imgView.image = img;
            
            [spinner stopAnimating];
            
        });
    });
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
