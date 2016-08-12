//
//  AKEncryptorAES.h
//  AKEncryptor
//
//  Copyright © 2016 Aryan Kashyap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

#define AKENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define AKENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
#define AKENCRYPT_KEY_SIZE      kCCKeySizeAES256

@interface AKEncryptorAES : NSObject{

}

// Raw Data

+ (NSData*)ak_generateIv;
+ (NSData*)ak_encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*)ak_decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;

// API (base 64)
// the return value of encrypteMessage: and 'encryptedMessage' are encoded with base64.

+ (NSString*)ak_encryptBase64String:(NSString*)string keyString:(NSString*)keyString separateLines:(BOOL)separateLines;
+ (NSString*)ak_decryptBase64String:(NSString*)encryptedBase64String keyString:(NSString*)keyString;


// API (utilities)
+ (NSString*)ak_hexStringForData:(NSData*)data;
+ (NSData*)ak_dataForHexString:(NSString*)hexString;



@end
