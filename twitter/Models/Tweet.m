//
//  Tweet.m
//  Pods
//
//  Created by Trang Dang on 6/20/22.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"
#import "Entities.h"

@implementation Tweet

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        if(self.favorited){
            self.favoriteImageAddress = @"favor-icon-red";
        } else if(!self.favorited){
            self.favoriteImageAddress = @"favor-icon";
        }
        if(self.retweeted){
            self.retweetImageAddress = @"retweet-icon-green";
        } else if(!self.retweeted){
            self.retweetImageAddress = @"retweet-icon";
        }
        
        
        
        // Initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Initialize entities
        NSDictionary *entities = dictionary[@"entities"];
        self.entities = [[Entities alloc] initWithDictionary:entities];
//        NSDictionary *media = self.entities.media;
//        NSLog(@"Media: %@", media[@"media_url"]);
//        NSDictionary *media = self.entities[@"media"];
//        self.entities.media = media;
//        if(self.entities.media){
//                NSLog(@"Media Tweet: %@", self.entities.media[@"media_url"]);
//        }
        
        
        // Format and set createdAtString
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Convert Date to String
        self.createdAtString = [date shortTimeAgoSinceNow];
        
        //for tweet detail page
        NSDateFormatter *formatterTweetDetail = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *dateTweetDetail = [formatter dateFromString:createdAtOriginalString];
        //Configure output format
        formatterTweetDetail.dateStyle = NSDateFormatterShortStyle;
        formatterTweetDetail.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.createdAtSpecificString = [formatterTweetDetail stringFromDate:dateTweetDetail];
    }
    return self;
}

@end
