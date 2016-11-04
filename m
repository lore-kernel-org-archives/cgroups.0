From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Fri, 4 Nov 2016 04:52:04 +0000
Message-ID: <AM4PR0501MB2802E87F709F41DDEC20B7C9B1A20@AM4PR0501MB2802.eurprd05.prod.outlook.com>
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
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dQLqNIpHLP7Cp/uiTDz0IqYXacZpkcggumEsBCPpFI8=;
 b=dYbVnqk3Bbn5JBPJa5HSc8JYSj2+4nKXakLkW9Gd8p+T3SqPKgcQo0ZHa7+trEHbx8CFVL4ScCzhRSpwUhRwTPuIitBVd1yRYSl0/GolPc9G2/zB/RaGu23bYrZ/hkE0a2MqDlNS0A7tFj2rdv7EYTMBFOOzDk9AMurK29JnroM=
In-Reply-To: <CAG53R5Vd58wEBKgAajp9VvJmB5sO2Umii0JE4XaLYKbfrJrxyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
content-type: text/plain
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

PiBGcm9tOiBQYXJhdiBQYW5kaXQgW21haWx0bzpwYW5kaXQucGFyYXZAZ21haWwuY29tXQ0KDQo+
ID4NCj4gPiBBIGdsb2JhbCBIQ0EgbWV0cmljIGlzIGluZGVlZCBpbiB0aGUgcmlnaHQgZGlyZWN0
aW9uLg0KPiA+IEhvd2V2ZXIsIHJldGhpbmtpbmcgdGhpcywgSSB0aGluayB0aGF0IHdlIHNob3Vs
ZCBzcGVjaWZ5IHRoZSBtZXRyaWMgaW4gdGVybXMgb2YNCj4gUkRNQSBvYmplY3RzIHJhdGhlciB0
aGFuIHBlcmNlbnRhZ2UuDQo+ID4gQmFzaWNhbGx5LCBhbnkgcmVzb3VyY2UgdGhhdCBjb25zdW1l
cyBhbiBJRFIgaXMgY2hhcmdlZC4NCj4gPg0KPiBJZiBtZXRyaWMgZGVmaW5pdGlvbiBpcyBiYXNl
ZCBvbiBSRE1BIG9iamVjdHMgKGNvdW50KSBhbmQgbm90IGJhc2VkIG9uDQo+IHBlcmNlbnRhZ2Us
IGhvdyB3b3VsZCB1c2VyIHNwZWNpZnkgdGhlIG1ldHJpYyB3aXRob3V0IHJlYWxseSBzcGVjaWZ5
aW5nIG9iamVjdA0KPiB0eXBlLg0KPiBDdXJyZW50IHBhdGNoIGRlZmluZXMgdGhlIG1ldHJpYyBh
cyBhYnNvbHV0ZSBudW1iZXJzIGFuZCBvYmplY3RzIGFzIHdlbGwuDQo+DQoNClRoYXQgaXMgdGhl
IHJlcXVlc3RlZCBjaGFuZ2UuIFRoZSBhYnNvbHV0ZSBudW1iZXIgd291bGQgYWNjb3VudCBmb3Ig
YW55IG9iamVjdCBhbGxvY2F0aW9uLiBXZSB3b24ndCBkaXN0aW5ndWlzaCBiZXR3ZWVuIHR5cGVz
Lg0KT25seSBhIHNpbmdsZSBjb3VudGVyIChwZXIgZGV2aWNlKS4NCiANCj4gQ29tbWVudCBmcm9t
IExlb24gYWJvdXQgaGlzIGRpc2N1c3Npb24gd2l0aCBNYXRhbiwgVGVqdW4sIENocmlzdG9waCBz
YXlzDQo+IG9wcG9zaXRlIG9mIHRoaXMgZm9yIHVzZXIgbGV2ZWwgY29uZmlndXJhdGlvbi4NCj4g
TWF5IGJlIEkgYW0gbWlzc2luZyBzb21ldGhpbmcuDQo+IA0KPiA+IFRoZSByZWFzb25zIGFyZToN
Cj4gPiAtIFNvbWUgSENBcyBjYW4gaGF2ZSBhIGh1Z2UgYW1vdW50IG9mIHJlc291cmNlcyAobWls
bGlvbnMgb2Ygb2JqZWN0cyksIG9mDQo+IHdoaWNoIGV2ZW4gYSBzbWFsbCBwZXJjZW50YWdlIG1h
eSBjb25zdW1lIGEgY29uc2lkZXJhYmxlIGFtb3VudCBvZiBrZXJuZWwNCj4gbWVtb3J5Lg0KPiA+
IC0gV2UgZm9sbG93IHRoZSBzYW1lIG5vdGlvbiBhcyBGRCBsaW1pdHMsIHdoaWNoIGFjY291bnRz
IGZvciBudW1lcm91cw0KPiA+IHJlc291cmNlIHR5cGVzIHRoYXQgY29uc3VtZSBmaWxlIG9iamVj
dHMgaW4gdGhlIGtlcm5lbCAoZmlsZXMsIHBpcGVzLA0KPiA+IHNvY2tldHMpDQo+ID4gLSBUaGUg
bmFtZXNwYWNlcyBmb3IgUkRNQSByZXNvdXJjZXMgYXJlIGxhcmdlICh1c3VhbGx5IDI0IGJpdHMp
LiBTbw0KPiA+IGV2ZW4gbGFyZ2UgcmVzb3VyY2UgY291bnRzIHdvbid0IGNvbWUgbm93aGVyZSBj
bG9zZSBpbiBkZXBsZXRpbmcgdGhlDQo+ID4gbmFtZXNwYWNlLiAoQ29tcGFyZSB0aGF0IHRvIHRo
ZSBtZXJlIDY0SyBzb2NrZXQgcG9ydCBzcGFjZS4uLikNCj4gPiAtIFRoZSBtZXRyaWMgbWVhc3Vy
ZXMgdGhlIGFjdHVhbCBhcHBsaWNhdGlvbiB1c2FnZSBvZiByZXNvdXJjZXMsIHJhdGhlciB0aGFu
DQo+IHByb3BvcnRpb25hbCB0byB0aGUgcmVzb3VyY2VzIG9mIGEgZ2l2ZW4gSENBIGFkYXB0ZXIu
DQo+ID4gLSBXZSBjYW4gY29udGludWUgdG8gdXNlIHRoZSBjZ3JvdXAgbWVjaGFuaXNtIGZvciBj
aGFyZ2luZyAoanVzdCBhcyBpbg0KPiA+IHRoZSBvcmlnaW5hbCBwcm9wb3NhbCkNCj4gPg0KPiA+
IEkgaGF2ZSBkaXNjdXNzZWQgdGhpcyBtYXR0ZXIgd2l0aCBEb3VnIGFuZCBNYXRhbiwgYW5kIGl0
IHNlZW1zIGxpa2UgdGhpcyBpcyB0aGUNCj4gcmlnaHQgZGlyZWN0aW9uLg0KPiA+IC0tTGlyYW4N
Cj4gPg0K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
