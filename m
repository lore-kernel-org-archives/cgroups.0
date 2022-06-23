From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v5 8/9] memcg: enable accounting for allocations in
 alloc_fair_sched_group
Date: Thu, 23 Jun 2022 17:51:54 +0300
Message-ID: <6a0f9fb4-2ddd-8ad0-4f2a-d3780c1d9397@openvz.org>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=hqvRcJBRW/zXn9o8PLaPnPcK1byd11F8xwtbZSlj240=;
        b=L3GdFJ5msAUKjEBgJr8tC0Ye/uf5rOW/nTjACFOPDVkM4uV2p2NICHRx0qbgkWRrHW
         xye3mNc9OUGNDUkdfVMWc+YCL7Uw2FtXXna0LVEbGKFaP1NtOR9VxXehiJAtnQEze01M
         zD25I3FxU8/N5GjP9dXmVKZL2giwMWH1O04S/yKV3I/NnfvtJbiXvpW1ovOGu9+QwMgj
         GBDOyIDuwc8e82tKToKvcUFx39aq2ki+Tp6x/9ooZM/+FRKSWkYPJ3fK+x6UXHRL0vlb
         /b9h4l4s9Eg3vjeZyOWNwEHeOq/ax6nMC3d26/bpwKwaZyykWOqIebfDdRo9GEwfGrzZ
         C52A==
Content-Language: en-US
In-Reply-To: <4e685057-b07d-745d-fdaa-1a6a5a681060-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Q3JlYXRpbmcgb2YgZWFjaCBuZXcgY3B1IGNncm91cCBhbGxvY2F0ZXMgdHdvIDUxMi1ieXRlcyBr
ZXJuZWwgb2JqZWN0cwpwZXIgQ1BVLiBUaGlzIGlzIGVzcGVjaWFsbHkgaW1wb3J0YW50IGZvciBj
Z3JvdXBzIHNoYXJlZCBwYXJlbnQgbWVtb3J5CmNncm91cC4gSW4gdGhpcyBzY2VuYXJpbywgb24g
bm9kZXMgd2l0aCBtdWx0aXBsZSBwcm9jZXNzb3JzLCB0aGVzZQphbGxvY2F0aW9ucyBiZWNvbWUg
b25lIG9mIHRoZSBtYWluIG1lbW9yeSBjb25zdW1lcnMuCgpNZW1vcnkgYWxsb2NhdGVkIGR1cmlu
ZyBuZXcgY3B1IGNncm91cCBjcmVhdGlvbjoKY29tbW9uIHBhcnQ6IAl+MTFLYgkrICAzMTggYnl0
ZXMgcGVyY3B1CmNwdSBjZ3JvdXA6CX4yLjVLYgkrIDEwMzYgYnl0ZXMgcGVyY3B1CgpBY2NvdW50
aW5nIGZvciB0aGlzIG1lbW9yeSBoZWxwcyB0byBhdm9pZCBtaXN1c2UgaW5zaWRlIG1lbWNnLWxp
bWl0ZWQKY29udGlhbmVycy4KClNpZ25lZC1vZmYtYnk6IFZhc2lseSBBdmVyaW4gPHZ2cy1HRUZB
UXpaWDdyOGRubSt5Uk9mRTBBQHB1YmxpYy5nbWFuZS5vcmc+ClJldmlld2VkLWJ5OiBSb21hbiBH
dXNoY2hpbiA8cm9tYW4uZ3VzaGNoaW4tZnhVVlhmdElGRG55RzF6RU9iWHRmQUBwdWJsaWMuZ21h
bmUub3JnPgpSZXZpZXdlZC1ieTogTWljaGFsIEtvdXRuw70gPG1rb3V0bnktSUJpOVJHL2I2N2tA
cHVibGljLmdtYW5lLm9yZz4KQWNrZWQtYnk6IFNoYWtlZWwgQnV0dCA8c2hha2VlbGItaHBJcXNE
NEFLbGZRVDBkWlIrQWxmQUBwdWJsaWMuZ21hbmUub3JnPgpSZXZpZXdlZC1ieTogTXVjaHVuIFNv
bmcgPHNvbmdtdWNodW4tRUM4VXhsNk5weWRsNTdNSWRSQ0ZEZ0BwdWJsaWMuZ21hbmUub3JnPgot
LS0KIGtlcm5lbC9zY2hlZC9mYWlyLmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkL2ZhaXIu
YyBiL2tlcm5lbC9zY2hlZC9mYWlyLmMKaW5kZXggZTgyMDJiNWNkM2Q1Li43MTE2MWJlMWU3ODMg
MTAwNjQ0Ci0tLSBhL2tlcm5lbC9zY2hlZC9mYWlyLmMKKysrIGIva2VybmVsL3NjaGVkL2ZhaXIu
YwpAQCAtMTE1MDMsMTIgKzExNTAzLDEyIEBAIGludCBhbGxvY19mYWlyX3NjaGVkX2dyb3VwKHN0
cnVjdCB0YXNrX2dyb3VwICp0Zywgc3RydWN0IHRhc2tfZ3JvdXAgKnBhcmVudCkKIAogCWZvcl9l
YWNoX3Bvc3NpYmxlX2NwdShpKSB7CiAJCWNmc19ycSA9IGt6YWxsb2Nfbm9kZShzaXplb2Yoc3Ry
dWN0IGNmc19ycSksCi0JCQkJICAgICAgR0ZQX0tFUk5FTCwgY3B1X3RvX25vZGUoaSkpOworCQkJ
CSAgICAgIEdGUF9LRVJORUxfQUNDT1VOVCwgY3B1X3RvX25vZGUoaSkpOwogCQlpZiAoIWNmc19y
cSkKIAkJCWdvdG8gZXJyOwogCiAJCXNlID0ga3phbGxvY19ub2RlKHNpemVvZihzdHJ1Y3Qgc2No
ZWRfZW50aXR5X3N0YXRzKSwKLQkJCQkgIEdGUF9LRVJORUwsIGNwdV90b19ub2RlKGkpKTsKKwkJ
CQkgIEdGUF9LRVJORUxfQUNDT1VOVCwgY3B1X3RvX25vZGUoaSkpOwogCQlpZiAoIXNlKQogCQkJ
Z290byBlcnJfZnJlZV9ycTsKIAotLSAKMi4zNi4xCgo=
