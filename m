From: "Huang, Kai" <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 03/18] x86/sgx: Add sgx_epc_lru_lists to encapsulate
 LRU lists
Date: Thu, 14 Sep 2023 10:31:30 +0000
Message-ID: <851f9b3043732c17cd8f86a77ccee0b7c6caa22f.camel@intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
         <20230913040635.28815-4-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694687586; x=1726223586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2Owvua4yneqVHPmYiEmZQcd+wgUKZQ+AJl+tMK9s4wY=;
  b=W3c6CtIlNLlkb4K9Ke+E4b20+HnH0R3l1IfyAqS3SWKys3WFieS/MXcM
   P8kC1VgrNC7QT+jzWfsAhMs44c+yAquwkxc2w6aI9eS0OG9bPS+Misewh
   qWx08Z1HwDEC9LttP4wihMyLedWlTlovxjHz4UIzu0c5yibiJzOgPJ7s1
   Q8Az0xG848rokpMsq0sOxm1k1AT1HREv8HbDJu6z14lYB2yAHrLRoqx7f
   7FKNP79Z6cXr0Aw4FXv8sNY3LHDbHKXyx6iU+EOMtafP4XMIGHP7AczT3
   kw7WfqRQoBJdhtuijasVPv4HTzxUFGCmdEM7/fFFBNYsJGMS0+f22Ld0T
   w==;
In-Reply-To: <20230913040635.28815-4-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
Content-ID: <C14CE13B6833DC4AB8BF7D824DC048CD-Hry67jCOGbCcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Mehta, Sohil" <sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Li, Zhiquan1" <zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Christopherson,, Sean" <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Zhang, Bo" <zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

