From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/4] drm/amdkfd: Check against device cgroup
Date: Tue, 28 May 2019 12:02:39 -0700
Message-ID: <20190528190239.GM374014@devbig004.ftw2.facebook.com>
References: <20190517161435.14121-1-Harish.Kasiviswanathan@amd.com>
 <20190517161435.14121-5-Harish.Kasiviswanathan@amd.com>
 <e547c0a1-e153-c3a6-79bc-67f59f364c3e@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e547c0a1-e153-c3a6-79bc-67f59f364c3e-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
To: "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kasiviswanathan,
 Harish" <Harish.Kasiviswanathan-5C7GfCeVMHo@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

SGVsbG8sCgpPbiBGcmksIE1heSAxNywgMjAxOSBhdCAwODoxMjoxN1BNICswMDAwLCBLdWVobGlu
ZywgRmVsaXggd3JvdGU6Cj4gUGF0Y2hlcyAxLDIsNCB3aWxsIGJlIHN1Ym1pdHRlZCB0aHJvdWdo
IGFtZC1zdGFnaW5nLWRybS1uZXh0LiBQYXRjaCAzIAo+IGdvZXMgdGhyb3VnaCB0aGUgY2dyb3Vw
IHRyZWUuIFBhdGNoIDQgZGVwZW5kcyBvbiBwYXRjaCAzLiBTbyBzdWJtaXR0aW5nIAo+IHBhdGNo
IDQgd2lsbCBuZWVkIHRvIHdhaXQgdW50aWwgd2UgcmViYXNlIGFtZC1zdGFnaW5nLWRybS1uZXh0
IG9uIGEgbmV3IAo+IGVub3VnaCBrZXJuZWwgcmVsZWFzZSB0aGF0IGluY2x1ZGVzIHBhdGNoIDMu
Cj4gCj4gUGF0Y2ggMSBhbmQgMiBjb3VsZCBiZSBzdWJtaXR0ZWQgbm93IG9yIHdhaXQgZm9yIHBh
dGNoIDMgYXMgd2VsbCBzbyB3ZSAKPiBzdWJtaXQgYWxsIG91ciBjZ3JvdXAgc3R1ZmYgaW4gYW1k
Z3B1IGFuZCBLRkQgdG9nZXRoZXIuIEl0IHByb2JhYmx5IAo+IG1ha2VzIG1vc3Qgc2Vuc2UgdG8g
d2FpdCBzaW5jZSB1bnVzZWQgY29kZSB0ZW5kcyB0byByb3QuCj4gCj4gUGF0Y2hlcyAxLDIsNCBh
cmUgYWxyZWFkeSByZXZpZXdlZCBieSBtZS4gRmVlbCBmcmVlIHRvIGFkZCBteSBBY2tlZC1ieSAK
PiB0byBwYXRjaCAzLgoKUGxlYXNlIGZlZWwgZnJlZSB0byBhZGQgbXkgYWNrZWQtYnkgYW5kIHRh
a2UgcGF0Y2ggMyB3aXRoIHRoZSByZXN0IG9mCnRoZSBwYXRjaHNldC4KClRoYW5rcy4KCi0tIAp0
ZWp1bgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQt
Z2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xp
c3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
