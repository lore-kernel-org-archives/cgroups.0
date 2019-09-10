From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC v4 00/16] new cgroup controller for gpu/drm subsystem
Date: Tue, 10 Sep 2019 09:03:29 -0700
Message-ID: <20190910160329.GR2263813@devbig004.ftw2.facebook.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190831042857.GD2263813@devbig004.ftw2.facebook.com>
 <20190903075550.GJ2112@phenom.ffwll.local>
 <20190903185013.GI2263813@devbig004.ftw2.facebook.com>
 <CAKMK7uE5Bj-3cJH895iqnLpwUV+GBDM1Y=n4Z4A3xervMdJKXg@mail.gmail.com>
 <20190906152320.GM2263813@devbig004.ftw2.facebook.com>
 <CAKMK7uEXP7XLFB2aFU6+E0TH_DepFRkfCoKoHwkXtjZRDyhHig@mail.gmail.com>
 <20190906154539.GP2263813@devbig004.ftw2.facebook.com>
 <20190910115448.GT2063@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190910115448.GT2063-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

SGVsbG8sIE1pY2hhbC4KCk9uIFR1ZSwgU2VwIDEwLCAyMDE5IGF0IDAxOjU0OjQ4UE0gKzAyMDAs
IE1pY2hhbCBIb2NrbyB3cm90ZToKPiA+IFNvLCB3aGlsZSBpdCdkIGdyZWF0IHRvIGhhdmUgc2hy
aW5rZXJzIGluIHRoZSBsb25nZXIgdGVybSwgaXQncyBub3QgYQo+ID4gc3RyaWN0IHJlcXVpcmVt
ZW50IHRvIGJlIGFjY291bnRlZCBpbiBtZW1jZy4gIEl0IGFscmVhZHkgYWNjb3VudHMgYQo+ID4g
bG90IG9mIG1lbW9yeSB3aGljaCBpc24ndCByZWNsYWltYWJsZSAoYSBsb3Qgb2Ygc2xhYnMgYW5k
IHNvY2tldAo+ID4gYnVmZmVyKS4KPiAKPiBZZWFoLCBoYXZpbmcgYSBzaHJpbmtlciBpcyBwcmVm
ZXJyZWQgYnV0IHRoZSBtZW1vcnkgc2hvdWxkIGJldHRlciBiZQo+IHJlY2xhaW1hYmxlIGluIHNv
bWUgZm9ybS4gSWYgbm90IGJ5IGFueSBvdGhlciBtZWFucyB0aGVuIGF0IGxlYXN0IGJvdW5kCj4g
dG8gYSB1c2VyIHByb2Nlc3MgY29udGV4dCBzbyB0aGF0IGl0IGdvZXMgYXdheSB3aXRoIGEgdGFz
ayBiZWluZyBraWxsZWQKPiBieSB0aGUgT09NIGtpbGxlci4gSWYgdGhhdCBpcyBub3QgdGhlIGNh
c2UgdGhlbiB3ZSBjYW5ub3QgcmVhbGx5IGNoYXJnZQo+IGl0IGJlY2F1c2UgdGhlbiB0aGUgbWVt
Y2cgY29udHJvbGxlciBpcyBvZiBubyB1c2UuIFdlIGNhbiB0b2xlcmF0ZSBpdCB0bwo+IHNvbWUg
ZGVncmVlIGlmIHRoZSBhbW91bnQgb2YgbWVtb3J5IGNoYXJnZWQgbGlrZSB0aGF0IGlzIG5lZ2xp
Z2libGUgdG8KPiB0aGUgb3ZlcmFsbCBzaXplLiBCdXQgZnJvbSB0aGUgZGlzY3Vzc2lvbiBpdCBz
ZWVtcyB0aGF0IHRoZXNlIGJ1ZmZlcnMKPiBhcmUgcmVhbGx5IGxhcmdlLgoKWWVhaCwgb29tIGtp
bGxzIHNob3VsZCBiZSBhYmxlIHRvIHJlZHVjZSB0aGUgdXNhZ2U7IGhvd2V2ZXIsIHBsZWFzZQpu
b3RlIHRoYXQgdG1wZnMsIGFtb25nIG90aGVyIHRoaW5ncywgY2FuIGFscmVhZHkgZXNjYXBlIHRo
aXMKcmVzdHJpY3Rpb24gYW5kIHdlIGNhbiBoYXZlIGNncm91cHMgd2hpY2ggYXJlIG92ZXIgbWF4
IGFuZCBlbXB0eS4KSXQncyBvYnZpb3VzbHkgbm90IGlkZWFsIGJ1dCB0aGUgc3lzdGVtIGRvZXNu
J3QgbWVsdCBkb3duIGZyb20gaXQKZWl0aGVyLgoKVGhhbmtzLgoKLS0gCnRlanVuCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBs
aXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0
b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
