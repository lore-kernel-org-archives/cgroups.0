From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v4 02/16] cgroup: Introduce cgroup for drm subsystem
Date: Fri, 29 Nov 2019 01:00:36 -0500
Message-ID: <CAOWid-ewvs-c-z_WW+Cx=Jaf0p8ZAwkWCkq2E8Xkj+2HvfNjaA@mail.gmail.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-3-Kenny.Ho@amd.com>
 <20191001143106.GA4749@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20191001143106.GA4749-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
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
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling,
 Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

T24gVHVlLCBPY3QgMSwgMjAxOSBhdCAxMDozMSBBTSBNaWNoYWwgS291dG7DvSA8bWtvdXRueUBz
dXNlLmNvbT4gd3JvdGU6Cj4gT24gVGh1LCBBdWcgMjksIDIwMTkgYXQgMDI6MDU6MTlBTSAtMDQw
MCwgS2VubnkgSG8gPEtlbm55LkhvQGFtZC5jb20+IHdyb3RlOgo+ID4gK3N0cnVjdCBjZ3JvdXBf
c3Vic3lzIGRybV9jZ3JwX3N1YnN5cyA9IHsKPiA+ICsgICAgIC5jc3NfYWxsb2MgICAgICA9IGRy
bWNnX2Nzc19hbGxvYywKPiA+ICsgICAgIC5jc3NfZnJlZSAgICAgICA9IGRybWNnX2Nzc19mcmVl
LAo+ID4gKyAgICAgLmVhcmx5X2luaXQgICAgID0gZmFsc2UsCj4gPiArICAgICAubGVnYWN5X2Nm
dHlwZXMgPSBmaWxlcywKPiBEbyB5b3UgcmVhbGx5IHdhbnQgdG8gZXhwb3NlIHRoZSBEUk0gY29u
dHJvbGxlciBvbiB2MSBoaWVyYXJjaGllcyAod2hlcmUKPiB0aHJlYWRzIG9mIG9uZSBwcm9jZXNz
IGNhbiBiZSBpbiBkaWZmZXJlbnQgY2dyb3Vwcywgb3IgY2hpbGRyZW4gY2dyb3Vwcwo+IGNvbXBl
dGUgd2l0aCB0aGVpciBwYXJlbnRzKT8KCihTb3JyeSBmb3IgdGhlIGRlbGF5LCBJIGhhdmUgYmVl
biBkaXN0cmFjdGVkIGJ5IHNvbWV0aGluZyBlbHNlLikKWWVzLCBJIGFtIGhvcGluZyB0byBtYWtl
IHRoZSBmdW5jdGlvbmFsaXR5IGFzIHdpZGVseSBhdmFpbGFibGUgYXMKcG9zc2libGUgc2luY2Ug
dGhlIGVjb3N5c3RlbSBpcyBzdGlsbCB0cmFuc2l0aW9uaW5nIHRvIHYyLiAgRG8geW91IHNlZQpp
bmhlcmVudCBwcm9ibGVtIHdpdGggdGhpcyBhcHByb2FjaD8KClJlZ2FyZHMsCktlbm55CgoKPgo+
ID4gKyAgICAgLmRmbF9jZnR5cGVzICAgID0gZmlsZXMsCj4gPiArfTsKPgo+IEp1c3QgYXNraW5n
LAo+IE1pY2hhbApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwphbWQtZ2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRw
czovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
