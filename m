From: Rik van Riel <riel-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix blocking rstat function called from
 atomic cgroup1 thresholding code
Date: Mon, 26 Jul 2021 15:16:06 +0000
Message-ID: <2b0b08f9385b25fb7750dbe453516b0c8bb27604.camel@fb.com>
References: <20210726150019.251820-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pLzogDWx/JHJfcJWQc3D3qgj3LortFeGDH+JW0b+vyQ=;
 b=SaoEpPyp1YbLnHbSvKUw4QIR8tWVcg6gN+RNzgzwdEIEiLohgoLbE1OrR/avRVyvGbkA
 e/nrJYww/yi4rNbHE2dl0vP87HLb3JKnatU8GE4Bz8GfHBDvS88ojfVbMZ9s46ymSf32
 6WCfLPWYgNmh0H889kGJP7atIAAl5dzm4FM= 
In-Reply-To: <20210726150019.251820-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
Content-ID: <8FE66FAAC22F194485956A13D426A99F-JGF9Izt3QrScE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Kernel Team <Kernel-team-b10kYP2dOMg@public.gmane.org>, "dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

T24gTW9uLCAyMDIxLTA3LTI2IGF0IDExOjAwIC0wNDAwLCBKb2hhbm5lcyBXZWluZXIgd3JvdGU6
DQo+IA0KPiBfX21lbV9jZ3JvdXBfdGhyZXNob2xkKCkgaW5kZWVkIGhvbGRzIHRoZSByY3UgbG9j
ay4gSW4gYWRkaXRpb24sIHRoZQ0KPiB0aHJlc2hvbGRpbmcgY29kZSBpcyBpbnZva2VkIGR1cmlu
ZyBzdGF0IGNoYW5nZXMsIGFuZCB0aG9zZSBjb250ZXh0cw0KPiBoYXZlIGlycXMgZGlzYWJsZWQg
YXMgd2VsbC4gSWYgdGhlIGxvY2sgYnJlYWtpbmcgb2NjdXJzIGluc2lkZSB0aGUNCj4gZmx1c2gg
ZnVuY3Rpb24sIGl0IHdpbGwgcmVzdWx0IGluIGEgc2xlZXAgZnJvbSBhbiBhdG9taWMgY29udGV4
dC4NCj4gDQo+IFVzZSB0aGUgaXJzYWZlIGZsdXNoaW5nIHZhcmlhbnQgaW4gbWVtX2Nncm91cF91
c2FnZSgpIHRvIGZpeCB0aGlzDQoNCldoaWxlIHRoaXMgZml4IGlzIG5lY2Vzc2FyeSwgaW4gdGhl
IGxvbmcgdGVybSBJIHRoaW5rIHdlIG1heQ0Kd2FudCBzb21lIHNvcnQgb2YgcmVkZXNpZ24gaGVy
ZSwgdG8gbWFrZSBzdXJlIHRoZSBpcnEgc2FmZQ0KdmVyc2lvbiBkb2VzIG5vdCBzcGluIGxvbmcg
dGltZXMgdHJ5aW5nIHRvIGdldCB0aGUgc3RhdGlzdGljcw0Kb2ZmIHNvbWUgb3RoZXIgQ1BVLg0K
DQpJIGhhdmUgc2VlbiBhIG51bWJlciBvZiBzb2Z0IChJSVJDKSBsb2NrdXBzIGRlZXAgaW5zaWRl
IHRoZQ0KYm93ZWxzIG9mIGNncm91cF9yc3RhdF9mbHVzaF9pcnFzYWZlLCB3aXRoIHRoZSBmdW5j
dGlvbiB0YWtpbmcNCm11bHRpcGxlIHNlY29uZHMgdG8gY29tcGxldGUuDQoNClJldmlld2VkLWJ5
OiBSaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+DQo=
