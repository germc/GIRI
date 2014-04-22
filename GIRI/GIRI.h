//
//  GIRI.h
//  GIRI
//
//  Created by Jason Hurt on 4/21/14.
//  Copyright (c) 2014 8byte8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIRI : NSObject

/**
 Attempt to recognize the speech contained in the wave file. Note that this wave file should be one encoded by Apple.
 The file header is different than that of "regular" wave files.
 @param wavFile the full path of the wave file
 @param durationPerFile the wavFile will get split into smaller files of this duration
 @param onComplete callback that will contain the recognized text or an error if something went wrong
 */
+ (void)recognizeSpeech:(NSString*)wavFile durationPerFile:(NSInteger)durationPerFile onComplete:(void (^)(NSString* text, NSError *error))onComplete;

/**
 Attempt to recognize the speech contained in the wave file. Note that this wave file should be one encoded by Apple.
 The file header is different than that of "regular" wave files.
 @param wavFile the full path of the wave file
 @param onComplete callback that will contain the recognized text or an error if something went wrong
 */
+ (void)recognizeSpeech:(NSString*)wavFile onComplete:(void (^)(NSString* text, NSError *error))onComplete;

@end
