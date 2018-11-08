//
//  InputFile.m
//  face_detection
//
//  Created by Hell Rocky on 10/31/18.
//  Copyright © 2018 hadri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputFile.h"
#include <opencv2/face.hpp>
#include <opencv2/opencv.hpp>

#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>

using namespace std;
using namespace cv;

@implementation InputFile

+ (void)loadfile:(const string &)filepath images:(vector<Mat>&)images labels:(vector<int>&)labels{
    ifstream file(filepath, ifstream::in);
    string line,path,label;
    if(!file){
        return;
    }
    while(getline(file, line)){
        stringstream f(line);
        getline(f, path, ';');
        getline(f,label);
        if(!path.empty() && !label.empty()){
            NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:path.c_str()] ofType:@"pgm"];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            Mat image = imdecode(Mat(1, (int)[data length], CV_8UC1, (void*)data.bytes), IMREAD_UNCHANGED);
            images.push_back(image);
            labels.push_back(atoi(label.c_str()));
        }
    }
}
@end
