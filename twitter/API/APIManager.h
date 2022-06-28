//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;
- (void)getUserTimelineWithCompletion:(NSString *)screenName completion:(void(^)(NSMutableArray *tweets, NSError *error))completion;

- (void)getHomeTimelineWithCompletion:(NSNumber *)countLoaded completion:(void(^)(NSMutableArray *tweets, NSError *error))completion;

//- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)unFavorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)unRetweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)reply:(NSString *)text inReplyToStatus:(NSString *)statusID completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)getUserMentionWithCompletion:(void(^)(NSMutableArray *tweets, NSError *error))completion;
- (void)verifyCredentialsWithCompletion:(void(^)(User *user, NSError *error))completion;
@end
