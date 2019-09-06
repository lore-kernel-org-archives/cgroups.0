From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC v4 01/16] drm: Add drm_minor_for_each
Date: Fri, 6 Sep 2019 08:29:25 -0700
Message-ID: <20190906152925.GN2263813@devbig004.ftw2.facebook.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-2-Kenny.Ho@amd.com>
 <20190903075719.GK2112@phenom.ffwll.local>
 <CAOWid-dxxDhyxP2+0R0oKAk29rR-1TbMyhshR1+gbcpGJCAW6g@mail.gmail.com>
 <CAKMK7uEofjdVURu+meonh_YdV5eX8vfNALkW3A_+kLapCV8j+w@mail.gmail.com>
 <CAOWid-eUVztW4hNVpznnJRcwHcjCirGL2aS75p4OY8XoGuJqUg@mail.gmail.com>
 <20190904085434.GF2112@phenom.ffwll.local>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190904085434.GF2112@phenom.ffwll.local>
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
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Kenny Ho <Kenny.Ho@amd.com>, "Kuehling, Felix" <felix.kuehling@amd.com>, jsparks@cray.com, amd-gfx list <amd-gfx@lists.freedesktop.org>, lkaplan@cray.com, Kenny Ho <y2kenny@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, "Greathouse,
 Joseph" <joseph.greathouse@amd.com>, Alex Deucher <alexander.deucher@amd.com>, cgroups@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>

SGVsbG8sCgpPbiBXZWQsIFNlcCAwNCwgMjAxOSBhdCAxMDo1NDozNEFNICswMjAwLCBEYW5pZWwg
VmV0dGVyIHdyb3RlOgo+IEFueXdheSwgSSBkb24ndCB0aGluayByZXVzaW5nIHRoZSBkcm1fbWlu
b3IgcmVnaXN0cmF0aW9uIG1ha2VzIHNlbnNlLAo+IHNpbmNlIHdlIHdhbnQgdG8gYmUgb24gdGhl
IGRybV9kZXZpY2UsIG5vdCBvbiB0aGUgbWlub3IuIFdoaWNoIGlzIGEgYml0Cj4gYXdrd2FyZCBm
b3IgY2dyb3Vwcywgd2hpY2ggd2FudHMgdG8gaWRlbnRpZnkgZGV2aWNlcyB1c2luZyBtYWpvci5t
aW5vcgo+IHBhaXJzLiBCdXQgSSBndWVzcyBkcm0gaXMgdGhlIGZpcnN0IHN1YnN5c3RlbSB3aGVy
ZSAxIGRldmljZSBjYW4gYmUKPiBleHBvc2VkIHRocm91Z2ggbXVsdGlwbGUgbWlub3JzIC4uLgo+
IAo+IFRlanVuLCBhbnkgc3VnZ2VzdGlvbnMgb24gdGhpcz8KCkknbSBub3QgZXh0cmVtZWx5IGF0
dGFjaGVkIHRvIG1hajptaW4uICBJdCdzIG5pY2UgaW4gdGhhdCBpdCdkIGJlCmNvbnNpc3RlbnQg
d2l0aCBibGtjZyBidXQgaXQgYWxyZWFkeSBpc24ndCB0aGUgbmljZXN0IG9mIGlkZW50aWZpZXJz
CmZvciBibG9jayBkZXZpY2VzLiAgSWYgdXNpbmcgbWFqOm1pbiBpcyByZWFzb25hYmx5IHN0cmFp
Z2h0IGZvcndhcmQKZm9yIGdwdXMgZXZlbiBpZiBub3QgcGVyZmVjdCwgSSdkIHByZWZlciBnb2lu
ZyB3aXRoIG1hajptaW4uCk90aGVyd2lzZSwgcGxlYXNlIGZlZWwgZnJlZSB0byB1c2UgdGhlIElE
IGJlc3QgZm9yIEdQVXMgLSBob3BlZnVsbHkKc29tZXRoaW5nIHdoaWNoIGlzIGVhc3kgdG8gdW5k
ZXJzdGFuZCwgY29uc2lzdGVudCB3aXRoIElEcyB1c2VkCmVsc2V3aGVyZSBhbmQgZWFzeSB0byBi
dWlsZCB0b29saW5nIGFyb3VuZC4KClRoYW5rcy4KCi0tIAp0ZWp1bgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRy
aS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
