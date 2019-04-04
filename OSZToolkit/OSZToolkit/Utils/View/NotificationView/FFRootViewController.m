//
//  FFRootViewController.m
//  TYFitFore
//
//  Created by apple on 2019/2/20.
//  Copyright © 2019 tangpeng. All rights reserved.
//

#import "FFRootViewController.h"

@interface FFRootViewController ()

@end

@implementation FFRootViewController

static UIInterfaceOrientationMask supportedOrientations;

+ (void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)orientations {
    supportedOrientations = orientations;
}

+ (void)setStatusBarHidden:(BOOL)hidden {
    statusBarHidden = hidden;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return supportedOrientations;
}

static BOOL statusBarHidden;
- (BOOL)prefersStatusBarHidden {
    return statusBarHidden;
}

@end
