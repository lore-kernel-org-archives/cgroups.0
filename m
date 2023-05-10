From: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Wed, 10 May 2023 06:54:28 +0000
Message-ID: <CH3PR11MB73456988A38EB575F99699CCFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683701673; x=1715237673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UqTC0IrX1fsiWtY7tkZ0TSpLaaxOidh/2SwfbTrQEf8=;
  b=VjVTPk2wwUykefQsuZZFR0xG5FM5OuG3QSBv6ulyxlw1y2MjUSRc/m0N
   7CCHPEWpkSmi4NLb6hnauhcNNyAe/mXV7j0W/GrTN0P8S7C6dXcNc7SQa
   5LbH5wDP/OLGjEyESxFn6Ydx06roaBFp28bcvKz8IluqvD+58UJIk/GS4
   dbvEjnDlprXSo9SwYhSH7764G9L8Zs+SHp+LH0kFm1osVcxmJH9Sek1xP
   4CnMLK+vCrTIR3vWH3Gq7zHW63Th0BYs/Ppqgl0CaZakHZ/JjhyWQCxxP
   y4Po8Pgf9lqo72RhkccBUsKk+RikoIHvkqtnHsGpfYNehgN/PeKQhLcuk
   Q==;
In-Reply-To: <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

SGkgU2hha2VlbCwNCg0KVGhhbmtzIGZvciB0YWtpbmcgeW91ciB0aW1lIHRvIGhlbHAgcmV2aWV3
IQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNoYWtlZWwgQnV0dCA8
c2hha2VlbGJAZ29vZ2xlLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXkgMTAsIDIwMjMgMTI6
MTAgQU0NCj4gVG86IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IExpbnV4IE1N
IDxsaW51eC0NCj4gbW1Aa3ZhY2sub3JnPjsgQ2dyb3VwcyA8Y2dyb3Vwc0B2Z2VyLmtlcm5lbC5v
cmc+DQo+IENjOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47IFBhb2xvIEFi
ZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2Vy
bmVsLm9yZzsNCj4gQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29t
PjsgU3Jpbml2YXMsIFN1cmVzaA0KPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4s
IFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwNCj4gTGl6aGVuIDxsaXpoZW4ueW91
QGludGVsLmNvbT47IGVyaWMuZHVtYXpldEBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+
c2tfZm9yd2FyZF9hbGxvYyBhcyBhIHByb3Blcg0KPiBzaXplDQo+IA0KPiArbGludXgtbW0gJiBj
Z3JvdXANCj4gDQo+IFRocmVhZDogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjMwNTA4
MDIwODAxLjEwNzAyLTEtDQo+IGNhdGh5LnpoYW5nQGludGVsLmNvbS8NCj4gDQo+IE9uIFR1ZSwg
TWF5IDksIDIwMjMgYXQgODo0M+KAr0FNIEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNv
bT4NCj4gd3JvdGU6DQo+ID4NCj4gWy4uLl0NCj4gPiBTb21lIG1tIGV4cGVydHMgc2hvdWxkIGNo
aW1lIGluLCB0aGlzIGlzIG5vdCBhIG5ldHdvcmtpbmcgaXNzdWUuDQo+IA0KPiBNb3N0IG9mIHRo
ZSBNTSBmb2xrcyBhcmUgYnVzeSBpbiBMU0ZNTSB0aGlzIHdlZWsuIEkgd2lsbCB0YWtlIGEgbG9v
ayBhdCB0aGlzDQo+IHNvb24uDQo=
