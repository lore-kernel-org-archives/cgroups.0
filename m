From: Rik van Riel <riel-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix blocking rstat function called from
 atomic cgroup1 thresholding code
Date: Tue, 3 Aug 2021 14:34:23 +0000
Message-ID: <f3bc8b44d58a5e63178dee40f9c119cfc8bf669b.camel@fb.com>
References: <20210726150019.251820-1-hannes@cmpxchg.org>
         <2b0b08f9385b25fb7750dbe453516b0c8bb27604.camel@fb.com>
         <CALvZod5JmcSpym6oXMXEUXEq2u13SVLRaVGPg84ubeYZt-6w_g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CT6/HOf97jS43kUCtPhkPIIFyT2ScXjvlO0MM1RISSQ=;
 b=UivFhhiUtIqrb6ubVPSuBqtmvsJRJ414quzdJfTHX96Rphds4/HEVoPnEXdruYCKmN8P
 9pIT4nV/BMMr66iXbiZEpUryswo/mfGAuRkMa/zIxWolRR+Q3a0kwJkih1rxW6QYY3TS
 +1uOfUh3vrqklaLAZaNknegn2BF8TtdIjho= 
In-Reply-To: <CALvZod5JmcSpym6oXMXEUXEq2u13SVLRaVGPg84ubeYZt-6w_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <B112876F763DE947905D25E0FC1C39C5-JGF9Izt3QrScE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kernel Team <Kernel-team-b10kYP2dOMg@public.gmane.org>, "dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

T24gVHVlLCAyMDIxLTA3LTI3IGF0IDA5OjUxIC0wNzAwLCBTaGFrZWVsIEJ1dHQgd3JvdGU6DQo+
IE9uIE1vbiwgSnVsIDI2LCAyMDIxIGF0IDg6MTkgQU0gUmlrIHZhbiBSaWVsIDxyaWVsQGZiLmNv
bT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCAyMDIxLTA3LTI2IGF0IDExOjAwIC0wNDAwLCBK
b2hhbm5lcyBXZWluZXIgd3JvdGU6DQo+ID4gPiANCj4gPiA+IF9fbWVtX2Nncm91cF90aHJlc2hv
bGQoKSBpbmRlZWQgaG9sZHMgdGhlIHJjdSBsb2NrLiBJbiBhZGRpdGlvbiwNCj4gPiA+IHRoZQ0K
PiA+ID4gdGhyZXNob2xkaW5nIGNvZGUgaXMgaW52b2tlZCBkdXJpbmcgc3RhdCBjaGFuZ2VzLCBh
bmQgdGhvc2UNCj4gPiA+IGNvbnRleHRzDQo+ID4gPiBoYXZlIGlycXMgZGlzYWJsZWQgYXMgd2Vs
bC4gSWYgdGhlIGxvY2sgYnJlYWtpbmcgb2NjdXJzIGluc2lkZQ0KPiA+ID4gdGhlDQo+ID4gPiBm
bHVzaCBmdW5jdGlvbiwgaXQgd2lsbCByZXN1bHQgaW4gYSBzbGVlcCBmcm9tIGFuIGF0b21pYyBj
b250ZXh0Lg0KPiA+ID4gDQo+ID4gPiBVc2UgdGhlIGlyc2FmZSBmbHVzaGluZyB2YXJpYW50IGlu
IG1lbV9jZ3JvdXBfdXNhZ2UoKSB0byBmaXggdGhpcw0KPiA+IA0KPiA+IFdoaWxlIHRoaXMgZml4
IGlzIG5lY2Vzc2FyeSwgaW4gdGhlIGxvbmcgdGVybSBJIHRoaW5rIHdlIG1heQ0KPiA+IHdhbnQg
c29tZSBzb3J0IG9mIHJlZGVzaWduIGhlcmUsIHRvIG1ha2Ugc3VyZSB0aGUgaXJxIHNhZmUNCj4g
PiB2ZXJzaW9uIGRvZXMgbm90IHNwaW4gbG9uZyB0aW1lcyB0cnlpbmcgdG8gZ2V0IHRoZSBzdGF0
aXN0aWNzDQo+ID4gb2ZmIHNvbWUgb3RoZXIgQ1BVLg0KPiA+IA0KPiA+IEkgaGF2ZSBzZWVuIGEg
bnVtYmVyIG9mIHNvZnQgKElJUkMpIGxvY2t1cHMgZGVlcCBpbnNpZGUgdGhlDQo+ID4gYm93ZWxz
IG9mIGNncm91cF9yc3RhdF9mbHVzaF9pcnFzYWZlLCB3aXRoIHRoZSBmdW5jdGlvbiB0YWtpbmcN
Cj4gPiBtdWx0aXBsZSBzZWNvbmRzIHRvIGNvbXBsZXRlLg0KPiANCj4gQ2FuIHlvdSBwbGVhc2Ug
c2hhcmUgYSBiaXQgbW9yZSBkZXRhaWwgb24gdGhpcyBsb2NrdXA/IEkgYW0gd29uZGVyaW5nDQo+
IGlmIHRoaXMgd2FzIGR1ZSB0byB0aGUgZmx1c2ggbm90IGhhcHBlbmluZyBtb3JlIG9mdGVuIGFu
ZCB0aHVzIHRoZQ0KPiB1cGRhdGUgdHJlZSBpcyBsYXJnZSBvciBpZiB0aGVyZSBhcmUgdG9vIG1h
bnkgY29uY3VycmVudCBmbHVzaGVzDQo+IGhhcHBlbmluZy4NCg0KSSB3YXMgbm90IGxvZ2dlZCBp
bnRvIGFueSBzeXN0ZW0gd2hpbGUgaXQgaGFwcGVuZWQsIGJ1dA0Kb25seSBmb3VuZCBpdCBsYXRl
ciBpbiB0aGUgbG9ncy4NCg0KSSBzdXNwZWN0IHlvdXIgZXhwbGFuYXRpb24gaXMgdGhlIHJlYXNv
biB3aHkgaXQgaGFwcGVuZWQsDQp0aG91Z2guDQoNCg==
