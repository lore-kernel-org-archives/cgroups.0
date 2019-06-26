From: Kenny Ho <y2kenny@gmail.com>
Subject: Re: [RFC PATCH v3 01/11] cgroup: Introduce cgroup for drm subsystem
Date: Wed, 26 Jun 2019 15:35:06 -0400
Message-ID: <CAOWid-dyGwf=e0ikBEQ=bnVM_bC8-FeTOD8fJVMJKUgPv6vtyw@mail.gmail.com>
References: <20190626150522.11618-1-Kenny.Ho@amd.com>
 <20190626150522.11618-2-Kenny.Ho@amd.com>
 <20190626154929.GP12905@phenom.ffwll.local>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190626154929.GP12905@phenom.ffwll.local>
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
Cc: Kenny Ho <Kenny.Ho@amd.com>, jsparks@cray.com, amd-gfx@lists.freedesktop.org, lkaplan@cray.com, Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org, joseph.greathouse@amd.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>

T24gV2VkLCBKdW4gMjYsIDIwMTkgYXQgMTE6NDkgQU0gRGFuaWVsIFZldHRlciA8ZGFuaWVsQGZm
d2xsLmNoPiB3cm90ZToKPgo+IEJ1bmNoIG9mIG5hbWluZyBiaWtlc2hlZHMKCkkgYXBwcmVjaWF0
ZSB0aGUgc3VnZ2VzdGlvbnMsIG5hbWluZyBpcyBoYXJkIDopLgoKPiA+ICsjaW5jbHVkZSA8bGlu
dXgvY2dyb3VwLmg+Cj4gPiArCj4gPiArc3RydWN0IGRybWNncnAgewo+Cj4gZHJtX2Nncm91cCBm
b3IgbW9yZSBjb25zaXN0ZW5jeSBob3cgd2UgdXN1YWxseSBjYWxsIHRoZXNlIHRoaW5ncy4KCkkg
d2FzIGhvcGluZyB0byBrZWVwIHRoZSBzeW1ib2wgc2hvcnQgaWYgcG9zc2libGUuICBJIHN0YXJ0
ZWQgd2l0aApkcm1jZyAoZm9sbG93aW5nIGJsa2NnKSwgIGJ1dCBJIGJlbGlldmUgdGhhdCBjYXVz
ZXMgY29uZnVzaW9uIHdpdGgKb3RoZXIgYXNwZWN0IG9mIHRoZSBkcm0gc3Vic3lzdGVtLiAgSSBk
b24ndCBoYXZlIHRvbyBzdHJvbmcgb2YgYW4Kb3BpbmlvbiBvbiB0aGlzIGJ1dCBJJ2QgcHJlZmVy
IG5vdCBuZWVkaW5nIHRvIGtlZXAgcmVmYWN0b3JpbmcuICBTbyBpZgp0aGVyZSBhcmUgb3RoZXIg
b3BpbmlvbnMgb24gdGhpcywgcGxlYXNlIHNwZWFrIHVwLgoKPiA+ICsKPiA+ICtzdGF0aWMgaW5s
aW5lIHZvaWQgcHV0X2RybWNncnAoc3RydWN0IGRybWNncnAgKmRybWNncnApCj4KPiBJbiBkcm0g
d2UgZ2VuZXJhbGx5IHB1dCBfZ2V0L19wdXQgYXQgdGhlIGVuZCwgY2dyb3VwIHNlZW1zIHRvIGRv
IHRoZSBzYW1lLgoKb2ssIEkgd2lsbCByZWZhY3Rvci4KCj4gPiArewo+ID4gKyAgICAgaWYgKGRy
bWNncnApCj4gPiArICAgICAgICAgICAgIGNzc19wdXQoJmRybWNncnAtPmNzcyk7Cj4gPiArfQo+
ID4gKwo+ID4gK3N0YXRpYyBpbmxpbmUgc3RydWN0IGRybWNncnAgKnBhcmVudF9kcm1jZ3JwKHN0
cnVjdCBkcm1jZ3JwICpjZykKPgo+IEknZCBhbHNvIGNhbGwgdGhpcyBkcm1fY2dyb3VwX3BhcmVu
dCBvciBzby4KPgo+IEFsc28gYWxsIHRoZSBhYm92ZSBuZWVkcyBhIGJpdCBvZiBuaWNlIGtlcm5l
bGRvYyBmb3IgdGhlIGZpbmFsIHZlcnNpb24uCj4gLURhbmllbAoKTm90ZWQsIHdpbGwgZG8sIHRo
YW5rcy4KClJlZ2FyZHMsCktlbm55Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVk
ZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZv
L2RyaS1kZXZlbA==
