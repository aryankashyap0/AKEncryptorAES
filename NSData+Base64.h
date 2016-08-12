//
//  NSData+Base64.h
//
//  Copyright © 2016 Aryan Kashyap. All rights reserved.
//

#import <Foundation/Foundation.h>

void *ak_NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *ak_NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool seperateLines,
                      size_t *outputLength);

@interface NSData (Base64)


+ (NSData *)ak_dataFromBase64String:(NSString *)aString;
- (NSString *)ak_base64EncodedString;
- (NSString *)ak_base64EncodedStringWithSeparateLines:(BOOL)separateLines;

@end
