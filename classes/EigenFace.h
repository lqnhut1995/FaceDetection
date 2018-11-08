//
//  EigenFace.h
//  face_detection
//
//  Created by Hell Rocky on 10/31/18.
//  Copyright © 2018 hadri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <opencv2/opencv.hpp>
#include <opencv2/face.hpp>

using namespace std;
using namespace cv;
using namespace face;

@interface EigenFace : NSObject
+ (void)faceRecognizerWithEigenface:(UIImage*)inputimage model:(Ptr<LBPHFaceRecognizer>)model;
+ (Ptr<LBPHFaceRecognizer>)faceRecognizerWithEigenface:(vector<Mat>&)images labels:(vector<int>&)labels;
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
@end
