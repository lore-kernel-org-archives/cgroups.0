From: "Tamminen, Eero T" <eero.t.tamminen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 8/9] drm/gem: Associate GEM objects with drm cgroup
Date: Mon, 10 May 2021 16:06:31 +0000
Message-ID: <09a39aa58c064a8f8e696a091a1b5edd22ef58b9.camel@intel.com>
References: <20210126214626.16260-1-brian.welty@intel.com>
         <20210126214626.16260-9-brian.welty@intel.com>
         <YCJp//kMC7YjVMXv@phenom.ffwll.local>
         <dffeb6a7-90f1-e17c-9695-44678e7a39cb@intel.com>
         <YCVOl8/87bqRSQei@phenom.ffwll.local>
         <89a71735-aae5-2617-c017-310207c5873b@intel.com>
         <CAKMK7uG2PFMWXa9o4LzsF1r0Mc-M8KqD-PKZkCj+m7XeO5wCyg@mail.gmail.com>
         <67867078-4f4b-0a6a-e55d-453b973d8b7c@intel.com>
         <CAKMK7uG7EWv93EbRcMRCm+opi=7fQPMOv2z1R6GBhJXb6--28w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKMK7uG7EWv93EbRcMRCm+opi=7fQPMOv2z1R6GBhJXb6--28w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <5931D961B8B5484C894BA9ABDE9A0665-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "daniel-/w4YWyX8dFk@public.gmane.org" <daniel-/w4YWyX8dFk@public.gmane.org>, "Welty, Brian" <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "airlied-cv59FeDIM0c@public.gmane.org" <airlied-cv59FeDIM0c@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "christian.koenig-5C7GfCeVMHo@public.gmane.org" <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org" <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, "tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Kenny.Ho-5C7GfCeVMHo@public.gmane.org" <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

SGksDQoNCk1vbiwgMjAyMS0wNS0xMCBhdCAxNzozNiArMDIwMCwgRGFuaWVsIFZldHRlciB3cm90
ZToNCj4gDQouLi4NCj4gPiBJZiBEUk0gYWxsb3dzIHVzZXItc3BhY2UgdG8gZXhoYXVzdCBhbGwg
b2Ygc3lzdGVtIG1lbW9yeSwgdGhpcyBzZWVtcw0KPiA+IHRvIGJlIGEgZ2FwIGluIGVuZm9yY2Vt
ZW50IG9mIE1FTUNHIGxpbWl0cyBmb3Igc3lzdGVtIG1lbW9yeS4NCj4gPiBJIHRyaWVkIHRvIGxv
b2sgaW50byBpdCB3aGVuIHRoaXMgd2FzIGRpc2N1c3NlZCBpbiB0aGUgcGFzdC4uLi4NCj4gPiBN
eSBndWVzcyBpcyB0aGF0IHNobWVtX3JlYWRfbWFwcGluZ19wYWdlX2dmcCgpIC0+DQo+ID4gc2ht
ZW1fZ2V0cGFnZV9nZnAoKSBpcyBub3QgY2hvb3NpbmcgdGhlIGNvcnJlY3QgTU0gdG8gY2hhcmdl
IGFnYWluc3QNCj4gPiBpbiB0aGUgdXNlIGNhc2Ugb2YgZHJpdmVycyB1c2luZyBzaG1lbWZzIGZv
ciBiYWNraW5nIGdlbSBidWZmZXJzLg0KPiANCj4gWWVhaCB3ZSBrbm93IGFib3V0IHRoaXMgb25l
IHNpbmNlIGZvcmV2ZXIuIFRoZSBidWcgcmVwb3J0IGlzIHJvdWdobHkNCj4gYXMgb2xkIGFzIHRo
ZSBnZW0vdHRtIG1lbW9yeSBtYW5hZ2VycyA6LS8gU28gYW5vdGhlciBwcm9ibGVtIG1pZ2h0IGJl
DQo+IHRoYXQgaWYgd2Ugbm93IHN1ZGRlbmx5IGluY2x1ZGUgZ3B1IG1lbW9yeSBpbiB0aGUgbWVt
Y2cgYWNjb3VudGluZywgd2UNCj4gc3RhcnQgYnJlYWtpbmcgYSBidW5jaCBvZiB3b3JrbG9hZHMg
dGhhdCB3b3JrZWQganVzdCBmaW5lIGJlZm9yZWhhbmQuDQoNCkl0J3Mgbm90IHRoZSBmaXJzdCB0
aW1lIHRpZ2h0ZW5pbmcgc2VjdXJpdHkgcmVxdWlyZXMgYWRhcHRpbmcgc2V0dGluZ3MNCmZvciBy
dW5uaW5nIHdvcmtsb2Fkcy4uLg0KDQpXb3JrbG9hZCBHUFUgbWVtb3J5IHVzYWdlIG5lZWRzIHRv
IGJlIHNpZ25pZmljYW50IHBvcnRpb24gb2YNCmFwcGxpY2F0aW9uJ3MgcmVhbCBtZW1vcnkgdXNh
Z2UsIHRvIGNhdXNlIHdvcmtsb2FkIHRvIGhpdCBsaW1pdHMgdGhhdA0KaGF2ZSBiZWVuIHNldCBm
b3IgaXQgZWFybGllci4gIFRoZXJlZm9yZSBJIHRoaW5rIGl0IHRvIGRlZmluaXRlbHkgYmUNCnNv
bWV0aGluZyB0aGF0IHVzZXIgc2V0dGluZyBzdWNoIGxpbWl0cyBhY3R1YWxseSBjYXJlcyBhYm91
dC4NCg0KPT4gSSB0aGluayB0aGUgaW1wb3J0YW50IHRoaW5nIGlzIHRoYXQgcmVhc29uIGZvciB0
aGUgZmFpbHVyZXMgaXMgY2xlYXINCmZyb20gdGhlIE9PTSBtZXNzYWdlLiAgVGhpcyB3b3JrcyBt
dWNoIGJldHRlciBpZiBHUFUgcmVsYXRlZCBtZW1vcnkNCnVzYWdlIGlzIHNwZWNpZmljYWxseSBz
dGF0ZWQgaW4gdGhhdCBtZXNzYWdlLCBvbmNlIHRoYXQgbWVtb3J5IHN0YXJ0cyB0bw0KYmUgYWNj
b3VudGVkIGZvciBzeXN0ZW0gbWVtb3J5Lg0KDQoNCgktIEVlcm8NCg0K
