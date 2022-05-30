From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH mm v3 4/9] memcg: enable accounting for struct simple_xattr
Date: Mon, 30 May 2022 14:26:18 +0300
Message-ID: <ecce42f6-28bf-5d59-e84c-688a6a3b40b8@openvz.org>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <cover.1653899364.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=k8OfFf3zteeGV4NoXsW7mYQBRm/UT3jxMOm3SilJFI0=;
        b=K/QFxlODFRAVf5bt4Q3P/XNh1C8S/u5UgjkwbSrQRpQsAlAfqwyev+c+gKJa7sqM/E
         oQZSKjl/uojTT/rpHIvx0MAm4K8ZHdoT5kwFjZRwHOZa9yv6Ym6HisUbdsUdy1+BkCLn
         L5peMyjN5TEkxZCi/h1dH+nfo5XsybR/iIDzcJRIdXQ0oMZgtKynvBMNcuWwSJHRivKh
         c/tAJLVDRKtzyZ4IydneAMA8SrsOIVPc4G+J/qRvjIB/Xw7o9KziSEBXV6+2XhpiVWaP
         BiXPrksHoHCXi3svqTtexh4P+jYBn5XvE4noKsvPXrztol0mmqbsUK7ATZjq+fvDxVg4
         DyaQ==
Content-Language: en-US
In-Reply-To: <cover.1653899364.git.vvs@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

a2VybmZzIG5vZGVzIGFyZSBxdWl0ZSBzbWFsbCBrZXJuZWwgb2JqZWN0cywgaG93ZXZlciB0aGVy
ZSBhcmUgZmV3CnNjZW5hcmlvcyB3aGVyZSBpdCBjb25zdW1lcyBzaWduaWZpY2FudCBwaWVjZSBv
ZiBhbGwgYWxsb2NhdGVkIG1lbW9yeToKCjEpIGNyZWF0aW5nIGEgbmV3IG5ldGRldmljZSBhbGxv
Y2F0ZXMgfjUwS2Igb2YgbWVtb3J5LCB3aGVyZSB+MTBLYgogICB3YXMgYWxsb2NhdGVkIGZvciA4
MCsga2VybmZzIG5vZGVzLgoKMikgY2dyb3VwdjIgbWtkaXIgYWxsb2NhdGVzIH42MEtiIG9mIG1l
bW9yeSwgfjEwS2Igb2YgdGhlbSBhcmUga2VybmZzCiAgIHN0cnVjdHVyZXMuCgozKSBTaGFrZWVs
IEJ1dHQgcmVwb3J0cyB0aGF0IEdvb2dsZSBoYXMgd29ya2xvYWRzIHdoaWNoIGNyZWF0ZSAxMDBz
CiAgIG9mIHN1YmNvbnRhaW5lcnMgYW5kIHRoZXkgaGF2ZSBvYnNlcnZlZCBoaWdoIHN5c3RlbSBv
dmVyaGVhZAogICB3aXRob3V0IG1lbWNnIGFjY291bnRpbmcgb2Yga2VybmZzLgoKVXN1YWxseSBu
ZXcga2VybmZzIG5vZGUgY3JlYXRlcyBmZXcgb3RoZXIgb2JqZWN0czoKCkFsbG9jcyAgQWxsb2Mg
ICBBbGxvY2F0aW9uCm51bWJlciAgc2l6ZQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQoxICAgKyAgMTI4ICAgICAgKF9fa2VybmZzX25ld19ub2RlKzB4NGQpICAg
ICAgICBrZXJuZnMgbm9kZQoxICAgKyAgIDg4ICAgICAgKF9fa2VybmZzX2lhdHRycysweDU3KSAg
ICAgICAgICBrZXJuZnMgaWF0dHJzCjEgICArICAgOTYgICAgICAoc2ltcGxlX3hhdHRyX2FsbG9j
KzB4MjgpICAgICAgIHNpbXBsZV94YXR0cgoxICAgICAgIDMyICAgICAgKHNpbXBsZV94YXR0cl9z
ZXQrMHg1OSkKMSAgICAgICA4ICAgICAgIChfX2tlcm5mc19uZXdfbm9kZSsweDMwKQoKJysnIC0t
IHRvIGJlIGFjY291bnRlZAoKVGhpcyBwYXRjaCBlbmFibGVzIGFjY291bnRpbmcgZm9yIHN0cnVj
dCBzaW1wbGVfeGF0dHIuIFNpemUgb2YgdGhpcwpzdHJ1Y3R1cmUgZGVwZW5kcyBvbiB1c2Vyc3Bh
Y2UgYW5kIGNhbiBncm93IG92ZXIgNEtiLgoKU2lnbmVkLW9mZi1ieTogVmFzaWx5IEF2ZXJpbiA8
dnZzQG9wZW52ei5vcmc+ClJldmlld2VkLWJ5OiBSb21hbiBHdXNoY2hpbiA8cm9tYW4uZ3VzaGNo
aW5AbGludXguZGV2PgpSZXZpZXdlZC1ieTogTWljaGFsIEtvdXRuw70gPG1rb3V0bnlAc3VzZS5j
b20+CkFja2VkLWJ5OiBTaGFrZWVsIEJ1dHQgPHNoYWtlZWxiQGdvb2dsZS5jb20+ClJldmlld2Vk
LWJ5OiBNdWNodW4gU29uZyA8c29uZ211Y2h1bkBieXRlZGFuY2UuY29tPgotLS0KIGZzL3hhdHRy
LmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9mcy94YXR0ci5jIGIvZnMveGF0dHIuYwppbmRleCBlOGRkMDNlNDU2MWUu
Ljk4ZGNmNjYwMGJkOSAxMDA2NDQKLS0tIGEvZnMveGF0dHIuYworKysgYi9mcy94YXR0ci5jCkBA
IC0xMDAxLDcgKzEwMDEsNyBAQCBzdHJ1Y3Qgc2ltcGxlX3hhdHRyICpzaW1wbGVfeGF0dHJfYWxs
b2MoY29uc3Qgdm9pZCAqdmFsdWUsIHNpemVfdCBzaXplKQogCWlmIChsZW4gPCBzaXplb2YoKm5l
d194YXR0cikpCiAJCXJldHVybiBOVUxMOwogCi0JbmV3X3hhdHRyID0ga3ZtYWxsb2MobGVuLCBH
RlBfS0VSTkVMKTsKKwluZXdfeGF0dHIgPSBrdm1hbGxvYyhsZW4sIEdGUF9LRVJORUxfQUNDT1VO
VCk7CiAJaWYgKCFuZXdfeGF0dHIpCiAJCXJldHVybiBOVUxMOwogCi0tIAoyLjM2LjEKCg==
