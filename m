From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC v4 02/16] cgroup: Introduce cgroup for drm subsystem
Date: Mon, 2 Dec 2019 11:14:36 -0800
Message-ID: <20191202191436.GG16681@devbig004.ftw2.facebook.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-3-Kenny.Ho@amd.com>
 <20191001143106.GA4749@blackbody.suse.cz>
 <CAOWid-ewvs-c-z_WW+Cx=Jaf0p8ZAwkWCkq2E8Xkj+2HvfNjaA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOWid-ewvs-c-z_WW+Cx=Jaf0p8ZAwkWCkq2E8Xkj+2HvfNjaA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling,
 Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

T24gRnJpLCBOb3YgMjksIDIwMTkgYXQgMDE6MDA6MzZBTSAtMDUwMCwgS2VubnkgSG8gd3JvdGU6
Cj4gT24gVHVlLCBPY3QgMSwgMjAxOSBhdCAxMDozMSBBTSBNaWNoYWwgS291dG7DvSA8bWtvdXRu
eUBzdXNlLmNvbT4gd3JvdGU6Cj4gPiBPbiBUaHUsIEF1ZyAyOSwgMjAxOSBhdCAwMjowNToxOUFN
IC0wNDAwLCBLZW5ueSBIbyA8S2VubnkuSG9AYW1kLmNvbT4gd3JvdGU6Cj4gPiA+ICtzdHJ1Y3Qg
Y2dyb3VwX3N1YnN5cyBkcm1fY2dycF9zdWJzeXMgPSB7Cj4gPiA+ICsgICAgIC5jc3NfYWxsb2Mg
ICAgICA9IGRybWNnX2Nzc19hbGxvYywKPiA+ID4gKyAgICAgLmNzc19mcmVlICAgICAgID0gZHJt
Y2dfY3NzX2ZyZWUsCj4gPiA+ICsgICAgIC5lYXJseV9pbml0ICAgICA9IGZhbHNlLAo+ID4gPiAr
ICAgICAubGVnYWN5X2NmdHlwZXMgPSBmaWxlcywKPiA+IERvIHlvdSByZWFsbHkgd2FudCB0byBl
eHBvc2UgdGhlIERSTSBjb250cm9sbGVyIG9uIHYxIGhpZXJhcmNoaWVzICh3aGVyZQo+ID4gdGhy
ZWFkcyBvZiBvbmUgcHJvY2VzcyBjYW4gYmUgaW4gZGlmZmVyZW50IGNncm91cHMsIG9yIGNoaWxk
cmVuIGNncm91cHMKPiA+IGNvbXBldGUgd2l0aCB0aGVpciBwYXJlbnRzKT8KPiAKPiAoU29ycnkg
Zm9yIHRoZSBkZWxheSwgSSBoYXZlIGJlZW4gZGlzdHJhY3RlZCBieSBzb21ldGhpbmcgZWxzZS4p
Cj4gWWVzLCBJIGFtIGhvcGluZyB0byBtYWtlIHRoZSBmdW5jdGlvbmFsaXR5IGFzIHdpZGVseSBh
dmFpbGFibGUgYXMKPiBwb3NzaWJsZSBzaW5jZSB0aGUgZWNvc3lzdGVtIGlzIHN0aWxsIHRyYW5z
aXRpb25pbmcgdG8gdjIuICBEbyB5b3Ugc2VlCj4gaW5oZXJlbnQgcHJvYmxlbSB3aXRoIHRoaXMg
YXBwcm9hY2g/CgpJbnRlZ3JhdGluZyB3aXRoIG1lbWNnIGNvdWxkIGJlIG1vcmUgY2hhbGxlbmdp
bmcgb24gY2dyb3VwMS4gIFRoYXQncwpvbmUgb2YgdGhlIHJlYXNvbnMgd2h5IGUuZy4gY2dyb3Vw
LWF3YXJlIHBhZ2VjYWNoZSB3cml0ZWJhY2sgaXMgb25seQpvbiBjZ3JvdXAyLgoKLS0gCnRlanVu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZngg
bWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
