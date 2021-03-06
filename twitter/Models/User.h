//
//  User.h
//  Pods
//
//  Created by Trang Dang on 6/20/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *profileBackgroundPicture;
@property (nonatomic) int followingCount;
@property (nonatomic) int followersCount;
@property (nonatomic, strong) NSString *profileDescription;
@property (nonatomic) int statusCount;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
