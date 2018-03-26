//
//  RoundLineView.h
//  FitForceCoach
//
//  Created by xuyang on 2017/11/30.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LineMode) {
    horizontalMode = 0,
    verticalMode
};

@interface RoundLineView : UIView

@property (nonatomic, assign) LineMode lineMode;
@property (nonatomic, strong) UIColor *lineColor;

@end
