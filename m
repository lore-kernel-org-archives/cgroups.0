From: "Accardi, Kristen C" <kristen.c.accardi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: clarification about misc controller and capacity vs. max
Date: Tue, 1 Nov 2022 17:11:13 +0000
Message-ID: <f678f325b47ac64e101c0ccea54c1cd1c4ea4206.camel@intel.com>
References: <2f7b7d6b10bdcbc9a73ea449d3636575124afa25.camel@intel.com>
         <Y2FPSqOaQGnISvXu@slm.duckdns.org>
         <14c21f13ebbcdbd0ea4f75b7fff790b31a05a5aa.camel@intel.com>
         <Y2FR6SYazbxyK5nj@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667322685; x=1698858685;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NBRa5mZ4uMC7rNYE6MB9Zy2fcq4NhTVnlI+sf4/ZXuo=;
  b=kgrXqDIeHbpKllKXBmj95dLv3fNdjUg+SfEP/nMUaVgZJ4cmLvR1ooGO
   /8GweiGjfcrJ44pQ8MkhpLPYSJbWnUb0bxK02rui7u/GAE32D/+mE+n/t
   mOPoIr8QZvJ0zHCD952NskAZwl4h0q/HGH1UlXcFsHyAsfIxS7CeGL8pi
   Un+YXOmB/Fa0pGxPNPP2kPNHbjE4l/R2gb8cZFOc+5ktmjhW9jHe/TypF
   90BLSu8PhWw0EW/9VsAe71+iGuW7DJRsaZ/PJ1T9RpLJNcjkB79ARqouH
   uQOLibc+MFAM0w6QpDYBxGpM/f+LnMmwMlEqDDuFptH6ZE7FPk4Sr71ve
   Q==;
In-Reply-To: <Y2FR6SYazbxyK5nj-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Content-ID: <A1BC5F3B7EA61547B0CC6750064736BD-Hry67jCOGbCcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

T24gVHVlLCAyMDIyLTExLTAxIGF0IDA3OjA1IC0xMDAwLCB0akBrZXJuZWwub3JnIHdyb3RlOg0K
PiBPbiBUdWUsIE5vdiAwMSwgMjAyMiBhdCAwNTowMzoyNVBNICswMDAwLCBBY2NhcmRpLCBLcmlz
dGVuIEMgd3JvdGU6DQo+ID4gU28gdG8gYmUgY2xlYXIsIGlmIEkgaGF2ZSB0aGlzOg0KPiA+IA0K
PiA+IC9zeXMvZnMvY2dyb3VwL21pc2MuY2FwYWNpdHkNCj4gPiBzb21lX3JlcyAxMA0KPiA+IA0K
PiA+IGFuZCB0aGlzOg0KPiA+IC9zeXMvZnMvY2dyb3VwL3Rlc3QNCj4gPiANCj4gPiB0ZXN0LmN1
cnJlbnQgd2lsbCBuZXZlciBiZSBhbGxvd2VkIHRvIGV4Y2VlZCAxMC4NCj4gDQo+IFllcywgYnV0
IHRlc3QubWF4IGNhbiBiZSB3aGF0ZXZlci4gU28sIHRoZSByZXNvdXJjZXMgdGhlbXNlbHZlcyBj
YW4ndA0KPiBiZQ0KPiBvdmVyLWNvbW1pdHRlZC4gVGhlIG1heCBsaW1pdHMgKGllLiB0aGUgcHJv
bWlzZXMpIGNhbiBiZS4NCj4gDQo+IFRoYW5rcy4NCj4gDQoNClRoaXMgaXMgYSBiaXQgb2YgYSBk
ZWFsIGJyZWFrZXIgZm9yIHRoZSB1c2Ugb2YgdGhlIG1pc2MgY29udHJvbGxlciBmb3INClNHWCBF
UEMgbWVtb3J5IC0gd2UgYWxsb3cgb3ZlcmNvbW1pdCBvZiB0aGUgcGh5c2ljYWwgRVBDIG1lbW9y
eSBhcyB3ZQ0KaGF2ZSBiYWNraW5nIFJBTSB0aGF0IGlzIHVzZWQgdG8gc3dhcC4gV291bGQgeW91
IGJlIGFtZW5hYmxlIHRvIGhhdmluZw0KYSBmbGFnIHRvIGlnbm9yZSB0aGUgdG90YWwgY2FwYWNp
dHkgdmFsdWUgYW5kIGFsbG93IGZvciBvdmVyY29tbWl0IG9mDQp0aGUgcmVzb3VyY2U/IElmIG5v
dCBJIGZlZWwgbGlrZSB3ZSBkb24ndCBoYXZlIGEgY2hvaWNlIGJ1dCB0byBjcmVhdGUgYQ0KbmV3
IGNvbnRyb2xsZXIuDQoNCg0K
