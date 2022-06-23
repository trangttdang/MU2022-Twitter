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
       
    // Initialize any other properties
    }
    return self;
}
@end
