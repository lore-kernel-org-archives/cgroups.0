From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH RFC v4 01/16] drm: Add drm_minor_for_each
Date: Fri, 6 Sep 2019 17:36:02 +0200
Message-ID: <CAKMK7uFQqAMB1DbiEy-o2bzr_F25My93imNcg1Qh9DHe=uWQug@mail.gmail.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-2-Kenny.Ho@amd.com>
 <20190903075719.GK2112@phenom.ffwll.local>
 <CAOWid-dxxDhyxP2+0R0oKAk29rR-1TbMyhshR1+gbcpGJCAW6g@mail.gmail.com>
 <CAKMK7uEofjdVURu+meonh_YdV5eX8vfNALkW3A_+kLapCV8j+w@mail.gmail.com>
 <CAOWid-eUVztW4hNVpznnJRcwHcjCirGL2aS75p4OY8XoGuJqUg@mail.gmail.com>
 <20190904085434.GF2112@phenom.ffwll.local>
 <20190906152925.GN2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190906152925.GN2263813@devbig004.ftw2.facebook.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Kenny Ho <Kenny.Ho@amd.com>, "Kuehling, Felix" <felix.kuehling@amd.com>, jsparks@cray.com, amd-gfx list <amd-gfx@lists.freedesktop.org>, lkaplan@cray.com, Kenny Ho <y2kenny@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, "Greathouse,
 Joseph" <joseph.greathouse@amd.com>, Alex Deucher <alexander.deucher@amd.com>, cgroups@vger.kernel.org, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>

T24gRnJpLCBTZXAgNiwgMjAxOSBhdCA1OjI5IFBNIFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4g
d3JvdGU6Cj4KPiBIZWxsbywKPgo+IE9uIFdlZCwgU2VwIDA0LCAyMDE5IGF0IDEwOjU0OjM0QU0g
KzAyMDAsIERhbmllbCBWZXR0ZXIgd3JvdGU6Cj4gPiBBbnl3YXksIEkgZG9uJ3QgdGhpbmsgcmV1
c2luZyB0aGUgZHJtX21pbm9yIHJlZ2lzdHJhdGlvbiBtYWtlcyBzZW5zZSwKPiA+IHNpbmNlIHdl
IHdhbnQgdG8gYmUgb24gdGhlIGRybV9kZXZpY2UsIG5vdCBvbiB0aGUgbWlub3IuIFdoaWNoIGlz
IGEgYml0Cj4gPiBhd2t3YXJkIGZvciBjZ3JvdXBzLCB3aGljaCB3YW50cyB0byBpZGVudGlmeSBk
ZXZpY2VzIHVzaW5nIG1ham9yLm1pbm9yCj4gPiBwYWlycy4gQnV0IEkgZ3Vlc3MgZHJtIGlzIHRo
ZSBmaXJzdCBzdWJzeXN0ZW0gd2hlcmUgMSBkZXZpY2UgY2FuIGJlCj4gPiBleHBvc2VkIHRocm91
Z2ggbXVsdGlwbGUgbWlub3JzIC4uLgo+ID4KPiA+IFRlanVuLCBhbnkgc3VnZ2VzdGlvbnMgb24g
dGhpcz8KPgo+IEknbSBub3QgZXh0cmVtZWx5IGF0dGFjaGVkIHRvIG1hajptaW4uICBJdCdzIG5p
Y2UgaW4gdGhhdCBpdCdkIGJlCj4gY29uc2lzdGVudCB3aXRoIGJsa2NnIGJ1dCBpdCBhbHJlYWR5
IGlzbid0IHRoZSBuaWNlc3Qgb2YgaWRlbnRpZmllcnMKPiBmb3IgYmxvY2sgZGV2aWNlcy4gIElm
IHVzaW5nIG1hajptaW4gaXMgcmVhc29uYWJseSBzdHJhaWdodCBmb3J3YXJkCj4gZm9yIGdwdXMg
ZXZlbiBpZiBub3QgcGVyZmVjdCwgSSdkIHByZWZlciBnb2luZyB3aXRoIG1hajptaW4uCj4gT3Ro
ZXJ3aXNlLCBwbGVhc2UgZmVlbCBmcmVlIHRvIHVzZSB0aGUgSUQgYmVzdCBmb3IgR1BVcyAtIGhv
cGVmdWxseQo+IHNvbWV0aGluZyB3aGljaCBpcyBlYXN5IHRvIHVuZGVyc3RhbmQsIGNvbnNpc3Rl
bnQgd2l0aCBJRHMgdXNlZAo+IGVsc2V3aGVyZSBhbmQgZWFzeSB0byBidWlsZCB0b29saW5nIGFy
b3VuZC4KCkJsb2NrIGRldmljZXMgYXJlIGEgZ3JlYXQgZXhhbXBsZSBJIHRoaW5rLiBIb3cgZG8g
eW91IGhhbmRsZSB0aGUKcGFydGl0aW9ucyBvbiB0aGF0PyBGb3IgZHJtIHdlIGFsc28gaGF2ZSBh
IG1haW4gbWlub3IgaW50ZXJmYWNlLCBhbmQKdGhlbiB0aGUgcmVuZGVyLW9ubHkgaW50ZXJmYWNl
IG9uIGRyaXZlcnMgdGhhdCBzdXBwb3J0IGl0LiBTbyBpZiBibGtjZwpoYW5kbGVzIHRoYXQgYnkg
b25seSBleHBvc2luZyB0aGUgcHJpbWFyeSBtYWo6bWluIHBhaXIsIEkgdGhpbmsgd2UgY2FuCmdv
IHdpdGggdGhhdCBhbmQgaXQncyBhbGwgbmljZWx5IGNvbnNpc3RlbnQuCi1EYW5pZWwKLS0gCkRh
bmllbCBWZXR0ZXIKU29mdHdhcmUgRW5naW5lZXIsIEludGVsIENvcnBvcmF0aW9uCis0MSAoMCkg
NzkgMzY1IDU3IDQ4IC0gaHR0cDovL2Jsb2cuZmZ3bGwuY2gKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2
ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21h
aWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
