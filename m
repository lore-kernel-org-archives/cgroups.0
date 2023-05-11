From: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Thu, 11 May 2023 00:53:26 +0000
Message-ID: <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683766484; x=1715302484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IBkdCOBw6ZGIPIH0rBLY0HHIrIIviKVRYEjMHuTPOmI=;
  b=jUwBmcbaoOw+BUxEpSTT/qkLIdytW2rXqBaSwbDny3s3cV4DJqVryY56
   3FiD423ZQp2ql5uP1eThpaYqo3D+GPE86VHyRsprHpj+Z1xgcOpsYPcmp
   HJir3BRpx1BCuSEtHwQDaeZ/75Vg93N8Zt6dQ8PXT4ZeJT2EyUYDqEodK
   CHUh6YTStraAsePb/zNtcm1y4XkLlBUwBVxnurv31gh/raXgg5HgGFgCl
   f76fdrULfSMlGBSDEPaBo06YnzMM1dDLJg/18SBmorgSsjQbyjnC1zMLc
   GKMyJPU6SfN10IZxaPFNQDTAOqZCAAUPtqluBaLUmZ/Xc8JfiF+baSwG0
   A==;
In-Reply-To: <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hha2VlbCBCdXR0IDxz
aGFrZWVsYkBnb29nbGUuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDExLCAyMDIzIDM6MDAg
QU0NCj4gVG86IFpoYW5nLCBDYXRoeSA8Y2F0aHkuemhhbmdAaW50ZWwuY29tPg0KPiBDYzogRXJp
YyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgTGludXggTU0gPGxpbnV4LQ0KPiBtbUBr
dmFjay5vcmc+OyBDZ3JvdXBzIDxjZ3JvdXBzQHZnZXIua2VybmVsLm9yZz47IFBhb2xvIEFiZW5p
DQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVs
Lm9yZzsNCj4gQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsg
U3Jpbml2YXMsIFN1cmVzaA0KPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4sIFRp
bSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwNCj4gTGl6aGVuIDxsaXpoZW4ueW91QGlu
dGVsLmNvbT47IGVyaWMuZHVtYXpldEBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+c2tf
Zm9yd2FyZF9hbGxvYyBhcyBhIHByb3Blcg0KPiBzaXplDQo+IA0KPiBPbiBXZWQsIE1heSAxMCwg
MjAyMyBhdCA5OjA54oCvQU0gWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+
IHdyb3RlOg0KPiA+DQo+ID4NCj4gWy4uLl0NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEhhdmUgeW91
IHRyaWVkIHRvIGluY3JlYXNlIGJhdGNoIHNpemVzID8NCj4gPiA+ID4NCj4gPiA+ID4gSSBqdXMg
cGlja2VkIHVwIDI1NiBhbmQgMTAyNCBmb3IgYSB0cnksIGJ1dCBubyBoZWxwLCB0aGUgb3Zlcmhl
YWQgc3RpbGwNCj4gZXhpc3RzLg0KPiA+ID4NCj4gPiA+IFRoaXMgbWFrZXMgbm8gc2Vuc2UgYXQg
YWxsLg0KPiA+DQo+ID4gRXJpYywNCj4gPg0KPiA+IEkgYWRkZWQgYSBwcl9pbmZvIGluIHRyeV9j
aGFyZ2VfbWVtY2coKSB0byBwcmludCBucl9wYWdlcyBpZiBucl9wYWdlcw0KPiA+ID49IE1FTUNH
X0NIQVJHRV9CQVRDSCwgZXhjZXB0IGl0IHByaW50cyA2NCBkdXJpbmcgdGhlIGluaXRpYWxpemF0
aW9uDQo+ID4gb2YgaW5zdGFuY2VzLCB0aGVyZSBpcyBubyBvdGhlciBvdXRwdXQgZHVyaW5nIHRo
ZSBydW5uaW5nLiBUaGF0IG1lYW5zDQo+ID4gbnJfcGFnZXMgaXMgbm90IG92ZXIgNjQsIEkgZ3Vl
c3MgdGhhdCBtaWdodCBiZSB0aGUgcmVhc29uIHdoeSB0bw0KPiA+IGluY3JlYXNlIE1FTUNHX0NI
QVJHRV9CQVRDSCBkb2Vzbid0IGFmZmVjdCB0aGlzIGNhc2UuDQo+ID4NCj4gDQo+IEkgYW0gYXNz
dW1pbmcgeW91IGluY3JlYXNlZCBNRU1DR19DSEFSR0VfQkFUQ0ggdG8gMjU2IGFuZCAxMDI0IGJ1
dA0KPiB0aGF0IGRpZCBub3QgaGVscC4gVG8gbWUgdGhhdCBqdXN0IG1lYW5zIHRoZXJlIGlzIGEg
ZGlmZmVyZW50IGJvdHRsZW5lY2sgaW4gdGhlDQo+IG1lbWNnIGNoYXJnaW5nIGNvZGVwYXRoLiBD
YW4geW91IHBsZWFzZSBzaGFyZSB0aGUgcGVyZiBwcm9maWxlPyBQbGVhc2UNCj4gbm90ZSB0aGF0
IG1lbWNnIGNoYXJnaW5nIGRvZXMgYSBsb3Qgb2Ygb3RoZXIgdGhpbmdzIGFzIHdlbGwgbGlrZSB1
cGRhdGluZw0KPiBtZW1jZyBzdGF0cyBhbmQgY2hlY2tpbmcgKGFuZCBlbmZvcmNpbmcpIG1lbW9y
eS5oaWdoIGV2ZW4gaWYgeW91IGhhdmUgbm90DQo+IHNldCBtZW1vcnkuaGlnaC4NCg0KVGhhbmtz
IFNoYWtlZWwhIEkgd2lsbCBjaGVjayBtb3JlIGRldGFpbHMgb24gd2hhdCB5b3UgbWVudGlvbmVk
LiBXZSB1c2UNCiJzdWRvIHBlcmYgdG9wIC1wICQoZG9ja2VyIGluc3BlY3QgLWYgJ3t7LlN0YXRl
LlBpZH19JyBtZW1jYWNoZWRfMikiIHRvIG1vbml0b3INCm9uZSBvZiB0aG9zZSBpbnN0YW5jZXMs
IGFuZCBhbHNvIHVzZSAic3VkbyBwZXJmIHRvcCIgdG8gY2hlY2sgdGhlIG92ZXJoZWFkIGZyb20N
CnN5c3RlbSB3aWRlLg0K
