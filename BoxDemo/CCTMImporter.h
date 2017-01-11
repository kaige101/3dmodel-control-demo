//
//  CCTMImporter.h
//  BoxDemo
//
//  Created by Kaige-SSD on 15/12/29.
//  Copyright © 2015年 Kaige. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@interface CCTMImporter : NSObject

+ (void)importFile:(NSString *)path complete:(void (^)(SCNNode *node, NSData *theVertices))complete;

@end
