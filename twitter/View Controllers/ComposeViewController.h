//
//  ComposeViewController.h
//  twitter
//
//  Created by Trang Dang on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"


NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end
@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic) NSString *inReplyToStatusID;
@property (nonatomic) NSString *inReplyToScreenName;
@property (nonatomic) NSString *username;

@end

NS_ASSUME_NONNULL_END
