From: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Wed, 10 May 2023 07:03:43 +0000
Message-ID: <CH3PR11MB734547B820C475A465BA6D94FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230509171910.yka3hucbwfnnq5fq@google.com>
 <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769@DM6PR11MB4107.namprd11.prod.outlook.com>
 <CALvZod7njXsc0JDHxxi_+0c=owNwC6m1g_FieRfY4XkfuTmo1A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683702227; x=1715238227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tvLbPwFgOkMqFvNDKByOqDhNqZBze90VLXlTV4kG/0A=;
  b=W8Nq+Hq16pJ9+40z8+H0YPDYq3yRfqXDVZ3ak9SIb1Wc49L8S2ZuWmtt
   Mr12Ld3f4Y3fB8o1RmP4eUWFHE+i7ST+7hBWm6PNH9bENsYzPRizFr+ca
   ZzjRK5q877CLHiJ9zgmXxmuXBPWfKRrCZ2VRka874CPvjgNRXRafHZr69
   as2nSanol4X+DVotzQz4/lkO2jl+FzSkyek0ba09TPUmEfDhRCXV7JGiF
   2J/rduOrbty5k283gMRiE7NRep+bh9GwASvGpG16xX2h3GOrsj1Y65s3x
   IXkciW3bzWEoQiMlYFtH8yODKr3GDMra6pWaKwi3P0294fW8/SuvZQeQj
   w==;
In-Reply-To: <CALvZod7njXsc0JDHxxi_+0c=owNwC6m1g_FieRfY4XkfuTmo1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hha2VlbCBCdXR0IDxz
aGFrZWVsYkBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAxMCwgMjAyMyAyOjE4
IEFNDQo+IFRvOiBDaGVuLCBUaW0gQyA8dGltLmMuY2hlbkBpbnRlbC5jb20+DQo+IENjOiBaaGFu
ZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47IGVkdW1hemV0QGdvb2dsZS5jb207DQo+
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207
IEJyYW5kZWJ1cmcsDQo+IEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47IFNyaW5p
dmFzLCBTdXJlc2gNCj4gPHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBZb3UsIExpemhlbiA8
bGl6aGVuLnlvdUBpbnRlbC5jb20+Ow0KPiBlcmljLmR1bWF6ZXRAZ21haWwuY29tOyBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+IGNncm91cHNAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2st
PnNrX2ZvcndhcmRfYWxsb2MgYXMgYSBwcm9wZXINCj4gc2l6ZQ0KPiANCj4gT24gVHVlLCBNYXkg
OSwgMjAyMyBhdCAxMTowNOKAr0FNIENoZW4sIFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT4g
d3JvdGU6DQo+ID4NCj4gPiA+Pg0KPiA+ID4+IFJ1biBtZW1jYWNoZWQgd2l0aCBtZW10aWVyX2Jl
bmNoYW1yayB0byB2ZXJpZnkgdGhlIG9wdGltaXphdGlvbg0KPiA+ID4+IGZpeC4gOCBzZXJ2ZXIt
Y2xpZW50IHBhaXJzIGFyZSBjcmVhdGVkIHdpdGggYnJpZGdlIG5ldHdvcmsgb24NCj4gPiA+PiBs
b2NhbGhvc3QsIHNlcnZlciBhbmQgY2xpZW50IG9mIHRoZSBzYW1lIHBhaXIgc2hhcmUgMjggbG9n
aWNhbCBDUFVzLg0KPiA+ID4+DQo+ID4gPiA+UmVzdWx0cyAoQXZlcmFnZSBmb3IgNSBydW4pDQo+
ID4gPiA+UlBTICh3aXRoL3dpdGhvdXQgcGF0Y2gpICAgICArMi4wN3gNCj4gPiA+ID4NCj4gPg0K
PiA+ID5EbyB5b3UgaGF2ZSByZWdyZXNzaW9uIGRhdGEgZnJvbSBhbnkgcHJvZHVjdGlvbiB3b3Jr
bG9hZD8gUGxlYXNlIGtlZXANCj4gaW4gbWluZCB0aGF0IG1hbnkgdGltZXMgd2UgKE1NIHN1YnN5
c3RlbSkgYWNjZXB0cyB0aGUgcmVncmVzc2lvbnMgb2YNCj4gbWljcm9iZW5jaG1hcmtzIG92ZXIg
Y29tcGxpY2F0ZWQgb3B0aW1pemF0aW9ucy4gU28sIGlmIHRoZXJlIGlzIGEgcmVhbA0KPiBwcm9k
dWN0aW9uIHJlZ3Jlc3Npb24sIHBsZWFzZSBiZSB2ZXJ5IGV4cGxpY2l0IGFib3V0IGl0Lg0KPiA+
DQo+ID4gVGhvdWdoIG1lbWNhY2hlZCBpcyBhY3R1YWxseSB1c2VkIGJ5IHBlb3BsZSBpbiBwcm9k
dWN0aW9uLiBTbyB0aGlzIGlzbid0DQo+IGFuIHVucmVhbGlzdGljIHNjZW5hcmlvLg0KPiA+DQo+
IA0KPiBZZXMsIG1lbWNhY2hlZCBpcyB1c2VkIGluIHByb2R1Y3Rpb24gYnV0IEkgYW0gbm90IHN1
cmUgYW55b25lIHJ1bnMgOCBwYWlycw0KPiBvZiBzZXJ2ZXIgYW5kIGNsaWVudCBvbiB0aGUgc2Ft
ZSBtYWNoaW5lIGZvciBwcm9kdWN0aW9uIHdvcmtsb2FkLiBBbnl3YXlzLA0KPiB3ZSBjYW4gZGlz
Y3VzcywgaWYgbmVlZGVkLCBhYm91dCB0aGUgcHJhY3RpY2FsaXR5IG9mIHRoZSBiZW5jaG1hcmsg
YWZ0ZXIgd2UNCj4gaGF2ZSBzb21lIGltcGFjdGZ1bCBtZW1jZyBvcHRpbWl6YXRpb25zLg0KDQpU
aGUgdGVzdCBpcyBydW4gb24gcGxhdGZvcm0gd2l0aCAyMjQgQ1BVcyAoSFQgZW5hYmxlZCkuIEl0
J3Mgbm90IGEgbXVzdCB0byBydW4NCjggcGFpcnMsIHRoZSBtZW1jZyBjaGFyZ2UgaG90IHBhdGhz
IGNhbiBiZSBvYnNlcnZlZCBpZiB3ZSBydW4gb25seSBvbmUgcGFpcg0KYnV0IHdpdGggbW9yZSBD
UFVzLiBMZXZlcmFnZSBhbGwgQ1BVIHJlc291cmNlcyBvbiBUQ1AgY29ubmVjdGlvbiB0byBzdHJl
c3MNCmNvbnRlbnRpb25zLg0KDQo+IA0KPiA+IFRpbQ0K
