From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 03/12] cgroup: use for_each_if
Date: Mon,  9 Jul 2018 10:36:41 +0200
Message-ID: <20180709083650.23549-3-daniel.vetter@ffwll.ch>
References: <20180709083650.23549-1-daniel.vetter@ffwll.ch>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180709083650.23549-1-daniel.vetter@ffwll.ch>
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
To: LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Intel Graphics Development <intel-gfx@lists.freedesktop.org>, cgroups@vger.kernel.org, DRI Development <dri-devel@lists.freedesktop.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Daniel Vetter <daniel.vetter@intel.com>

QXZvaWRzIHRoZSBuZWVkIHRvIGludmVydCB0aGUgY29uZGl0aW9uIGluc3RlYWQgb2YgdGhlIG9w
ZW4tY29kZWQKdmVyc2lvbi4KClNpZ25lZC1vZmYtYnk6IERhbmllbCBWZXR0ZXIgPGRhbmllbC52
ZXR0ZXJAaW50ZWwuY29tPgpDYzogVGVqdW4gSGVvIDx0akBrZXJuZWwub3JnPgpDYzogTGkgWmVm
YW4gPGxpemVmYW5AaHVhd2VpLmNvbT4KQ2M6IEpvaGFubmVzIFdlaW5lciA8aGFubmVzQGNtcHhj
aGcub3JnPgpDYzogY2dyb3Vwc0B2Z2VyLmtlcm5lbC5vcmcKLS0tCiBpbmNsdWRlL2xpbnV4L2Nn
cm91cC5oIHwgNCArLS0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDMgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jZ3JvdXAuaCBiL2luY2x1ZGUvbGlu
dXgvY2dyb3VwLmgKaW5kZXggYzlmZGY2ZjU3OTEzLi42NjZjNjIwMGQ2MWQgMTAwNjQ0Ci0tLSBh
L2luY2x1ZGUvbGludXgvY2dyb3VwLmgKKysrIGIvaW5jbHVkZS9saW51eC9jZ3JvdXAuaApAQCAt
Mjg3LDkgKzI4Nyw3IEBAIHZvaWQgY3NzX3Rhc2tfaXRlcl9lbmQoc3RydWN0IGNzc190YXNrX2l0
ZXIgKml0KTsKIAlmb3IgKChsZWFkZXIpID0gY2dyb3VwX3Rhc2tzZXRfZmlyc3QoKHRzZXQpLCAm
KGRzdF9jc3MpKTsJXAogCSAgICAgKGxlYWRlcik7CQkJCQkJCVwKIAkgICAgIChsZWFkZXIpID0g
Y2dyb3VwX3Rhc2tzZXRfbmV4dCgodHNldCksICYoZHN0X2NzcykpKQlcCi0JCWlmICgobGVhZGVy
KSAhPSAobGVhZGVyKS0+Z3JvdXBfbGVhZGVyKQkJCVwKLQkJCTsJCQkJCQlcCi0JCWVsc2UKKwkJ
Zm9yX2VhY2hfaWYgKChsZWFkZXIpID09IChsZWFkZXIpLT5ncm91cF9sZWFkZXIpCiAKIC8qCiAg
KiBJbmxpbmUgZnVuY3Rpb25zLgotLSAKMi4xOC4wCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBs
aXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1h
bi9saXN0aW5mby9kcmktZGV2ZWwK
