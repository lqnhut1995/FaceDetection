//
//  InputFile.h
//  face_detection
//
//  Created by Hell Rocky on 10/31/18.
//  Copyright © 2018 hadri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

@interface InputFile : NSObject
+ (void)loadfile:(const string &)filepath images:(vector<Mat>&)images labels:(vector<int>&)labels;
@end
