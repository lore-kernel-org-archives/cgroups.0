From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC v4 01/16] drm: Add drm_minor_for_each
Date: Fri, 6 Sep 2019 08:38:51 -0700
Message-ID: <20190906153851.GO2263813@devbig004.ftw2.facebook.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-2-Kenny.Ho@amd.com>
 <20190903075719.GK2112@phenom.ffwll.local>
 <CAOWid-dxxDhyxP2+0R0oKAk29rR-1TbMyhshR1+gbcpGJCAW6g@mail.gmail.com>
 <CAKMK7uEofjdVURu+meonh_YdV5eX8vfNALkW3A_+kLapCV8j+w@mail.gmail.com>
 <CAOWid-eUVztW4hNVpznnJRcwHcjCirGL2aS75p4OY8XoGuJqUg@mail.gmail.com>
 <20190904085434.GF2112@phenom.ffwll.local>
 <20190906152925.GN2263813@devbig004.ftw2.facebook.com>
 <CAKMK7uFQqAMB1DbiEy-o2bzr_F25My93imNcg1Qh9DHe=uWQug@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKMK7uFQqAMB1DbiEy-o2bzr_F25My93imNcg1Qh9DHe=uWQug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

SGVsbG8sIERhbmllbC4KCk9uIEZyaSwgU2VwIDA2LCAyMDE5IGF0IDA1OjM2OjAyUE0gKzAyMDAs
IERhbmllbCBWZXR0ZXIgd3JvdGU6Cj4gQmxvY2sgZGV2aWNlcyBhcmUgYSBncmVhdCBleGFtcGxl
IEkgdGhpbmsuIEhvdyBkbyB5b3UgaGFuZGxlIHRoZQo+IHBhcnRpdGlvbnMgb24gdGhhdD8gRm9y
IGRybSB3ZSBhbHNvIGhhdmUgYSBtYWluIG1pbm9yIGludGVyZmFjZSwgYW5kCgpjZ3JvdXAgSU8g
Y29udHJvbGxlcnMgb25seSBkaXN0cmlidXRlIGhhcmR3YXJlIElPIGNhcGFjaXR5IGFuZCBhcmUK
YmxpbmQgdG8gcGFydGl0aW9ucy4gIEFzIHRoZXJlJ3MgYWx3YXlzIHRoZSB3aG9sZSBkZXZpY2Ug
TUFKOk1JTiBmb3IKYmxvY2sgZGV2aWNlcywgd2Ugb25seSB1c2UgdGhhdC4KCj4gdGhlbiB0aGUg
cmVuZGVyLW9ubHkgaW50ZXJmYWNlIG9uIGRyaXZlcnMgdGhhdCBzdXBwb3J0IGl0LiBTbyBpZiBi
bGtjZwo+IGhhbmRsZXMgdGhhdCBieSBvbmx5IGV4cG9zaW5nIHRoZSBwcmltYXJ5IG1hajptaW4g
cGFpciwgSSB0aGluayB3ZSBjYW4KPiBnbyB3aXRoIHRoYXQgYW5kIGl0J3MgYWxsIG5pY2VseSBj
b25zaXN0ZW50LgoKQWggeWVhaCwgdGhhdCBzb3VuZHMgZXF1aXZhbGVudC4gIEdyZWF0LgoKVGhh
bmtzLgoKLS0gCnRlanVuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
Cmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeA==
