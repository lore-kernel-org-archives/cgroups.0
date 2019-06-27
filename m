From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [RFC PATCH v3 07/11] drm, cgroup: Add TTM buffer allocation stats
Date: Thu, 27 Jun 2019 23:33:17 +0200
Message-ID: <20190627213317.GP12905@phenom.ffwll.local>
References: <20190626150522.11618-1-Kenny.Ho@amd.com>
 <20190626150522.11618-8-Kenny.Ho@amd.com>
 <20190626161254.GS12905@phenom.ffwll.local>
 <CAOWid-f3kKnM=4oC5Bba5WW5WNV2MH5PvVamrhO6LBr5ydPJQg@mail.gmail.com>
 <20190627060113.GC12905@phenom.ffwll.local>
 <CAOWid-e=M4Rf30s8ZoK5n2fOYNHhvpun0H=7URsKmsGc3Z0FDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <CAOWid-e=M4Rf30s8ZoK5n2fOYNHhvpun0H=7URsKmsGc3Z0FDQ@mail.gmail.com>
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
To: Kenny Ho <y2kenny@gmail.com>
Cc: amd-gfx list <amd-gfx@lists.freedesktop.org>, joseph.greathouse@amd.com, Kenny Ho <Kenny.Ho@amd.com>, Brian Welty <brian.welty@intel.com>, jsparks@cray.com, dri-devel <dri-devel@lists.freedesktop.org>, lkaplan@cray.com, Alex Deucher <alexander.deucher@amd.com>, kraxel@redhat.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>

T24gVGh1LCBKdW4gMjcsIDIwMTkgYXQgMDQ6MTc6MDlQTSAtMDQwMCwgS2VubnkgSG8gd3JvdGU6
Cj4gT24gVGh1LCBKdW4gMjcsIDIwMTkgYXQgMjowMSBBTSBEYW5pZWwgVmV0dGVyIDxkYW5pZWxA
ZmZ3bGwuY2g+IHdyb3RlOgo+ID4gYnR3IHJlbWluZHMgbWU6IEkgZ3Vlc3MgaXQgd291bGQgYmUg
Z29vZCB0byBoYXZlIGEgcGVyLXR5cGUgLnRvdGFsCj4gPiByZWFkLW9ubHkgZXhwb3NlZCwgc28g
dGhhdCB1c2Vyc3BhY2UgaGFzIGFuIGlkZWEgb2YgaG93IG11Y2ggdGhlcmUgaXM/Cj4gPiB0dG0g
aXMgdHJ5aW5nIHRvIGJlIGFnbm9zdGljIHRvIHRoZSBhbGxvY2F0b3IgdGhhdCdzIHVzZWQgdG8g
bWFuYWdlIGEKPiA+IG1lbW9yeSB0eXBlL3Jlc291cmNlLCBzbyBkb2Vzbid0IGV2ZW4ga25vdyB0
aGF0LiBCdXQgSSB0aGluayBzb21ldGhpbmcgd2UKPiA+IG5lZWQgdG8gZXhwb3NlIHRvIGFkbWlu
cywgb3RoZXJ3aXNlIHRoZXkgY2FuJ3QgbWVhbmluZ2Z1bGx5IHNldCBsaW1pdHMuCj4gCj4gSSBk
b24ndCB0aGluayBJIHVuZGVyc3RhbmQgdGhpcyBiaXQsIGRvIHlvdSBtZWFuIHRvdGFsIGFjcm9z
cyBtdWx0aXBsZQo+IEdQVSBvZiB0aGUgc2FtZSBtZW0gdHlwZT8gIE9yIGRvIHlvdSBtZWFuIHRo
ZSB0b3RhbCBhdmFpbGFibGUgcGVyIEdQVQo+IChvciBzb21ldGhpbmcgZWxzZT8pCgpUb3RhbCBm
b3IgYSBnaXZlbiB0eXBlIG9uIGEgZ2l2ZW4gY3B1LiBFLmcuIG1heWJlIHlvdSB3YW50IHRvIGdp
dmUgNTAlIG9mCnlvdXIgdnJhbSB0byBvbmUgY2dyb3VwLCBhbmQgdGhlIG90aGVyIDUwJSB0byB0
aGUgb3RoZXIgY2dyb3VwLiBGb3IgdGhhdAp5b3UgbmVlZCB0byBrbm93IGhvdyBtdWNoIHZyYW0g
eW91IGhhdmUuIEFuZCBleHBlY3RpbmcgcGVvcGxlIHRvIGxzcGNpIGFuZAp0aGVuIGxvb2sgYXQg
d2lraXBlZGlhIGZvciBob3cgbXVjaCB2cmFtIHRoYXQgY2hpcCBzaG91bGQgaGF2ZSAob3IKc29t
ZXRoaW5nIGxpa2UgdGhhdCkgaXNuJ3QgZ3JlYXQuIEhlbmNlIDAudnJhbS50b3RhbCwgMC50dC50
b3RhbCwgYW5kIHNvCm9uIChhbHNvIGZvciBhbGwgdGhlIG90aGVyIGdwdSBtaW5vcnMgb2ZjKS4g
IEZvciBzeXN0ZW0gbWVtb3J5IHdlIHByb2JhYmx5CmRvbid0IHdhbnQgdG8gcHJvdmlkZSBhIHRv
dGFsLCBzaW5jZSB0aGF0J3MgYWxyZWFkeSBhIHZhbHVlIHRoYXQncyBlYXN5IHRvCm9idGFpbiBm
cm9tIHZhcmlvdXMgc291cmNlcy4KLURhbmllbAotLSAKRGFuaWVsIFZldHRlcgpTb2Z0d2FyZSBF
bmdpbmVlciwgSW50ZWwgQ29ycG9yYXRpb24KaHR0cDovL2Jsb2cuZmZ3bGwuY2gKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcg
bGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRl
c2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
