From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC PATCH] hugetlbfs: Add hugetlb_cgroup reservation limits
Date: Fri, 9 Aug 2019 14:00:21 -0700
Message-ID: <af6a8c43-e286-5360-61f3-6d306d8f1951@oracle.com>
References: <20190808194002.226688-1-almasrymina@google.com>
 <20190809112738.GB13061@blackbody.suse.cz>
 <CAHS8izNM3jYFWHY5UJ7cmJ402f-RKXzQ=JFHpD7EkvpAdC2_SA@mail.gmail.com>
 <fc420531-f0fe-8df5-57fe-71a686bf2a71@oracle.com>
 <CAHS8izN9BFASse_pjLEhQzWwofjRv+JQ5Z=ZiR6Wywn2USLELA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=9sLztaDMB8aeSX3WL8ufO6Qlj+pu4SLKowKGxHUAYS8=;
 b=pcYp9yfI3GuKYjG0G1hZnUZ4mlVzJhMn8SDnFIAzHBL80YDKrjzKOIYK5jCrJnoZCC7T
 RRO8mCE2iaWu46snuI9l0EoYMXANzjdEMQ57i1CRXiO6XGPmABWxu2DmDbWlcq7LKuyz
 yNF6hBnc83a66hJimNA6UgiMfpJe0JRVQWDKBFil0LYD8mLzdiOg2n96TIJwiX282nbH
 c9Pjrfahh0u7DRAhZHcOitDBo33YQph1lvHMNnfypeliX/9mlv6NZyaXOU7uSuk/Yyl5
 5vi7kruxTckNH64kZyDfpogI8yEcQJ7JtVKRpFpngUgaLve2gShL6D1Z25RDCpAIQ70n Cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=9sLztaDMB8aeSX3WL8ufO6Qlj+pu4SLKowKGxHUAYS8=;
 b=UefUInbUUZVRUhWHdFjDeVmYihsfyeb61d47cAMjPnlxeMdTTxQ76xdZCw2SPU++rVKt
 bG0sK1hFkwkSCJS/zxMt/pdcl0734OhVrIAp8qyhNAOUQkwXW/GeHY8WNyXFIgRV/pV7
 86uwKsYH94fY2QX0WVToNPbbsBB1VL+XOdq9/mjdldNniAKHzPrIzYiec+dKe36ZfSW7
 15CKaLG/oZyet44aTb2NcVFdZ7b934CoDlRI8j4hKxohV9Hh6dP84fv3f65XPbtYhZq7
 PCFCjFg8zoSvpYzoXE4PerYHA7HB53JMytkkEs8emfM8PAk1NNjTa1dy7pcK1wejnL69 hw== 
In-Reply-To: <CAHS8izN9BFASse_pjLEhQzWwofjRv+JQ5Z=ZiR6Wywn2USLELA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Mina Almasry <almasrymina@google.com>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, akpm@linux-foundation.org, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

