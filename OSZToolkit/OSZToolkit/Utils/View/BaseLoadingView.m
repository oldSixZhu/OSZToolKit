//
//  BaseLoadingView.m
//  FitForceCoach
//
//  Created by xuyang on 2017/12/4.
//

#import "BaseLoadingView.h"

static NSArray *gifImagesArray;

@implementation BaseLoadingView

#pragma mark - 初始化
+ (void)load {
    //提前加载gif图片数组
    gifImagesArray = [BaseLoadingView gifImagesWithImage];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.backgroundColor = UIColorFromHex(0x182845);
    [self addSubview:self.loadingView];
    [self addSubview:self.loadingTextLabel];
    
    self.loadingView.frame = CGRectMake(0, 0, kFloat(80), kFloat(80));
    self.loadingView.center = CGPointMake(self.v_width/2.0, (self.v_height/2.0 - NAV_HEIGHT/2.0) - BOTTOMSAFEAREA_HEIGHT);
    
    [self.loadingTextLabel layoutForFrame:CGRectMake(0, self.loadingView.v_bottom + kFloat(15), SCREEN_WIDTH, CGFLOAT_MAX)];
    self.loadingTextLabel.v_width = SCREEN_WIDTH;
}

#pragma mark - 初始化gif图片
- (UIImageView *)loadingGIF {
    
    UIImageView *GIFImageView = [[UIImageView alloc] init];//初始化
    GIFImageView.backgroundColor = [UIColor clearColor];
    GIFImageView.animationImages = gifImagesArray?gifImagesArray:[BaseLoadingView gifImagesWithImage];
    
    //动画的总时长(一组动画坐下来的时间 6张图片显示一遍的总时间)
    GIFImageView.animationDuration = 2;
    GIFImageView.animationRepeatCount = 0;//动画进行几次结束
    [GIFImageView startAnimating];//开始动画
    
    return GIFImageView;
}

+ (NSArray *)gifImagesWithImage {
    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:@"dna" withExtension:@"gif"];
    //获取Gif图的原数据
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifImageUrl, NULL);
    //获取Gif图有多少帧
    size_t gifcount = CGImageSourceGetCount(gifSource);
    
    NSMutableArray *imageS = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < gifcount; i++) {
        
        //由数据源gifSource生成一张CGImageRef类型的图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        
        [imageS addObject:image];
        
        CGImageRelease(imageRef);
        
    }
    CFRelease(gifSource);
    //得到图片数组
    return imageS;
}

#pragma mark - getter
- (UILabel *)loadingTextLabel {
    if (!_loadingTextLabel) {
        _loadingTextLabel = [[UILabel alloc] init];
        _loadingTextLabel.textColor = [UIColor whiteColor];
        _loadingTextLabel.font = kFont(14);
        _loadingTextLabel.text = XYLString(@"network_view_loading");
        _loadingTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _loadingTextLabel;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        _loadingView = [self loadingGIF];
    }
    return _loadingView;
}

@end
