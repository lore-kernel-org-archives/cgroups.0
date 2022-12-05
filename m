From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Mon, 5 Dec 2022 17:39:33 +0800
Message-ID: <f227e4bd-c74b-a02e-2a02-11a1376ee4f9@huaweicloud.com>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
 <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
 <3da991c6-21e4-8ed8-ba75-ccb92059f0ae@huaweicloud.com>
 <Y306xJV6aNXd94kb@slm.duckdns.org>
 <1f52ccb1-c357-a2a0-ef9d-48d7e2eb51f8@kernel.dk>
 <Y31sYFdA2lHIvjt3@slm.duckdns.org>
 <ec3754a6-3249-51ab-b659-fd795884e346@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ec3754a6-3249-51ab-b659-fd795884e346-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="gb2312"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

SGksIFRlanVuCgrU2iAyMDIyLzExLzIzIDE4OjIyLCBZdSBLdWFpINC0tcA6Cj4gSGksIFRlanVu
Cj4gCj4g1NogMjAyMi8xMS8yMyA4OjQyLCBUZWp1biBIZW8g0LS1wDoKPj4gT24gVHVlLCBOb3Yg
MjIsIDIwMjIgYXQgMDU6MTQ6MjlQTSAtMDcwMCwgSmVucyBBeGJvZSB3cm90ZToKPj4+Pj4gVGhl
biBtYXRjaF9zdHJkdXAoKSBhbmQga2ZyZWUoKSBpbiBtYXRjaF9OVU1CRVIoKSBjYW4gYmUgcmVw
bGFjZWQgd2l0aAo+Pj4+PiBnZXRfYnVmZmVyKCkgYW5kIHB1dF9idWZmZXIoKS4KPj4+Pgo+Pj4+
IFNvcnJ5IGFib3V0IHRoZSBsYXRlIHJlcGx5LiBZZWFoLCBzb21ldGhpbmcgbGlrZSB0aGlzLgo+
IAoKSSB3b25kZXIgY2FuIHdlIGp1c3QgdXNlIGFyYXJ5IGRpcmVjdGx5IGluIHN0YWNrPyBUaGUg
bWF4IHNpemUgaXMganVzdAoyNCBieXRlcywgd2hpY2ggc2hvdWxkIGJlIGZpbmU6CgpIRVg6ICIw
eEZGRkZGRkZGRkZGRkZGRkYiIC0tPiAxOApERUM6ICIxODQ0Njc0NDA3MzcwOTU1MTYxNSIgLS0+
IDIwCk9DVDogIjAxNzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3IiAtLT4gMjMKClNvbWV0aGluZyBsaWtl
OgojZGVmaW5lIFU2NF9NQVhfU0laRSAyMwpzdGF0aWMgaW50IG1hdGNoX3N0cmR1cF9sb2NhbChj
b25zdCBzdWJzdHJpbmdfdCAqcywgY2hhciAqYnVmKQp7CglzaXplX3QgbGVuID0gcy0+dG8gLSBz
LT5mcm9tOwoKCWlmIChsZW4gPiBVNjRfTUFYX1NJWkUpCgkJcmV0dXJuIC1FUkFOR0U7CgoJaWYg
KCFzLT5mcm9tKQoJCXJldHVybiAtRUlOVkFMOwoKCW1lbWNweShidWYsIHMtPmZyb20sIGxlbik7
CglidWZbbGVuXSA9ICdcMCc7CglyZXR1cm4gMDsKfQoKICBzdGF0aWMgaW50IG1hdGNoX3U2NGlu
dChzdWJzdHJpbmdfdCAqcywgdTY0ICpyZXN1bHQsIGludCBiYXNlKQogIHsKCWNoYXIgYnVmW1U2
NF9NQVhfU0laRSArIDFdOwogIAlpbnQgcmV0OwogIAl1NjQgdmFsOwoKCXJldCA9IG1hdGNoX3N0
cmR1cF9sb2NhbChzLCBidWYpOwoJaWYgKHJldCkKCQlyZXR1cm4gcmV0OwogIAlyZXQgPSBrc3Ry
dG91bGwoYnVmLCBiYXNlLCAmdmFsKTsKICAJaWYgKCFyZXQpCiAgCQkqcmVzdWx0ID0gdmFsOzsK
ICAJcmV0dXJuIHJldDsKICB9Cgo=
