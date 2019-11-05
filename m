From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] cgroup: Document interface files and rationale for
 DRM controller
Date: Mon, 4 Nov 2019 16:15:05 -0800
Message-ID: <20191105001505.GR3622521@devbig004.ftw2.facebook.com>
References: <20191104220847.23283-1-brian.welty@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20191104220847.23283-1-brian.welty@intel.com>
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

T24gTW9uLCBOb3YgMDQsIDIwMTkgYXQgMDU6MDg6NDdQTSAtMDUwMCwgQnJpYW4gV2VsdHkgd3Jv
dGU6Cj4gKyAgZ3B1c2V0LnVuaXRzCj4gKyAgZ3B1c2V0LnVuaXRzLmVmZmVjdGl2ZQo+ICsgIGdw
dXNldC51bml0cy5wYXJ0aXRpb24KPiArCj4gKyAgZ3B1c2V0Lm1lbXMKPiArICBncHVzZXQubWVt
cy5lZmZlY3RpdmUKPiArICBncHVzZXQubWVtcy5wYXJ0aXRpb24KPiArCj4gKyAgc2NoZWQubWF4
Cj4gKyAgc2NoZWQuc3RhdHMKPiArICBzY2hlZC53ZWlnaHQKPiArICBzY2hlZC53ZWlnaHQubmlj
ZQo+ICsKPiArICBtZW1vcnkuY3VycmVudAo+ICsgIG1lbW9yeS5ldmVudHMKPiArICBtZW1vcnku
aGlnaAo+ICsgIG1lbW9yeS5sb3cKPiArICBtZW1vcnkubWF4Cj4gKyAgbWVtb3J5Lm1pbgo+ICsg
IG1lbW9yeS5zdGF0Cj4gKyAgbWVtb3J5LnN3YXAuY3VycmVudAo+ICsgIG1lbW9yeS5zd2FwLm1h
eAoKSSBkb24ndCB1bmRlcnN0YW5kIHdoeSBpdCBuZWVkcyB0byByZXBsaWNhdGUgZXNzZW50aWFs
bHkgKmFsbCogdGhlCmludGVyZmFjZXMgdGhhdCBzeXN0ZW0gcmVzb3VyY2VzIGFyZSBpbXBsZW1l
bnRpbmcgZnJvbSB0aGUgZ2V0LWdvLgpTb21lIG9mIHRoZSBhYm92ZSBoYXZlIGludGVyc2VjdGlu
ZyBmdW5jdGlvbmFsaXRpZXMgYW5kIGV4aXN0IG1vcmUgZm9yCmhpc3RvcmljYWwgcmVhc29ucyBh
bmQgSSBmYWlsIHRvIHNlZSBob3cgZGlzdGluY3Rpb25zIGxpa2UgbWluIHZzLiBsb3cKYW5kIGhp
Z2ggdnMuIG1heCB3b3VsZCBtYWtlIHNlbnNlIGZvciBncHVzLiAgQWxzbywgd2h5IHdvdWxkIGl0
IGhhdmUgYQpzZXBhcmF0ZSBzd2FwIGxpbWl0IG9mIGl0cyBvd24/CgpQbGVhc2Ugc3RhcnQgd2l0
aCBzb21ldGhpbmcgc21hbGwgYW5kIGludHVpdGl2ZS4gIEknbSBnb25uYSBuYWNrCmFueXRoaW5n
IHdoaWNoIHNwcmF3bHMgb3V0IGxpa2UgdGhpcy4gIE1vc3QgbGlrZWx5LCB0aGVyZSdzIHN0aWxs
IGEKdG9uIHlvdSBndXlzIG5lZWQgdG8gd29yayB0aHJvdWdoIHRvIHJlYWNoIHRoZSByZXNvdXJj
ZSBtb2RlbCB3aGljaCBpcwphY3R1YWxseSB1c2VmdWwgYW5kIHRyeWluZyB0byBkZWZpbmUgYSBj
b21wcmVoZW5zaXZlIGludGVyZmFjZSB1cGZyb250Cmxpa2UgdGhpcyBpcyBnb25uYSBsb29rIHJl
YWxseSBzaWxseSBhbmQgd2lsbCBiZWNvbWUgYW4gdWdseSBkcmFnIGJ5CnRoZSB0aW1lIHRoZSBw
cm9ibGVtIHNwYWNlIGlzIGFjdHVhbGx5IHVuZGVyc3Rvb2QuCgpJdCBkb2Vzbid0IHNlZW0gbGlr
ZSB0aGlzIGlzIGNvbWluZyB0aHJvdWdoIGJ1dCBjYW4geW91IHBsZWFzZSBzdGFydAp3aXRoIGEg
c2ltcGxlIHdlaWdodCBrbm9iPwoKVGhhbmtzLgoKLS0gCnRlanVuCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJp
LWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbA==
