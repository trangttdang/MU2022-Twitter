//
//  User.m
//  Pods
//
//  Created by Trang Dang on 6/20/22.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.name = dictionary[@"name"];
//        self.screenName = dictionary[@"screen_name"];
        self.screenName = [@"@" stringByAppendingString:dictionary[@"screen_name"]];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.profileBackgroundPicture = dictionary[@"profile_background_image_url_https"];
        self.followersCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
    // Initialize any other properties
        self.profileDescription = [NSString stringWithFormat:@"%@", dictionary[@"description"]];
        self.statusCount = [dictionary[@"statuses_count"] intValue];
    }
    return self;
}
@end
