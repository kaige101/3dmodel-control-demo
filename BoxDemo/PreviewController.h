//
//  PreviewController.h
//  BoxDemo
//

//  Copyright (c) 2015年 Kaige. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface PreviewController : UIViewController

@property (nonatomic, weak) IBOutlet SCNView *scnView;
@property (nonatomic, weak) SCNNode *theModelNode;
@property (nonatomic, strong) NSData *theVertices;

/**
 * for preview model
 */
@property (nonatomic, strong) NSURL *fileUrl;

@end
