From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] cgroup: Document interface files and rationale for
 DRM controller
Date: Thu, 7 Nov 2019 07:29:14 -0800
Message-ID: <20191107152914.GU3622521@devbig004.ftw2.facebook.com>
References: <20191104220847.23283-1-brian.welty@intel.com>
 <20191105001505.GR3622521@devbig004.ftw2.facebook.com>
 <d565fc2c-0bd0-a85a-c7ce-12ee5393154d@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <d565fc2c-0bd0-a85a-c7ce-12ee5393154d@intel.com>
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
To: Brian Welty <brian.welty@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, David Airlie <airlied@linux.ie>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Felix Kuehling <Felix.Kuehling@amd.com>, dri-devel@lists.freedesktop.org, Kenny Ho <Kenny.Ho@amd.com>, cgroups@vger.kernel.org, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>

SGVsbG8sCgpPbiBUdWUsIE5vdiAwNSwgMjAxOSBhdCAwNDowODoyMlBNIC0wODAwLCBCcmlhbiBX
ZWx0eSB3cm90ZToKPiBJIHdhcyBtb3JlIGludGVyZXN0ZWQgaW4gaGVhcmluZyB5b3VyIHRob3Vn
aHRzIG9uIHdoZXRoZXIgeW91IGxpa2UKPiB0aGUgYXBwcm9hY2ggdG8gaGF2ZSBhIHNldCBvZiBj
b250cm9scyB0aGF0IGFyZSBjb25zaXN0ZW50IHdpdGggCj4gc29tZSBzdWJzZXQgb2YgdGhlIGV4
aXN0aW5nIENQVS9NRU0gb25lcy4gIEFueSBmZWVkYmFjayBvbiB0aGlzPwo+IERpZG4ndCByZWFs
bHkgbWVhbiB0byBzdWdnZXN0IHRoYXQgYWxsIG9mIHRoZXNlIHdvdWxkIGJlIGluY2x1ZGVkCj4g
ZnJvbSB0aGUgc3RhcnQuCgpJIGRvbid0IHNlZSB3aHkgdGhleSBzaG91bGQgYmUgc3luY2hyb25p
emVkLiAgSWYgaXQgZW5kcyB1cCBiZWluZwphYm91dCB0aGUgc2FtZSBhbnl3YXksIHRoZXJlJ3Mg
bm8gcmVhc29uIHRvIG5vdCBzeW5jIHRoZW0gYnV0IHRoYXQKZG9lc24ndCBzZWVtIHZlcnkgbGlr
ZWx5IHRvIG1lIGFuZCB0cnlpbmcgdG8gc3luYyBzb3VuZHMgbGlrZSBhZGRpbmcKYW4gdW5uZWNl
c3NhcnkgY29uc3RyYWludC4gIE9uZSBzaWRlIG9mIHRoZSBiYWxsb3QgaXMgcG9zc2libHkgbWlz
c2luZwpvbiBhZXN0aGV0aWNzIGEgYml0IHdoaWxlIHRoZSBvdGhlciBzaWRlIGlzIGNvbnN0cmFp
bmluZyBpbnRlcmZhY2UKZGVzaWduIGV2ZW4gYmVmb3JlIHVuZGVyc3RhbmRpbmcgdGhlIGRlc2ln
biBzcGFjZSwgc28uLi4KCj4gV291bGQgeW91IGFncmVlIHRoYXQgdGhpcyByZWR1Y2VkIHNldCBp
cyBhIHJlYXNvbmFibGUgc3RhcnRpbmcgcG9pbnQ/Cj4gKyAgc2NoZWQud2VpZ2h0Cj4gKyAgbWVt
b3J5LmN1cnJlbnQKPiArICBtZW1vcnkubWF4Cj4gCj4gVGhvdWdodHMgb24gd2hldGhlciB0aGlz
IHNob3VsZCBiZSB2ZXJ5IEdQVS1zcGVjaWZpYyBjZ3JvdXBzIGNvbnRyb2xsZXIKPiBvciBzaG91
bGQgYmUgbW9yZSBmb3J3YXJkIHRoaW5raW5nIHRvIGJlIHVzZWZ1bCBmb3Igb3RoZXIgJ2FjY2Vs
ZXJhdG9yJwo+IHR5cGUgZGV2aWNlcyBhcyB3ZWxsPwoKTXkgcHJlZmVyZW5jZSBpcyBzdGFydGlu
ZyBzbWFsbCBhbmQgZm9jdXNlZC4gIEdQVSBieSBpdHNlbGYgaXMgYWxyZWFkeQphIGJpZyBlbm91
Z2ggcHJvYmxlbSBhbmQgdGhlIHByb2dyZXNzIHVwdG8gdGhpcyBwb2ludCBldmlkZW50bHkKaW5k
aWNhdGVzIGV2ZW4gdGhhdCBhbG9uZSBpcyBwb29ybHkgbWFwcGVkIG91dC4gIFBsZWFzZSBzdGFy
dCB3aXRoIHRoZQpzbWFsbGVzdCBhbmQgbW9zdCBjb21tb24gKHRpZWQgdG8gdXNhZ2UsIG5vdCBo
YXJkd2FyZSkgaW50ZXJmYWNlCnRoYXQncyB2aWFibGUuCgpUaGFua3MuCgotLSAKdGVqdW4KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1h
aWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
