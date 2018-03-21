From: Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH v4.5 8/8] drm/i915: Add context priority &
 priority offset to debugfs (v2)
Date: Wed, 21 Mar 2018 16:23:44 -0700
Message-ID: <20180321232344.20727-9-matthew.d.roper@intel.com>
References: <20180321232344.20727-1-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20180321232344.20727-1-matthew.d.roper@intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org

VXBkYXRlIGk5MTVfY29udGV4dF9zdGF0dXMgdG8gaW5jbHVkZSBwcmlvcml0eSBpbmZvcm1hdGlv
bi4KCnYyOgogLSBDbGFyaWZ5IHRoYXQgdGhlIG9mZnNldCBpcyBiYXNlZCBvbiBjZ3JvdXAgKENo
cmlzKQoKU2lnbmVkLW9mZi1ieTogTWF0dCBSb3BlciA8bWF0dGhldy5kLnJvcGVyQGludGVsLmNv
bT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2RlYnVnZnMuYyB8IDMgKysrCiAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJt
L2k5MTUvaTkxNV9kZWJ1Z2ZzLmMgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2RlYnVnZnMu
YwppbmRleCA3ODE2Y2Q1MzEwMGEuLmFjMmRhZDM4ZGVlMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9n
cHUvZHJtL2k5MTUvaTkxNV9kZWJ1Z2ZzLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkx
NV9kZWJ1Z2ZzLmMKQEAgLTE5NTksNiArMTk1OSw5IEBAIHN0YXRpYyBpbnQgaTkxNV9jb250ZXh0
X3N0YXR1cyhzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIHZvaWQgKnVudXNlZCkKIAkJc2VxX3B1dGMobSwg
Y3R4LT5yZW1hcF9zbGljZSA/ICdSJyA6ICdyJyk7CiAJCXNlcV9wdXRjKG0sICdcbicpOwogCisJ
CXNlcV9wcmludGYobSwgIlByaW9yaXR5ICVkIChjZ3JvdXAgb2Zmc2V0ID0gJWQpXG4iLAorCQkJ
ICAgY3R4LT5wcmlvcml0eSwgY3R4LT5wcmlvcml0eV9vZmZzZXQpOworCiAJCWZvcl9lYWNoX2Vu
Z2luZShlbmdpbmUsIGRldl9wcml2LCBpZCkgewogCQkJc3RydWN0IGludGVsX2NvbnRleHQgKmNl
ID0gJmN0eC0+ZW5naW5lW2VuZ2luZS0+aWRdOwogCi0tIAoyLjE0LjMKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QK
SW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9w
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeAo=
