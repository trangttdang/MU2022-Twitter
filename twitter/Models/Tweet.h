//
//  Tweet.h
//  Pods
//
//  Created by Trang Dang on 6/20/22.
//

// Tweet.h
#import <Foundation/Foundation.h>
#import "User.h"
#import "Entities.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject
// MARK: Properties

@property (nonatomic, strong) NSString *idStr; // For favoriting, retweeting & replying
@property (nonatomic, strong) NSString *text; // Text content of tweet
@property (nonatomic) int favoriteCount; // Update favorite count label
@property (nonatomic) BOOL favorited; // Configure favorite button
@property (nonatomic) int retweetCount; // Update favorite count label
@property (nonatomic) BOOL retweeted; // Configure retweet button
@property (nonatomic, strong) User *user; // Contains Tweet author's name, screenname, etc.
@property (nonatomic, strong) NSString *createdAtString; // Display date
@property (nonatomic, strong) NSString *createdAtSpecificString; // Display specific date
@property (nonatomic, strong) NSString *favoriteImageAddress;
@property (nonatomic, strong) NSString *retweetImageAddress;
@property (nonatomic, strong) NSString *mediaUrlHttps;
@property (nonatomic, strong) Entities *entities;

// For Retweets
@property (nonatomic, strong) User *retweetedByUser;  // If the tweet is a retweet, this will be the user who retweeted

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
