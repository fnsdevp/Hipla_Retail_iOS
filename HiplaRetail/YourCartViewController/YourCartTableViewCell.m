//
//  YourCartTableViewCell.m
//  Jing
//
//  Created by fnspl3 on 11/09/17.
//  Copyright © 2017 fnspl3. All rights reserved.
//

#import "YourCartTableViewCell.h"

@implementation YourCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnPlus:(id)sender {
    
    if (_delegate) {
        
        [_delegate plusBtnAction:self];
    }
}

- (IBAction)decrementNumber:(id)sender {
    
    if (_delegate) {
        
        [_delegate minusBtnAction:self];
    }
}
-(IBAction)btnDelete:(id)sender {
    
    if (_delegate) {
        
        [_delegate deleteBtnAction:self];
    }
}

- (void)setPrdDict:(NSMutableDictionary *)prdDict {
    
    _prdDict = prdDict;
    NSInteger prdQuentity = [[_prdDict objectForKey:@"prdQuentity"] integerValue];
    if (prdQuentity>1) {
        [self.minusBtnOutlet setEnabled:YES];
    } else {
        [self.minusBtnOutlet setEnabled:NO];
    }
    
}

@end
