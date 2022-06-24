//
//  Entities.m
//  twitter
//
//  Created by Trang Dang on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Entities.h"

@implementation Entities

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.hashtags = dictionary[@"hashtags"];
        self.symbols = dictionary[@"symbols"];
        self.user_mentions = dictionary[@"user_mentions"];
        self.urls = dictionary[@"urls"];
        if(dictionary[@"media"]){
            self.media = dictionary[@"media"];
            NSLog(@"Media Tweet: %@", self.media);
            NSDictionary *media = self.media;
//            self.mediaURL = [NSString stringWithFormat:@"%@", media[@"sizes"]];
//            NSLog(@"Media Tweet: %@", media[@"id"]);
            
        }
    // Initialize any other properties
    }
    return self;
}

@end