T24gOC85LzE5IDE6NTcgUE0sIE1pbmEgQWxtYXNyeSB3cm90ZToKPiBPbiBGcmksIEF1ZyA5LCAy
MDE5IGF0IDE6MzkgUE0gTWlrZSBLcmF2ZXR6IDxtaWtlLmtyYXZldHpAb3JhY2xlLmNvbT4gd3Jv
dGU6Cj4+Cj4+IE9uIDgvOS8xOSAxMTowNSBBTSwgTWluYSBBbG1hc3J5IHdyb3RlOgo+Pj4gT24g
RnJpLCBBdWcgOSwgMjAxOSBhdCA0OjI3IEFNIE1pY2hhbCBLb3V0bsO9IDxta291dG55QHN1c2Uu
Y29tPiB3cm90ZToKPj4+Pj4gQWx0ZXJuYXRpdmVzIGNvbnNpZGVyZWQ6Cj4+Pj4+IFsuLi5dCj4+
Pj4gKEkgZGlkIG5vdCB0cnkgdGhhdCBidXQpIGhhdmUgeW91IGNvbnNpZGVyZWQ6Cj4+Pj4gMykg
TUFQX1BPUFVMQVRFIHdoaWxlIHlvdSdyZSBtYWtpbmcgdGhlIHJlc2VydmF0aW9uLAo+Pj4KPj4+
IEkgaGF2ZSB0cmllZCB0aGlzLCBhbmQgdGhlIGJlaGF2aW91ciBpcyBub3QgZ3JlYXQuIEJhc2lj
YWxseSBpZgo+Pj4gdXNlcnNwYWNlIG1tYXBzIG1vcmUgbWVtb3J5IHRoYW4gaXRzIGNncm91cCBs
aW1pdCBhbGxvd3Mgd2l0aAo+Pj4gTUFQX1BPUFVMQVRFLCB0aGUga2VybmVsIHdpbGwgcmVzZXJ2
ZSB0aGUgdG90YWwgYW1vdW50IHJlcXVlc3RlZCBieQo+Pj4gdGhlIHVzZXJzcGFjZSwgaXQgd2ls
bCBmYXVsdCBpbiB1cCB0byB0aGUgY2dyb3VwIGxpbWl0LCBhbmQgdGhlbiBpdAo+Pj4gd2lsbCBT
SUdCVVMgdGhlIHRhc2sgd2hlbiBpdCB0cmllcyB0byBhY2Nlc3MgdGhlIHJlc3Qgb2YgaXRzCj4+
PiAncmVzZXJ2ZWQnIG1lbW9yeS4KPj4+Cj4+PiBTbyBmb3IgZXhhbXBsZToKPj4+IC0gaWYgL3By
b2Mvc3lzL3ZtL25yX2h1Z2VwYWdlcyA9PSAxMCwgYW5kCj4+PiAtIHlvdXIgY2dyb3VwIGxpbWl0
IGlzIDUgcGFnZXMsIGFuZAo+Pj4gLSB5b3UgbW1hcChNQVBfUE9QVUxBVEUpIDcgcGFnZXMuCj4+
Pgo+Pj4gVGhlbiB0aGUga2VybmVsIHdpbGwgcmVzZXJ2ZSA3IHBhZ2VzLCBhbmQgd2lsbCBmYXVs
dCBpbiA1IG9mIHRob3NlIDcKPj4+IHBhZ2VzLCBhbmQgd2lsbCBTSUdCVVMgeW91IHdoZW4geW91
IHRyeSB0byBhY2Nlc3MgdGhlIHJlbWFpbmluZyAyCj4+PiBwYWdlcy4gU28gdGhlIHByb2JsZW0g
cGVyc2lzdHMuIEZvbGtzIHdvdWxkIHN0aWxsIGxpa2UgdG8ga25vdyB0aGV5Cj4+PiBhcmUgY3Jv
c3NpbmcgdGhlIGxpbWl0cyBvbiBtbWFwIHRpbWUuCj4+Cj4+IElmIHlvdSBnb3QgdGhlIGZhaWx1
cmUgYXQgbW1hcCB0aW1lIGluIHRoZSBNQVBfUE9QVUxBVEUgY2FzZSB3b3VsZCB0aGlzCj4+IGJl
IHVzZWZ1bD8KPj4KPj4gSnVzdCB0aGlua2luZyB0aGF0IHdvdWxkIGJlIGEgcmVsYXRpdmVseSBz
aW1wbGUgY2hhbmdlLgo+IAo+IE5vdCBxdWl0ZSwgdW5mb3J0dW5hdGVseS4gQSBzdWJzZXQgb2Yg
dGhlIGZvbGtzIHRoYXQgd2FudCB0byB1c2UKPiBodWdldGxiIG1lbW9yeSwgZG9uJ3Qgd2FudCB0
byB1c2UgTUFQX1BPUFVMQVRFIChJSVJDLCBzb21ldGhpbmcgYWJvdXQKPiBtbWFwaW5nIGEgaHVn
ZSBhbW91bnQgb2YgaHVnZXRsYiBtZW1vcnkgYXQgdGhlaXIgam9icycgc3RhcnR1cCwgYW5kCj4g
ZG9pbmcgdGhhdCB3aXRoIE1BUF9QT1BVTEFURSBhZGRzIHNvIG11Y2ggdG8gdGhlaXIgc3RhcnR1
cCB0aW1lIHRoYXQKPiBpdCBpcyBwcm9oaWJpdGl2ZWx5IGV4cGVuc2l2ZSAtIGJ1dCB0aGF0J3Mg
anVzdCB3aGF0IEkgdmFndWVseSByZWNhbGwKPiBvZmZoYW5kLiBJIGNhbiBnZXQgeW91IHRoZSBk
ZXRhaWxzIGlmIHlvdSdyZSBpbnRlcmVzdGVkKS4KClllcywgTUFQX1BPUFVMQVRFIGNhbiBnZXQg
ZXhwZW5zaXZlIGFzIHlvdSB3aWxsIG5lZWQgdG8gemVybyBhbGwgdGhvc2UKaHVnZSBwYWdlcy4K
Ci0tIApNaWtlIEtyYXZldHoK
