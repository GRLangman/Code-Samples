# -*- coding: utf-8 -*-
"""
Created on Thu Feb 17 17:52:53 2023

@author: Grant
"""

import base64
import hashlib
url_start='https://mmm.co.za/linker.ashx?token='


message ='{"FirstName":"user","LastName":"lastname","Email":"tester.co.uk","CommunityId":"647029a6"}'
message_bytes = message.encode('utf-8')
base64_bytes = base64.b64encode(message_bytes)
#base64_message = base64_bytes.decode('ascii')
#print("Base 64 encoded")
#print(base64_bytes)
token=str(base64_bytes).replace("'","")
token=token[1:]
print("Base 64 encoded")
print(token)
MD5_str=str(base64_bytes)+',SW50ZXJuYXRpb25hbCBTb2NpZXR5IG9mIEF'
#bytes_key_bytes = bytes_key.encode('utf-8')
#base64_bytes_key = base64.b64encode(bytes_key_bytes)

MD5_str=MD5_str.replace("'","")
MD5_str=MD5_str[1:]
print("MD5 string before encoding")
print(MD5_str)
MD5_hash=hashlib.md5(MD5_str.encode('utf-8')).hexdigest()
print("MD5 hash once encoded")
print(MD5_hash)

url_full=url_start+token+'&md5='+MD5_hash

print("Full URL")
print(url_full)





