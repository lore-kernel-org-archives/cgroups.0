From: "Huang, Kai" <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] misc_cgroup: Fix the obsolete comment around 'struct
 misc_res'
Date: Mon, 24 Jul 2023 22:17:43 +0000
Message-ID: <75579ac7ccf3c3b340f432b822d87eab716a51fc.camel@intel.com>
References: <20230724115425.1452383-1-kai.huang@intel.com>
         <7690e7b2-6e7f-6ff1-5249-72f497f82f7e@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690237072; x=1721773072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iRaQG8oA51d1U/OxRKCbJABhr3dX4Ptnngbq9LEtfzA=;
  b=RE5R+aE0RXwedmIkplvUjqnFF1lLg7D7Yj62jkK9cxfos98VlQ8wT6Wj
   gawxl6GJnziGQtFExe1uIBab4qCWAdBMPs6adr9K7/ASkoiLaOVgrPU9J
   +oQ99zCDJ3fnwWKIfKROv9vPO5L87OI7oJKshAcX7Nuz1TTY/q93JVvDX
   ed7mNNGI9fnbMuQsuu6vXjtflxZPW16R5D/T7Nnbz3zHKQ6x6K6xbAPNe
   Tliun1yp5vLyIKJJIpOmFzzmVJ5hCyrrLY+kZzoEwZ0TwwzE5yfnLfRTl
   CQINPygpW+jUBYH9gXsoyLEBp4KesbNnEqLshL47QEZUNQROceWyKoCuk
   w==;
In-Reply-To: <7690e7b2-6e7f-6ff1-5249-72f497f82f7e-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <57F7224580EB3D4390534A27EC8115C3-Hry67jCOGbCcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

T24gTW9uLCAyMDIzLTA3LTI0IGF0IDE5OjE0ICswNTMwLCBLYW1hbGVzaCBCYWJ1bGFsIHdyb3Rl
Og0KPiANCj4gT24gNy8yNC8yMyAxNzoyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFRoZSBjb21t
ZW50IG9mIHRoZSAnZmFpbGVkJyBtZW1iZXIgb2YgJ3N0cnVjdCBtaXNjX3JlcycgaXMgb2Jzb2xl
dGUNCj4gPiBzaW5jZSBjb21taXQgYjAzMzU3NTI4ZmQ5ICgibWlzY19jZ3JvdXA6IHJlbW92ZSBl
cnJvciBsb2cgdG8gYXZvaWQgbG9nDQo+ID4gZmxvb2QiKSwgd2hpY2ggcmVtb3ZlZCB0aGUgJ2Zh
aWxlZCcgbWVtYmVyIGZyb20gdGhlIHN0cnVjdHVyZS4gIFJlbW92ZQ0KPiA+IHRoZSBvYnNvbGV0
ZSBjb21tZW50Lg0KPiA+IA0KPiA+IEFsc28gYWRkIHRoZSBtaXNzaW5nIGNvbW1lbnQgZm9yIHRo
ZSAnZXZlbnRzJyBmaWVsZCwgd2hpY2ggc2hvdWxkIGNvbWUNCj4gPiB3aXRoIGNvbW1pdCBmMjc5
Mjk0YjMyOTMgKCJtaXNjX2Nncm91cDogaW50cm9kdWNlIG1pc2MuZXZlbnRzIHRvIGNvdW50DQo+
ID4gZmFpbHVyZXMiKSB3aGVyZSB0aGUgJ2V2ZW50cycgbWVtYmVyIHdhcyBhZGRlZC4NCj4gDQo+
IFRoaXMgaGFzIGJlZW4gZml4ZWQgYnk6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwv
MjAyMzA3MTgwOTA4MzQuMTgyOTE5MS0xLWthbWFsZXNoLmJhYnVsYWxAb3JhY2xlLmNvbS8NCj4g
DQo+ID4gDQoNCkFoIEkgbWlzc2VkIHRoaXMuICBUaGVuIHBsZWFzZSBpZ25vcmUgdGhpcyBwYXRj
aC4gIFRoYW5rcyENCg==
