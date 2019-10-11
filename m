From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH RFC v4 14/16] drm, cgroup: Introduce lgpu as DRM cgroup
 resource
Date: Fri, 11 Oct 2019 10:12:47 -0700
Message-ID: <20191011171247.GC18794@devbig004.ftw2.facebook.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-15-Kenny.Ho@amd.com>
 <b3d2b3c1-8854-10ca-3e39-b3bef35bdfa9@amd.com>
 <20191009103153.GU16989@phenom.ffwll.local>
 <ee873e89-48fd-c4c9-1ce0-73965f4ad2ba@amd.com>
 <20191009153429.GI16989@phenom.ffwll.local>
 <c7812af4-7ec4-02bb-ff4c-21dd114cf38e@amd.com>
 <20191009160652.GO16989@phenom.ffwll.local>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20191009160652.GO16989@phenom.ffwll.local>
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
Cc: "Ho, Kenny" <Kenny.Ho@amd.com>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, "jsparks@cray.com" <jsparks@cray.com>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "lkaplan@cray.com" <lkaplan@cray.com>, "y2kenny@gmail.com" <y2kenny@gmail.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Greathouse, Joseph" <Joseph.Greathouse@amd.com>, "Deucher,
 Alexander" <Alexander.Deucher@amd.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Koenig,
 Christian" <Christian.Koenig@amd.com>

SGVsbG8sIERhbmllbC4KCk9uIFdlZCwgT2N0IDA5LCAyMDE5IGF0IDA2OjA2OjUyUE0gKzAyMDAs
IERhbmllbCBWZXR0ZXIgd3JvdGU6Cj4gVGhhdCdzIG5vdCB0aGUgcG9pbnQgSSB3YXMgbWFraW5n
LiBGb3IgY3B1IGNncm91cHMgdGhlcmUncyBhIHZlcnkgd2VsbAo+IGRlZmluZWQgY29ubmVjdGlv
biBiZXR3ZWVuIHRoZSBjcHUgYml0bWFza3MvbnVtYmVycyBpbiBjZ3JvdXBzIGFuZCB0aGUgY3B1
Cj4gYml0bWFza3MgeW91IHVzZSBpbiB2YXJpb3VzIHN5c3RlbSBjYWxscyAodGhleSBtYXRjaCku
IEFuZCB0aGF0IHN0dWZmCj4gd29ya3MgYWNyb3NzIHZlbmRvcnMuCgpQbGVhc2Ugbm90ZSB0aGF0
IHRoZXJlIGFyZSBhIGxvdCBvZiBsaW1pdGF0aW9ucyBldmVuIHRvIGNwdXNldC4KQWZmaW5pdHkg
aXMgZWFzeSB0byBpbXBsZW1lbnQgYW5kIHNlZW1zIGF0dHJhY3RpdmUgaW4gdGVybXMgb2YKYWJz
b2x1dGUgaXNvbGF0aW9uIGJ1dCBpdCdzIGluaGVyZW50bHkgY3VtYmVyc29tZSBhbmQgbGltaXRl
ZCBpbgpncmFudWxhcml0eSBhbmQgY2FuIGxlYWQgdG8gc3VycHJpc2luZyBmYWlsdXJlIG1vZGVz
IHdoZXJlIGNvbnRlbnRpb24Kb24gb25lIGNwdSBjYW4ndCBiZSByZXNvbHZlZCBieSB0aGUgbG9h
ZCBiYWxhbmNlciBhbmQgbGVhZHMgdG8gc3lzdGVtCndpZGUgc2xvd2Rvd25zIC8gc3RhbGxzIGNh
dXNlZCBieSB0aGUgZGVwZW5kZW5jeSBjaGFpbiBhbmNob3JlZCBhdCB0aGUKYWZmaW5pdHkgbGlt
aXRlZCB0YXNrcy4KCk1heWJlIHRoaXMgaXMgYSBsZXNzIG9mIGEgcHJvYmxlbSBmb3IgZ3B1IHdv
cmtsb2FkcyBidXQgaW4gZ2VuZXJhbCB0aGUKbW9yZSBjb25zdHJhaW50cyBhcmUgcHV0IG9uIHNj
aGVkdWxpbmcsIHRoZSBtb3JlIGxpa2VseSBpcyB0aGUgc3lzdGVtCnRvIGRldmVsb3AgdHdpc3Rl
ZCBkZXBlbmRlbmN5IGNoYWlucyB3aGlsZSBvdGhlciBwYXJ0cyBvZiB0aGUgc3lzdGVtCmFyZSBz
aXR0aW5nIGlkbGUuCgpIb3cgZG9lcyBzY2hlZHVsaW5nIGN1cnJlbnRseSB3b3JrIHdoZW4gdGhl
cmUgYXJlIGNvbXBldGluZyBncHUKd29ya2xvYWRzPyAgVGhlcmUgZ290dGEgYmUgc29tZSBmYWly
bmVzcyBwcm92aXNpb24gd2hldGhlciB0aGF0J3MgdW5pdAphbGxvY2F0aW9uIGJhc2VkIG9yIHRp
bWUgc2xpY2luZywgcmlnaHQ/ICBJZiB0aGF0J3MgdGhlIGNhc2UsIGl0IG1pZ2h0CmJlIGJlc3Qg
dG8gaW1wbGVtZW50IHByb3BvcnRpb25hbCBjb250cm9sIG9uIHRvcCBvZiB0aGF0LgpXb3JrLWNv
bnNlcnZpbmcgbWVjaGFuaXNtcyBhcmUgdGhlIG1vc3QgdmVyc2F0aWxlLCBlYXNpZXN0IHRvIHVz
ZSBhbmQKbGVhc3QgbGlrZWx5IHRvIGNhdXNlIHJlZ3Jlc3Npb25zLgoKVGhhbmtzLgoKLS0gCnRl
anVuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczov
L2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbA==
