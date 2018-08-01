//
//  Common.m
//  HiplaRetail
//
//  Created by fnspl3 on 10/03/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "Common.h"

static Common *sharedCommon = nil;

@implementation Common


+(Common *) sharedCommon {
    
    @synchronized([Common class])
    {
        if (!sharedCommon) {
            
            sharedCommon = [[self alloc] init];
            
        }
        
        return sharedCommon;
    }
    
    return nil;
    
}

- (NSString *)indorMapImagePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
    
    return filePath;
    
}

@end
