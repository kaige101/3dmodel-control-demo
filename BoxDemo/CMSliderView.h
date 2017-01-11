//
//  CSliderView.h
//  BoxDemo
//
//  Created by Kaige-SSD on 15/12/16.
//  Copyright © 2015年 Kaige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "Constant.h"

@protocol CMSliderDelegate <NSObject>

-(void)sliderViewValueChange:(CMSlider)type vector:(SCNVector3)vector;
-(void)sliderViewTouchUpInside:(CMSlider)type vector:(SCNVector3)vector;

@end

@class ModelTransView;

@interface CMSliderView : UIView

+(CMSliderView *)loadView;

-(void)undoSlider:(SCNVector3)vector;

@property (nonatomic, weak) ModelTransView *transView;

@property (nonatomic, assign) CMSlider type;

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, weak) id<CMSliderDelegate> delegate;

@end
