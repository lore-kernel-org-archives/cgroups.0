From: Kenny Ho <Kenny.Ho@amd.com>
Subject: [RFC PATCH v3 03/11] drm/amdgpu: Register AMD devices for DRM cgroup
Date: Wed, 26 Jun 2019 11:05:14 -0400
Message-ID: <20190626150522.11618-4-Kenny.Ho@amd.com>
References: <20190626150522.11618-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190626150522.11618-1-Kenny.Ho@amd.com>
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
To: y2kenny@gmail.com, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, tj@kernel.org, alexander.deucher@amd.com, christian.koenig@amd.com, joseph.greathouse@amd.com, jsparks@cray.com, lkaplan@cray.com
Cc: Kenny Ho <Kenny.Ho@amd.com>

Q2hhbmdlLUlkOiBJMzc1MGZjNjU3Yjk1NmI1Mjc1MGEzNmNiMzAzYzU0ZmE2YTI2NWI0NApTaWdu
ZWQtb2ZmLWJ5OiBLZW5ueSBIbyA8S2VubnkuSG9AYW1kLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9k
cm0vYW1kL2FtZGdwdS9hbWRncHVfa21zLmMgfCA0ICsrKysKIDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRn
cHVfa21zLmMgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfa21zLmMKaW5kZXgg
ZGE3YjRmZThhZGUzLi4yNTY4ZmQ3MzAxNjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9h
bWQvYW1kZ3B1L2FtZGdwdV9rbXMuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9h
bWRncHVfa21zLmMKQEAgLTI4LDYgKzI4LDcgQEAKICNpbmNsdWRlIDxkcm0vZHJtUC5oPgogI2lu
Y2x1ZGUgImFtZGdwdS5oIgogI2luY2x1ZGUgPGRybS9hbWRncHVfZHJtLmg+CisjaW5jbHVkZSA8
ZHJtL2RybV9jZ3JvdXAuaD4KICNpbmNsdWRlICJhbWRncHVfc2NoZWQuaCIKICNpbmNsdWRlICJh
bWRncHVfdXZkLmgiCiAjaW5jbHVkZSAiYW1kZ3B1X3ZjZS5oIgpAQCAtOTcsNiArOTgsNyBAQCB2
b2lkIGFtZGdwdV9kcml2ZXJfdW5sb2FkX2ttcyhzdHJ1Y3QgZHJtX2RldmljZSAqZGV2KQogCiAJ
YW1kZ3B1X2RldmljZV9maW5pKGFkZXYpOwogCisJZHJtY2dycF91bnJlZ2lzdGVyX2RldmljZShk
ZXYpOwogZG9uZV9mcmVlOgogCWtmcmVlKGFkZXYpOwogCWRldi0+ZGV2X3ByaXZhdGUgPSBOVUxM
OwpAQCAtMTQxLDYgKzE0Myw4IEBAIGludCBhbWRncHVfZHJpdmVyX2xvYWRfa21zKHN0cnVjdCBk
cm1fZGV2aWNlICpkZXYsIHVuc2lnbmVkIGxvbmcgZmxhZ3MpCiAJc3RydWN0IGFtZGdwdV9kZXZp
Y2UgKmFkZXY7CiAJaW50IHIsIGFjcGlfc3RhdHVzOwogCisJZHJtY2dycF9yZWdpc3Rlcl9kZXZp
Y2UoZGV2KTsKKwogI2lmZGVmIENPTkZJR19EUk1fQU1ER1BVX1NJCiAJaWYgKCFhbWRncHVfc2lf
c3VwcG9ydCkgewogCQlzd2l0Y2ggKGZsYWdzICYgQU1EX0FTSUNfTUFTSykgewotLSAKMi4yMS4w
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2
ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9s
aXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWw=
