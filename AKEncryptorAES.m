//
//  AKEncryptorAES.m
//  AKEncryptor
//
//  Copyright © 2016 Aryan Kashyap. All rights reserved.
//

#import "AKEncryptorAES.h"
#import "NSData+Base64.h"

@implementation AKEncryptorAES

+ (NSData*)ak_encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
{
    NSData* result = nil;
    
    // setup key
    unsigned char cKey[AKENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:AKENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[AKENCRYPT_BLOCK_SIZE];
    bzero(cIv, AKENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:AKENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + AKENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          AKENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          AKENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    } else {
        free(buffer);
        NSLog(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
    
    return result;
}

+ (NSData*)ak_decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
{
    NSData* result = nil;
    
    // setup key
    unsigned char cKey[AKENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:AKENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[AKENCRYPT_BLOCK_SIZE];
    bzero(cIv, AKENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:AKENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + AKENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do decrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          AKENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          AKENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
    
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    } else {
        free(buffer);
        NSLog(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
    }
    
    return result;
}

+ (NSString*)ak_encryptBase64String:(NSString*)string keyString:(NSString*)keyString separateLines:(BOOL)separateLines
{
    NSData* data = [self ak_encryptData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                 key:[keyString dataUsingEncoding:NSUTF8StringEncoding]
                                  iv:nil];
    return [data ak_base64EncodedStringWithSeparateLines:separateLines];
}

+ (NSString*)ak_decryptBase64String:(NSString*)encryptedBase64String keyString:(NSString*)keyString
{
    NSData* encryptedData = [NSData ak_dataFromBase64String:encryptedBase64String];
    NSData* data = [self ak_decryptData:encryptedData
                                 key:[keyString dataUsingEncoding:NSUTF8StringEncoding]
                                  iv:nil];
    if (data) {
        return [[NSString alloc] initWithData:data
                                      encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

#define AKENCRYPT_IV_HEX_LEGNTH (AKENCRYPT_BLOCK_SIZE*2)

+ (NSData*)ak_generateIv
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand((unsigned int)time(NULL));
    });
    
    char cIv[AKENCRYPT_BLOCK_SIZE];
    for (int i=0; i < AKENCRYPT_BLOCK_SIZE; i++) {
        cIv[i] = rand() % 256;
    }
    return [NSData dataWithBytes:cIv length:AKENCRYPT_BLOCK_SIZE];
}


+ (NSString*)ak_hexStringForData:(NSData*)data
{
    if (data == nil) {
        return nil;
    }
    
    NSMutableString* hexString = [NSMutableString string];
    
    const unsigned char *p = [data bytes];
    
    for (int i=0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", *p++];
    }
    return hexString;
}

+ (NSData*)ak_dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        } else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}

@end
