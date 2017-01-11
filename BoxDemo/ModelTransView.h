//
//  ModelTransView.h
//  BoxDemo
//
//  Created by Kaige-SSD on 15/12/28.
//  Copyright © 2015年 Kaige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "Constant.h"

@class GameViewController;

//*****************History************************
@interface History : NSObject

@property (nonatomic, assign) CMSlider type;

@property (nonatomic, assign) SCNVector3 vector;

@end
//*****************History End************************

@interface ModelTransView : UIView

@property (nonatomic, weak) GameViewController *ctrl;

@property (nonatomic, assign) BOOL bLockValue;

@property (nonatomic, assign) SCNVector3 vTranslation;

- (void)initData;

- (void)addHistory:(History *)history;

- (void)setTransType:(CMSlider)type;

- (void)setContentOffset:(CGPoint)contentOffset;

@end