U29tZSBub24tdGVjaG5pY2FsIHN0YWZmOg0KDQpPbiBUdWUsIDIwMjMtMDktMTIgYXQgMjE6MDYg
LTA3MDAsIEhhaXRhbyBIdWFuZyB3cm90ZToNCj4gRnJvbTogS3Jpc3RlbiBDYXJsc29uIEFjY2Fy
ZGkgPGtyaXN0ZW5AbGludXguaW50ZWwuY29tPg0KDQpUaGUgcGF0Y2ggd2FzIGZyb20gS3Jpc3Rl
biwgYnV0IC4uLg0KDQo+IA0KPiBJbnRyb2R1Y2UgYSBkYXRhIHN0cnVjdHVyZSB0byB3cmFwIHRo
ZSBleGlzdGluZyByZWNsYWltYWJsZSBsaXN0IGFuZCBpdHMNCj4gc3BpbmxvY2suIEVhY2ggY2dy
b3VwIGxhdGVyIHdpbGwgaGF2ZSBvbmUgaW5zdGFuY2Ugb2YgdGhpcyBzdHJ1Y3R1cmUgdG8NCj4g
dHJhY2sgRVBDIHBhZ2VzIGFsbG9jYXRlZCBmb3IgcHJvY2Vzc2VzIGFzc29jaWF0ZWQgd2l0aCB0
aGUgc2FtZSBjZ3JvdXAuDQo+IEp1c3QgbGlrZSB0aGUgZ2xvYmFsIFNHWCByZWNsYWltZXIgKGtz
Z3hkKSwgYW4gRVBDIGNncm91cCByZWNsYWltcyBwYWdlcw0KPiBmcm9tIHRoZSByZWNsYWltYWJs
ZSBsaXN0IGluIHRoaXMgc3RydWN0dXJlIHdoZW4gaXRzIHVzYWdlIHJlYWNoZXMgbmVhcg0KPiBp
dHMgbGltaXQuDQo+IA0KPiBDdXJyZW50bHksIGtzZ3hkIGRvZXMgbm90IHRyYWNrIHRoZSBWQSwg
U0VDUyBwYWdlcy4gVGhleSBhcmUgY29uc2lkZXJlZA0KPiBhcyAndW5yZWNsYWltYWJsZScgcGFn
ZXMgdGhhdCBhcmUgb25seSBkZWFsbG9jYXRlZCB3aGVuIHRoZWlyIHJlc3BlY3RpdmUNCj4gb3du
aW5nIGVuY2xhdmVzIGFyZSBkZXN0cm95ZWQgYW5kIGFsbCBhc3NvY2lhdGVkIHJlc291cmNlcyBy
ZWxlYXNlZC4NCj4gDQo+IFdoZW4gYW4gRVBDIGNncm91cCBjYW4gbm90IHJlY2xhaW0gYW55IG1v
cmUgcmVjbGFpbWFibGUgRVBDIHBhZ2VzIHRvDQo+IHJlZHVjZSBpdHMgdXNhZ2UgYmVsb3cgaXRz
IGxpbWl0LCB0aGUgY2dyb3VwIG11c3QgYWxzbyByZWNsYWltIHRob3NlDQo+IHVucmVjbGFpbWFi
bGVzIGJ5IGtpbGxpbmcgdGhlaXIgb3duaW5nIGVuY2xhdmVzLiBUaGUgVkEgYW5kIFNFQ1MgcGFn
ZXMNCj4gbGF0ZXIgYXJlIGFsc28gdHJhY2tlZCBpbiBhbiAndW5yZWNsYWltYWJsZScgbGlzdCBh
ZGRlZCB0byB0aGlzIHN0cnVjdHVyZQ0KPiB0byBzdXBwb3J0IHRoaXMgT09NIGtpbGxpbmcgb2Yg
ZW5jbGF2ZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
LmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBLcmlzdGVuIENh
cmxzb24gQWNjYXJkaSA8a3Jpc3RlbkBsaW51eC5pbnRlbC5jb20+DQoNCi4uLiBpdCB3YXMgZmly
c3RseSBzaWduZWQgYnkgU2VhbiBhbmQgdGhlbiBLcmlzdGVuLCB3aGljaCBkb2Vzbid0IHNvdW5k
IHJpZ2h0Lg0KDQpJZiB0aGUgcGF0Y2ggd2FzIGZyb20gS3Jpc3RlbiwgdGhlbiBlaXRoZXIgU2Vh
bidzIFNvQiBzaG91bGQgY29tZSBhZnRlcg0KS3Jpc3RlbidzICh3aGljaCBtZWFucyBTZWFuIHRv
b2sgS3Jpc3RlbidzIHBhdGNoIGFuZCBzaWduZWQgaXQpLCBvciB5b3UgbmVlZCB0bw0KaGF2ZSBh
IENvLWRldmVsb3BlZC1ieSB0YWcgZm9yIFNlYW4gcmlnaHQgYmVmb3JlIGhpcyBTb0IgKHdoaWNo
IGluZGljYXRlcyBTZWFuDQpwYXJ0aWNpcGF0ZWQgaW4gdGhlIGRldmVsb3BtZW50IG9mIHRoZSBw
YXRjaCBidXQgbGlrZWx5IGhlIHdhc24ndCB0aGUgbWFpbg0KZGV2ZWxvcGVyKS4NCg0KQnV0IEkg
X2d1ZXNzXyB0aGUgcGF0Y2ggd2FzIGp1c3QgZnJvbSBTZWFuLg0KDQo+IFNpZ25lZC1vZmYtYnk6
IEhhaXRhbyBIdWFuZyA8aGFpdGFvLmh1YW5nQGxpbnV4LmludGVsLmNvbT4NCj4gQ2M6IFNlYW4g
Q2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpZb3UgZG9uJ3QgbmVlZCAnQ2M6
JyBTZWFuIGlmIHRoZSBwYXRjaCBoYXMgU2VhbidzIFNvQi4NCg0KTW9yZSBpbmZvcm1hdGlvbiBw
bGVhc2UgcmVmZXIgdG8gIldoZW4gdG8gdXNlIEFja2VkLWJ5OiwgQ2M6LCBhbmQgQ28tZGV2ZWxv
cGVkLQ0KYnkiIHNlY3Rpb24gaGVyZTrCoA0KDQpodHRwczovL2RvY3Mua2VybmVsLm9yZy9wcm9j
ZXNzL3N1Ym1pdHRpbmctcGF0Y2hlcy5odG1sDQoNCkFsc28gYW4gZXhwbGFuYXRpb24gb2Ygd2hl
biB0byB1c2UgJ0NjOicgZnJvbSBTZWFuIChpZ25vcmUgdGVjaG5pY2FsIHN0YWZmKToNCg0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9aT1p0ZU94SnZxOXY2MDlHQGdvb2dsZS5jb20vDQoN
CihBbmQgcGxlYXNlIGNoZWNrIG90aGVyIHBhdGNoZXMgdG9vLikNCg0KDQo=
