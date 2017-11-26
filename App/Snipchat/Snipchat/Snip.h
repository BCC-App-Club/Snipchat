//
//  Snip.h
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Snip : NSObject

@property bool seen;
@property NSString *fromUsername, *toUsername, *filename;
@property UIImage* image;
@property double timestamp;

-(void)initWithDictionary:(NSDictionary*)initDict;

@end
