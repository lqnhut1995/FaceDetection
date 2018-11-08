//
//  OpencvWrapper.h
//  face_detection
//
//  Created by Soubhi Hadri on 3/3/18.
//  Copyright © 2018 hadri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpencvWrapper : NSObject
- (id)init;
- (void)setupCamera:(UIImageView *)imageView;
- (void)flipCamera;
- (void)startCamera;
- (UIImage *) getSubImageFrom:(UIImage *)imageToCrop WithRect:(CGRect)rect;
@end
