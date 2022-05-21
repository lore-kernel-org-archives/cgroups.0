From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v2 8/9] memcg: enable accounting for allocations in
 alloc_fair_sched_group
Date: Sat, 21 May 2022 19:38:50 +0300
Message-ID: <46bbde64-7290-cabb-8fef-6f4a30263d8c@openvz.org>
References: <Yn6aL3cO7VdrmHHp@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=qcH7iik2GW8EIkmCTFLKGtsxL3Zpurysxl71BOJq3d0=;
        b=V7d0heHmQbb0lFT0Ux/CBuPX/IC6qfLxB/rSo6O/O0i9wSVjG5Ip4fAl4/azlz37Qp
         o0SKGZNBkBQpcTOI1/8zTI3sf1iWzXfHKzi0xD6JmPR/cm6Pd8BvTLtWPhWK+6TIoH62
         /O8kcXjU9NyHnKAc8SOHrP9rEgcmf6/rXU0G5vRbKLhfgsZdyFOVelMZjNF0atRmcs04
         ZJOc8G8oZX0v36VwWF5fc3JG3qvu3RYUrhI57jhbV6nNKmYcTuStB46lUMnASonXo9nL
         P1eRtwHn0UWufluLGtrgtVexlM7nrm9RiBAoGwuDNoL3Lb9PCOrTMgfOpLLHajkdUvne
         AJ6w==
Content-Language: en-US
In-Reply-To: <Yn6aL3cO7VdrmHHp@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
NEFLbGZRVDBkWlIrQWxmQUBwdWJsaWMuZ21hbmUub3JnPgotLS0KIGtlcm5lbC9zY2hlZC9mYWly
LmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkL2ZhaXIuYyBiL2tlcm5lbC9zY2hlZC9mYWly
LmMKaW5kZXggYTY4NDgyZDY2NTM1Li40NmU2NmFjZjc0NzUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9z
Y2hlZC9mYWlyLmMKKysrIGIva2VybmVsL3NjaGVkL2ZhaXIuYwpAQCAtMTE1MjksMTIgKzExNTI5
LDEyIEBAIGludCBhbGxvY19mYWlyX3NjaGVkX2dyb3VwKHN0cnVjdCB0YXNrX2dyb3VwICp0Zywg
c3RydWN0IHRhc2tfZ3JvdXAgKnBhcmVudCkKIAogCWZvcl9lYWNoX3Bvc3NpYmxlX2NwdShpKSB7
CiAJCWNmc19ycSA9IGt6YWxsb2Nfbm9kZShzaXplb2Yoc3RydWN0IGNmc19ycSksCi0JCQkJICAg
ICAgR0ZQX0tFUk5FTCwgY3B1X3RvX25vZGUoaSkpOworCQkJCSAgICAgIEdGUF9LRVJORUxfQUND
T1VOVCwgY3B1X3RvX25vZGUoaSkpOwogCQlpZiAoIWNmc19ycSkKIAkJCWdvdG8gZXJyOwogCiAJ
CXNlID0ga3phbGxvY19ub2RlKHNpemVvZihzdHJ1Y3Qgc2NoZWRfZW50aXR5X3N0YXRzKSwKLQkJ
CQkgIEdGUF9LRVJORUwsIGNwdV90b19ub2RlKGkpKTsKKwkJCQkgIEdGUF9LRVJORUxfQUNDT1VO
VCwgY3B1X3RvX25vZGUoaSkpOwogCQlpZiAoIXNlKQogCQkJZ290byBlcnJfZnJlZV9ycTsKIAot
LSAKMi4zNi4xCgo=
