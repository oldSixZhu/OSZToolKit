//
//  OSZHeaderLbl.m
//  budejie
//
//  Created by oldSix_Zhu on 16/9/1.
//  Copyright © 2016年 Dason. All rights reserved.
//

#import "OSZHeaderLbl.h"

@implementation OSZHeaderLbl

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{

    if (self = [super initWithCoder:aDecoder])
    {
        //阴影
        self.layer.shadowOpacity = 20;
        self.layer.shadowColor =[UIColor blackColor].CGColor;
        self.layer.shadowRadius = 0;
        self.layer.shadowOffset = CGSizeMake(1, 1);
    }
   
    return self;
}

@end
