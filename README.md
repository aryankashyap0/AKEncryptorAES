AKEncryptorAES
=============================

AKEncryptorAES is enabled to encrypt/decrypt a message. Supported encryption algorithm is AES 256 bit only. Additionally BASE64 encode/decode is supported.

Usage
-----

(1) Encrypt/decrypt plain text message with Base64 encoding

Encrypt: 🔒

	NSString* encrypted = [AKEncryptorAES ak_encryptBase64String:@"Hello World!"
											        keyString:@"somekey"
												separateLines:NO];

The output string is encoded with Base64.

	message: @"Hello World!"
	output : @"ggIfBjMpQb9n53cZsrs3uA=="
  
if 'separateLines:' is NO, no CR/LF characters will be added......
Otherwise a CR/LF pair will be added every 64 encoded Chars.

	NSString* decrypted = [AKEncryptorAES ak_decryptBase64String:encrypted
											        keyString:key];


(2) Encrypt/decrypt binary data 🔒

	NSData* encryptedData = [AKEncryptorAES ak_encryptData:data
											    keyData:key
												     iv:iv];
	
	NSData* decryptedData = [AKEncryptorAES ak_decryptData:encryptData
											    keyData:key
												     iv:iv];

The iv is called 'initailization vector' for CBC mode. it is abled to be set nil.


(3) Generate iv 

	NSData* iv = [AKEncryptorAES ak_generateIv];

It generates a 16 bytes random binary value. You can use this value for +ak_encryptData:keyData:iv:.


(4) Utilities

	NSData* iv = [AKEncryptorAES ak_generateIv];
	NSString* hexString = [AKEncryptorAES ak_hexStringForData:iv];

	example: @"78d3ab7d1dd4d75a04c625737a59988d"

	NSData* bin = [AKEncryptorAES ak_dataForHexString:hexString];
  
  Features 🌅
--------
- Only support AES256/CBC/PKCS7padding
- Base64 encoding is suported


Customize
---------

It is able to change below constants:

	#define AKENCRYPT_KEY_SIZE      kCCKeySizeAES256

If you want to use AES 128 bit key, you can set the constant like below:

	#define AKENCRYPT_KEY_SIZE      kCCKeySizeAES128

NOTE: If you change the constant, the testcase will be failed (it is made for AES 256 bit key).


Installation
-----------

You should copy below files to your projects.

	AKEncryptorAES.h
	AKEncryptorAES.m
	NSData+Base64.h
	NSData+Base64.m

Cocoapods
-----------

Coming Soon :)

                              

                        
