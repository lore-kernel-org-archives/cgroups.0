From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH 0/3] cgroup: Iterate tasks that did not finish do_exit()
Date: Fri, 17 Jan 2020 16:15:30 +0100
Message-ID: <20200117151533.12381-1-mkoutny@suse.com>
References: <20200116043612.52782-1-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200116043612.52782-1-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: cgroups@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, alex.shi@linux.alibaba.com, guro@fb.com, kernel-team@android.com, linger.lee@mediatek.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com, shuah@kernel.org, tomcherry@google.com

SGksCkkgd2FzIGxvb2tpbmcgaW50byB0aGUgaXNzdWUgYW5kIGNhbWUgdXAgd2l0aCBhbiBhbHRl
cm5hdGl2ZSBzb2x1dGlvbiB0aGF0CmNoYW5nZXMgdGFzayBpdGVyYXRpb24gdG8gYmUgY29uc2lz
dGVudCB3aXRoIGNncm91cF9pc19wb3B1bGF0ZWQoKSBjaGVjayBhbmQKbW92aW5nIHRoZSByZXNw
b25zaWJpbGl0eSB0byBjaGVjayBQRl9FWElUSU5HIG9uIHRoZSBjb25zdW1lcnMgb2YgaXRlcmF0
b3IgQVBJLgoKSSBoYXZlbid0IGNoZWNrIHlvdXIgYXBwcm9hY2ggdGhvcm91Z2hseSwgaG93ZXZl
ciwgaXQgYXBwZWFycyB0byBtZSBpdApjb21wbGljYXRlcyAoYWxyZWFkeSBub24tdHJpdmlhbCkg
Y2dyb3VwIGRlc3RydWN0aW9uIHBhdGguIEkgcmFuIHlvdXIgc2VsZnRlc3QKb24gdGhlIGl0ZXJh
dG9ycyBhcHByb2FjaCBhbmQgaXQgcHJvdmVkIHdvcmtpbmcuCgpNaWNoYWwgS291dG7DvSAoMik6
CiAgY2dyb3VwOiBVbmlmeSBjc3Nfc2V0IHRhc2sgbGlzdHMKICBjZ3JvdXA6IEl0ZXJhdGUgdGFz
a3MgdGhhdCBkaWQgbm90IGZpbmlzaCBkb19leGl0KCkKClN1cmVuIEJhZ2hkYXNhcnlhbiAoMSk6
CiAga3NlbGZ0ZXN0L2Nncm91cDogYWRkIGNncm91cCBkZXN0cnVjdGlvbiB0ZXN0CgogaW5jbHVk
ZS9saW51eC9jZ3JvdXAtZGVmcy5oICAgICAgICAgICAgICAgIHwgIDE1ICsrLQogaW5jbHVkZS9s
aW51eC9jZ3JvdXAuaCAgICAgICAgICAgICAgICAgICAgIHwgICA0ICstCiBrZXJuZWwvY2dyb3Vw
L2Nncm91cC5jICAgICAgICAgICAgICAgICAgICAgfCAgODYgKysrKysrKystLS0tLS0tLQoga2Vy
bmVsL2Nncm91cC9kZWJ1Zy5jICAgICAgICAgICAgICAgICAgICAgIHwgIDE2ICsrLQogdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL3Rlc3RfY29yZS5jIHwgMTEzICsrKysrKysrKysrKysr
KysrKysrKwogNSBmaWxlcyBjaGFuZ2VkLCAxNzYgaW5zZXJ0aW9ucygrKSwgNTggZGVsZXRpb25z
KC0pCgotLSAKMi4yNC4xCgo=
