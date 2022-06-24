//
//  Entities.h
//  twitter
//
//  Created by Trang Dang on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Entities : NSObject
@property (nonatomic, strong) NSDictionary *hashtags;
@property (nonatomic, strong) NSDictionary *symbols;
@property (nonatomic, strong) NSDictionary *user_mentions;
@property (nonatomic, strong) NSDictionary *urls;
@property (nonatomic, strong) NSDictionary *media;
@property (nonatomic, strong) NSString *mediaURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
