From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: RE: [RFC PATCH 05/19] RMDA/siw: Convert to use vm_account
Date: Tue, 24 Jan 2023 15:22:32 +0000
Message-ID: <SA0PR15MB3919CF22BBACD6A25ECFAD2699C99@SA0PR15MB3919.namprd15.prod.outlook.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <4f8b1d54ab5d6909c46ba5470065f8326f9fcc62.1674538665.git-series.apopple@nvidia.com>
 <Y8/tGIeg5mI9bDOa@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : date :
 message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version : subject; s=pp1;
 bh=zKahx/26rU2y5d8c6FBCmzIL/utDrXbK8NwDGiNVaAY=;
 b=fcbGN5z+UgIRxlJSHjJoTvwj1wfiywWaB7m4yqxnwIefp5Nr2pcAC3x+qkeht6h3xy9c
 xHHLUJowvN2aL31s8w19PbYSr/zfSI/ghejkAhtmuPUc9LK2Xfg8wLZiaIvTR3Rl8QkO
 B8u9pvgmoAkyHRjoK3vVe/7COEIZL/64Dm0IiDbACBNFNOD7wOaMkwdEWSewqBVxkFN+
 GAArOUty19lLrPZAL2UllrBxReShJ+z/xpmqkE4EGkTjQ0G2A95dRKhJVOTjQpSuV7jf
 gU18mDNXB3PrXFUDgUgAXjnco55V7zGI6K1Iq0fSLoE6ppBkBh0lZFLBC7c3tlAp/9qP vw== 
In-Reply-To: <Y8/tGIeg5mI9bDOa-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org" <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "mkoutny-IBi9RG/b67k@public.gmane.org" <mkoutny-IBi9RG/b67k@public.gmane.org>, "daniel-/w4YWyX8dFk@public.gmane.org" <daniel-/w4YWyX8dFk@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gR3VudGhvcnBl
IDxqZ2dAbnZpZGlhLmNvbT4NCj4gU2VudDogVHVlc2RheSwgMjQgSmFudWFyeSAyMDIzIDE1OjM3
DQo+IFRvOiBBbGlzdGFpciBQb3BwbGUgPGFwb3BwbGVAbnZpZGlhLmNvbT4NCj4gQ2M6IGxpbnV4
LW1tQGt2YWNrLm9yZzsgY2dyb3Vwc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxA
dmdlci5rZXJuZWwub3JnOyBqaHViYmFyZEBudmlkaWEuY29tOyB0am1lcmNpZXJAZ29vZ2xlLmNv
bTsNCj4gaGFubmVzQGNtcHhjaGcub3JnOyBzdXJlbmJAZ29vZ2xlLmNvbTsgbWtvdXRueUBzdXNl
LmNvbTsgZGFuaWVsQGZmd2xsLmNoOw0KPiBCZXJuYXJkIE1ldHpsZXIgPEJNVEB6dXJpY2guaWJt
LmNvbT47IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPjsNCj4gbGludXgtcmRtYUB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW0VYVEVSTkFMXSBSZTogW1JGQyBQQVRDSCAwNS8x
OV0gUk1EQS9zaXc6IENvbnZlcnQgdG8gdXNlDQo+IHZtX2FjY291bnQNCj4gDQo+IE9uIFR1ZSwg
SmFuIDI0LCAyMDIzIGF0IDA0OjQyOjM0UE0gKzExMDAsIEFsaXN0YWlyIFBvcHBsZSB3cm90ZToN
Cj4gDQo+ID4gQEAgLTM4NSwyMCArMzgyLDE2IEBAIHN0cnVjdCBzaXdfdW1lbSAqc2l3X3VtZW1f
Z2V0KHU2NCBzdGFydCwgdTY0IGxlbiwNCj4gYm9vbCB3cml0YWJsZSkNCj4gPiAgCWlmICghdW1l
bSkNCj4gPiAgCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsNCj4gPg0KPiA+IC0JbW1fcyA9IGN1
cnJlbnQtPm1tOw0KPiA+IC0JdW1lbS0+b3duaW5nX21tID0gbW1fczsNCj4gPiAgCXVtZW0tPndy
aXRhYmxlID0gd3JpdGFibGU7DQo+ID4NCj4gPiAtCW1tZ3JhYihtbV9zKTsNCj4gPiArCXZtX2Fj
Y291bnRfaW5pdF9jdXJyZW50KCZ1bWVtLT52bV9hY2NvdW50KTsNCj4gPg0KPiA+ICAJaWYgKHdy
aXRhYmxlKQ0KPiA+ICAJCWZvbGxfZmxhZ3MgfD0gRk9MTF9XUklURTsNCj4gPg0KPiA+IC0JbW1h
cF9yZWFkX2xvY2sobW1fcyk7DQo+ID4gKwltbWFwX3JlYWRfbG9jayhjdXJyZW50LT5tbSk7DQo+
ID4NCj4gPiAtCW1sb2NrX2xpbWl0ID0gcmxpbWl0KFJMSU1JVF9NRU1MT0NLKSA+PiBQQUdFX1NI
SUZUOw0KPiA+IC0NCj4gPiAtCWlmIChudW1fcGFnZXMgKyBhdG9taWM2NF9yZWFkKCZtbV9zLT5w
aW5uZWRfdm0pID4gbWxvY2tfbGltaXQpIHsNCj4gPiArCWlmICh2bV9hY2NvdW50X3Bpbm5lZCgm
dW1lbS0+dm1fYWNjb3VudCwgbnVtX3BhZ2VzKSkgew0KPiA+ICAJCXJ2ID0gLUVOT01FTTsNCj4g
PiAgCQlnb3RvIG91dF9zZW1fdXA7DQo+ID4gIAl9DQo+ID4gQEAgLTQyOSw3ICs0MjIsNiBAQCBz
dHJ1Y3Qgc2l3X3VtZW0gKnNpd191bWVtX2dldCh1NjQgc3RhcnQsIHU2NCBsZW4sDQo+IGJvb2wg
d3JpdGFibGUpDQo+ID4gIAkJCQlnb3RvIG91dF9zZW1fdXA7DQo+ID4NCj4gPiAgCQkJdW1lbS0+
bnVtX3BhZ2VzICs9IHJ2Ow0KPiA+IC0JCQlhdG9taWM2NF9hZGQocnYsICZtbV9zLT5waW5uZWRf
dm0pOw0KPiANCj4gQWxzbyBmaXhlcyB0aGUgcmFjZSBidWcNCj4gDQpUcnVlISBTaG91bGQgaGF2
ZSB1c2VkIGF0b21pYzY0X2FkZF9yZXR1cm4oKSBpbiB0aGUgZmlyc3QgcGxhY2UuLi4NCg0KQmVy
bmFyZC4NCg0K
