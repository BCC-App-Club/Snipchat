//
//  Snip.m
//  Snipchat
//
//  Created by Ari Fiorino on 11/20/17.
//  Copyright © 2017 Azul Engineering. All rights reserved.
//

#import "Snip.h"

@implementation Snip

-(void)initWithDictionary:(NSDictionary*)initDict{
    _seen=[[initDict objectForKey:@"seen"] intValue]==1;
    _fromUsername=[initDict objectForKey:@"fromUsername"];
    _toUsername=[initDict objectForKey:@"toUsername"];
    _filename=[initDict objectForKey:@"filename"];
//    _image=[UIImage imageWithData:(NSData*)[initDict objectForKey:@"image"]];
    _timestamp=[[initDict objectForKey:@"timestamp"] doubleValue];
}

@end
