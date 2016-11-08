From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Tue, 8 Nov 2016 08:12:55 +0000
Message-ID: <HE1PR0501MB2812298C05431B08B0F408EEB1A60@HE1PR0501MB2812.eurprd05.prod.outlook.com>
References: <20161018215134.GB2761@htj.duckdns.org>
 <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org>
 <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org>
 <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org>
 <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu>
 <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
 <20161103180006.GL3617@leon.nu>
 <AM4PR0501MB2802030EE9E359133E04439CB1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg@mail.gmail.com>
 <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5UyZPh9wduPZGRg2P09n2Og8oODqb+QW=7ryAPqJDa6Vw@mail.gmail.com>
 <AM4PR0501MB28025BE002CBA9D04675A5A5B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
 <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FaEvWguI+Kjn+5Kiz0wU0T9cHCVsRCe2FirHEBxu9/8=;
 b=Mctt5dCFXueNywNMx9oUiUBYsd7waYmOc8FygeOjf+gm37H3oK/4RgTNmpW4j88povI1TnK1Y0U5AOF9qoNG5wFoPtM3EJG/XilgbtGJn8Bu/5LR23DsDOfPXwlEkqzD0x0hU64EMo+8kiGoj3SSiZ5MhG40RWryAZjp2hGYD7I=
In-Reply-To: <CAG53R5WdauHpML66g-O6zj+j_DUYWJMPjmL1xDaSxwDmPPYm2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

PiBGcm9tOiBQYXJhdiBQYW5kaXQgW21haWx0bzpwYW5kaXQucGFyYXZAZ21haWwuY29tXQ0KDQo+
ID4NCj4gPiBIbW0uLg0KPiA+IEkgZ3Vlc3MgdGhhdCB5b3UgYXJlIHJpZ2h0Lg0KPiA+DQo+ID4g
U28gd2UgY2FuIGFkZCBhbm90aGVyIGNvdW50IGZvciAiSENBIGhhbmRsZXMiLA0KPiBJIHByZWZl
ciB0aGlzLiBUaGlzIGtlZXBzIGl0IHZlbmRvciBhZ25vc3RpYyBhbmQgY2xlYW4gaWYgd2UgZG9u
J3QgZ28gcGVyY2VudGFnZQ0KPiByb3V0ZS4NCg0KT0s7IGxldCdzIGRvIGl0Lg0KDQo+IFdvdWxk
IGluZGlyZWN0aW9uIHRhYmxlIGFsc28gZmFsbCBpbiB0aGlzIGNhdGVnb3J5Pw0KPiANCg0KTm8u
IEl0J3MganVzdCBhbm90aGVyIEhDQSByZXNvdXJjZS4uLg0KDQo+ID4gb3IgYWx0ZXJuYXRpdmVs
eSwgZWFjaCBwcm92aWRlciB3aWxsIHJlc3RyaWN0IHRoZSBudW1iZXIgb2YgaGFuZGxlcw0KPiA+
IHBlciBkZXZpY2UgdG8gYSByZWFzb25hYmxlIHNtYWxsIG51bWJlciAod2hpY2ggd29uJ3QgYmUg
dHJlYXRlZCBhcyBvbmUgb2YgdGhlDQo+ICJIQ0EgcmVzb3VyY2VzIikuDQo+IFRoaXMgd291bGQg
cmVxdWlyZSB2ZW5kb3IgZHJpdmVycyB0byBnZXQgdGhlIHVuZGVyc3RhbmRpbmcgb2YgY2dyb3Vw
IG9iamVjdA0KPiBhbmQgcGlkIGFuZCB0aGF0IGJyZWFrcyB0aGUgbW9kdWxhciBhcHByb2FjaC4g
SSBsaWtlIHRvIGF2b2lkIHRoaXMuDQo+IA0KPiA+IFR5cGljYWxseSwgYSBwcm9jZXNzIHNob3Vs
ZG4ndCBuZWVkIHRvIG9wZW4gbW9yZSB0aGFuIGEgc2luZ2xlIGhhbmRsZS4uLg0KPiBSaWdodC4g
d2VsbCBiZWhhdmVkIGFwcGxpY2F0aW9uIHdvbid0IGRvIG11bHRpcGxlIGhhbmRsZXMuDQo=
