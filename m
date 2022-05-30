From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH mm v3 8/9] memcg: enable accounting for allocations in
 alloc_fair_sched_group
Date: Mon, 30 May 2022 14:26:59 +0300
Message-ID: <ea77f3ea-3832-83e8-b33d-6df40b01ee67@openvz.org>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <cover.1653899364.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=1bz2HF6EsnuVkI8ZLNySbZ6/e4i0Dqd56vDd6/MtYsM=;
        b=MJH7jgZ0nByKKabpLoAPA5HN9v21BI0dbjoYKv7JTJsZIG9t7CYmKL10/W6A4CAJjz
         YjoRkjjkc7rnBG4iIl52t8YBffLXDTaOk0FPU+R/iUFJxypPSriGxh9W/Yp0Xb2YBS3n
         u8rGfnyQ69D7OdxyAxhEqBpRbcEOZtgatuzFi1ROaPTtGWFVuQ8Ynlz3uO4xDFqo8r4l
         WK/pDR4j7nZ8vJmIiytexPw++UZNwa2TUENNay2Qdqs1hgi/d47tM/IS92zI/+yxh40n
         /qegCkoMk0oOX1fRJCG8CUX8qr6p2SS7H4vuyz1TCOxloqJz6bEygG1OkLqHyZ3QIEiK
         J+yA==
Content-Language: en-US
In-Reply-To: <cover.1653899364.git.vvs@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

Q3JlYXRpbmcgb2YgZWFjaCBuZXcgY3B1IGNncm91cCBhbGxvY2F0ZXMgdHdvIDUxMi1ieXRlcyBr
ZXJuZWwgb2JqZWN0cwpwZXIgQ1BVLiBUaGlzIGlzIGVzcGVjaWFsbHkgaW1wb3J0YW50IGZvciBj
Z3JvdXBzIHNoYXJlZCBwYXJlbnQgbWVtb3J5CmNncm91cC4gSW4gdGhpcyBzY2VuYXJpbywgb24g
bm9kZXMgd2l0aCBtdWx0aXBsZSBwcm9jZXNzb3JzLCB0aGVzZQphbGxvY2F0aW9ucyBiZWNvbWUg
b25lIG9mIHRoZSBtYWluIG1lbW9yeSBjb25zdW1lcnMuCgpNZW1vcnkgYWxsb2NhdGVkIGR1cmlu
ZyBuZXcgY3B1IGNncm91cCBjcmVhdGlvbjoKY29tbW9uIHBhcnQ6IAl+MTFLYgkrICAzMTggYnl0
ZXMgcGVyY3B1CmNwdSBjZ3JvdXA6CX4yLjVLYgkrIDEwMzYgYnl0ZXMgcGVyY3B1CgpBY2NvdW50
aW5nIGZvciB0aGlzIG1lbW9yeSBoZWxwcyB0byBhdm9pZCBtaXN1c2UgaW5zaWRlIG1lbWNnLWxp
bWl0ZWQKY29udGlhbmVycy4KClNpZ25lZC1vZmYtYnk6IFZhc2lseSBBdmVyaW4gPHZ2c0BvcGVu
dnoub3JnPgpSZXZpZXdlZC1ieTogUm9tYW4gR3VzaGNoaW4gPHJvbWFuLmd1c2hjaGluQGxpbnV4
LmRldj4KUmV2aWV3ZWQtYnk6IE1pY2hhbCBLb3V0bsO9IDxta291dG55QHN1c2UuY29tPgpBY2tl
ZC1ieTogU2hha2VlbCBCdXR0IDxzaGFrZWVsYkBnb29nbGUuY29tPgpSZXZpZXdlZC1ieTogTXVj
aHVuIFNvbmcgPHNvbmdtdWNodW5AYnl0ZWRhbmNlLmNvbT4KLS0tCiBrZXJuZWwvc2NoZWQvZmFp
ci5jIHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9zY2hlZC9mYWlyLmMgYi9rZXJuZWwvc2NoZWQvZmFp
ci5jCmluZGV4IDhjNWI3NGY2NmJkMy4uZjRmYzM5ZDVhYTRiIDEwMDY0NAotLS0gYS9rZXJuZWwv
c2NoZWQvZmFpci5jCisrKyBiL2tlcm5lbC9zY2hlZC9mYWlyLmMKQEAgLTExNDk5LDEyICsxMTQ5
OSwxMiBAQCBpbnQgYWxsb2NfZmFpcl9zY2hlZF9ncm91cChzdHJ1Y3QgdGFza19ncm91cCAqdGcs
IHN0cnVjdCB0YXNrX2dyb3VwICpwYXJlbnQpCiAKIAlmb3JfZWFjaF9wb3NzaWJsZV9jcHUoaSkg
ewogCQljZnNfcnEgPSBremFsbG9jX25vZGUoc2l6ZW9mKHN0cnVjdCBjZnNfcnEpLAotCQkJCSAg
ICAgIEdGUF9LRVJORUwsIGNwdV90b19ub2RlKGkpKTsKKwkJCQkgICAgICBHRlBfS0VSTkVMX0FD
Q09VTlQsIGNwdV90b19ub2RlKGkpKTsKIAkJaWYgKCFjZnNfcnEpCiAJCQlnb3RvIGVycjsKIAog
CQlzZSA9IGt6YWxsb2Nfbm9kZShzaXplb2Yoc3RydWN0IHNjaGVkX2VudGl0eV9zdGF0cyksCi0J
CQkJICBHRlBfS0VSTkVMLCBjcHVfdG9fbm9kZShpKSk7CisJCQkJICBHRlBfS0VSTkVMX0FDQ09V
TlQsIGNwdV90b19ub2RlKGkpKTsKIAkJaWYgKCFzZSkKIAkJCWdvdG8gZXJyX2ZyZWVfcnE7CiAK
LS0gCjIuMzYuMQoK
