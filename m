From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH RFC v2 5/7] drm/i915: cgroup integration
Date: Thu, 01 Feb 2018 20:15:24 +0000
Message-ID: <151751612440.28099.10617324004476224265@mail.alporthouse.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195315.4956-6-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180201195315.4956-6-matthew.d.roper@intel.com>
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
To: Matt Roper <matthew.d.roper@intel.com>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org

UXVvdGluZyBNYXR0IFJvcGVyICgyMDE4LTAyLTAxIDE5OjUzOjEzKQo+ICsjaW5jbHVkZSA8bGlu
dXgvY2dyb3VwLmg+Cj4gKwo+ICsjaW5jbHVkZSAiaTkxNV9kcnYuaCIKPiArCj4gK3N0cnVjdCBp
OTE1X2Nncm91cF9kYXRhIHsKPiArICAgICAgIHN0cnVjdCBjZ3JvdXBfZHJpdmVyX2RhdGEgYmFz
ZTsKPiArfTsKPiArCj4gK3N0YXRpYyBpbmxpbmUgc3RydWN0IGk5MTVfY2dyb3VwX2RhdGEgKgo+
ICtjZ3JwX3RvX2k5MTUoc3RydWN0IGNncm91cF9kcml2ZXJfZGF0YSAqZGF0YSkKPiArewoKRG9j
dW1lbnQgeW91ciByZXF1aXJlbWVudCB0aGF0IGJhc2UgaXMgb2Zmc2V0IDAgKHJlcXVpcmVkIGZv
ciBib3RoCmk5MTVfY2dyb3VwX2FsbG9jIGFuZCBpOTE1X2Nncm91cF9mcmVlKS4KCkJVSUxEX0JV
R19PTihvZmZzZXRvZihzdHJ1Y3QgaTkxNV9jZ3JvdXBfZGF0YSwgYmFzZSkpOwoKKG9yIG1ha2Ug
c2FpZCBjb2RlIGZsZXhpYmxlKQoKPiArICAgICAgIHJldHVybiBjb250YWluZXJfb2YoZGF0YSwg
c3RydWN0IGk5MTVfY2dyb3VwX2RhdGEsIGJhc2UpOwo+ICt9Cj4gKwo+ICtzdGF0aWMgc3RydWN0
IGNncm91cF9kcml2ZXJfZGF0YSAqCj4gK2k5MTVfY2dyb3VwX2FsbG9jKHN0cnVjdCBjZ3JvdXBf
ZHJpdmVyICpkcnYpCj4gK3sKPiArICAgICAgIHN0cnVjdCBpOTE1X2Nncm91cF9kYXRhICpkYXRh
Owo+ICsKPiArICAgICAgIGRhdGEgPSBremFsbG9jKHNpemVvZiAqZGF0YSwgR0ZQX0tFUk5FTCk7
Cj4gKyAgICAgICByZXR1cm4gJmRhdGEtPmJhc2U7Cj4gK30KPiArCj4gK3N0YXRpYyB2b2lkCj4g
K2k5MTVfY2dyb3VwX2ZyZWUoc3RydWN0IGNncm91cF9kcml2ZXJfZGF0YSAqZGF0YSkKPiArewo+
ICsgICAgICAga2ZyZWUoZGF0YSk7Cj4gK30KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlz
dGluZm8vZHJpLWRldmVsCg==
