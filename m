From: Rik van Riel <riel@fb.com>
Subject: Re: [PATCH 2/4] bdi: Add bdi->id
Date: Fri, 9 Aug 2019 00:57:24 +0000
Message-ID: <775309de70c1371e852fa5e6f84ca1ca2727faa0.camel@fb.com>
References: <20190803140155.181190-1-tj@kernel.org>
         <20190803140155.181190-3-tj@kernel.org>
         <20190806160102.11366694af6b56d9c4ca6ea3@linux-foundation.org>
         <20190807183151.GM136335@devbig004.ftw2.facebook.com>
         <20190807120037.72018c136db40e88d89c05d1@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=/BPU77XJe1qy2ASoI5lFobOZEYDoCwlx/KYqwMSP0aY=;
 b=qdmRVyTW7vOPlR31vJUZ374HcyFcs7eaixAb/F6dZuUV9I48T2nH8zRTT19KdeW9/bzJ
 kX6MPH/wfRmXQZqAbQMGV8O5uCabXA4nA1zp6Lb7q7GBiVSi6V3yQbF2SdXlLEePMU4R
 vVuVnLtFpPzk9KRyWgjktVNsWBPUNGURRlo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BPU77XJe1qy2ASoI5lFobOZEYDoCwlx/KYqwMSP0aY=;
 b=b8qmWhKlB2740VAbokWnsRlAQh05Y8xlXNDrJdjX9dj4d2WYpY0H+z87VoAluX/RArfXTA0OwMyuEyRSDQV0T9ByM+YPRVjatTSeDwmZ34gxajhfz6G4ydyYmceNdA5UXEtbLRCE4IFfHqjxQu/Zda7Dm4xkON6bX47XJWITGPQ=
In-Reply-To: <20190807120037.72018c136db40e88d89c05d1@linux-foundation.org>
Content-Language: en-US
Content-ID: <407D6DBF6F662F4A87AD469AF3BAF9A2@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "jack@suse.cz" <jack@suse.cz>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "mhocko@kernel.org" <mhocko@kernel.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Roman Gushchin <guro@fb.com>

T24gV2VkLCAyMDE5LTA4LTA3IGF0IDEyOjAwIC0wNzAwLCBBbmRyZXcgTW9ydG9uIHdyb3RlOg0K
PiBPbiBXZWQsIDcgQXVnIDIwMTkgMTE6MzE6NTEgLTA3MDAgVGVqdW4gSGVvIDx0akBrZXJuZWwu
b3JnPiB3cm90ZToNCj4gDQo+ID4gSGVsbG8sDQo+ID4gDQo+ID4gT24gVHVlLCBBdWcgMDYsIDIw
MTkgYXQgMDQ6MDE6MDJQTSAtMDcwMCwgQW5kcmV3IE1vcnRvbiB3cm90ZToNCj4gPiA+IE9uIFNh
dCwgIDMgQXVnIDIwMTkgMDc6MDE6NTMgLTA3MDAgVGVqdW4gSGVvIDx0akBrZXJuZWwub3JnPg0K
PiA+ID4gd3JvdGU6DQo+ID4gPiA+IFRoZXJlIGN1cnJlbnRseSBpcyBubyB3YXkgdG8gdW5pdmVy
c2FsbHkgaWRlbnRpZnkgYW5kIGxvb2t1cCBhDQo+ID4gPiA+IGJkaQ0KPiA+ID4gPiB3aXRob3V0
IGhvbGRpbmcgYSByZWZlcmVuY2UgYW5kIHBvaW50ZXIgdG8gaXQuICBUaGlzIHBhdGNoIGFkZHMN
Cj4gPiA+ID4gYW4NCj4gPiA+ID4gbm9uLXJlY3ljbGluZyBiZGktPmlkIGFuZCBpbXBsZW1lbnRz
IGJkaV9nZXRfYnlfaWQoKSB3aGljaA0KPiA+ID4gPiBsb29rcyB1cA0KPiA+ID4gPiBiZGlzIGJ5
IHRoZWlyIGlkcy4gIFRoaXMgd2lsbCBiZSB1c2VkIGJ5IG1lbWNnIGZvcmVpZ24gaW5vZGUNCj4g
PiA+ID4gZmx1c2hpbmcuDQo+ID4gPiANCj4gPiA+IFdoeSBpcyB0aGUgaWQgbm9uLXJlY3ljbGlu
Zz8gIFByZXN1bWFibHkgdG8gYWRkcmVzcyBzb21lDQo+ID4gPiBsaWZldGltZS9sb29rdXAgaXNz
dWVzLCBidXQgd2hhdCBhcmUgdGhleT8NCj4gPiANCj4gPiBUaGUgSUQgYnkgaXRzZWxmIGlzIHVz
ZWQgdG8gcG9pbnQgdG8gdGhlIGJkaSBmcm9tIGNncm91cCBhbmQgaWRyDQo+ID4gcmVjeWNsZXMg
cmVhbGx5IGFnZ3Jlc3NpdmVseS4gIENvbWJpbmVkIHdpdGgsIGZvciBleGFtcGxlLCBsb29wDQo+
ID4gZGV2aWNlDQo+ID4gYmFzZWQgY29udGFpbmVycywgc3RhbGUgcG9pbnRpbmcgY2FuIGJlY29t
ZSBwcmV0dHkgY29tbW9uLiAgV2UncmUNCj4gPiBoYXZpbmcgc2ltaWxhciBpc3N1ZXMgd2l0aCBj
Z3JvdXAgSURzLg0KPiANCj4gT0ssIGJ1dCB3aHkgaXMgcmVjeWNsaW5nIGEgcHJvYmxlbT8gIEZv
ciBleGFtcGxlLCBmaWxlIGRlc2NyaXB0b3JzDQo+IHJlY3ljbGUgYXMgYWdncmVzc2l2ZWx5IGFz
IGlzIHBvc3NpYmxlLCBhbmQgdGhhdCBkb2Vzbid0IGNhdXNlIGFueQ0KPiB0cm91YmxlLiAgUHJl
c3VtYWJseSByZWN5Y2xpbmcgaXMgYSBwcm9ibGVtIHdpdGggY2dyb3VwcyBiZWNhdXNlIG9mDQo+
IHNvbWUgc29ydCBvZiBzdGFsZSByZWZlcmVuY2UgcHJvYmxlbT8NCg0KUElEcywgb24gdGhlIG90
aGVyIGhhbmQsIHdlIHJlY3ljbGUgYXMgc2xvd2x5IGFzDQpwb3NzaWJsZS4uLg0KDQo=
