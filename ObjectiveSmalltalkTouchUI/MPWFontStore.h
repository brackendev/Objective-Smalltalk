//
//  MPWFontStore.h
//  ObjectiveSmalltalkTouchUI
//
//  Created by Marcel Weiher on 26.01.21.
//

#import <MPWFoundation/MPWFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPWFontStore : MPWAbstractStore

@property (nonatomic, strong) NSDictionary *nameMap;

@end

NS_ASSUME_NONNULL_END
