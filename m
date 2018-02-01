From: Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH RFC v2 2/7] kernfs: Export kernfs_get_inode
Date: Thu,  1 Feb 2018 11:53:10 -0800
Message-ID: <20180201195315.4956-3-matthew.d.roper@intel.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180201195315.4956-1-matthew.d.roper@intel.com>
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
To: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

RHJpdmVycyBtYXkgd2lzaCB0byBhY2Nlc3MgYSBjZ3JvdXAncyBpbm9kZSB0byBwZXJmb3JtIHBl
cm1pc3Npb24gY2hlY2tzIG9uCmRyaXZlci1zcGVjaWZpYyBvcGVyYXRpb25zLgoKQ2M6IFRlanVu
IEhlbyA8dGpAa2VybmVsLm9yZz4KQ2M6IGNncm91cHNAdmdlci5rZXJuZWwub3JnClNpZ25lZC1v
ZmYtYnk6IE1hdHQgUm9wZXIgPG1hdHRoZXcuZC5yb3BlckBpbnRlbC5jb20+Ci0tLQogZnMva2Vy
bmZzL2lub2RlLmMgfCAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQoKZGlmZiAt
LWdpdCBhL2ZzL2tlcm5mcy9pbm9kZS5jIGIvZnMva2VybmZzL2lub2RlLmMKaW5kZXggYTM0MzAz
OTgxZGViLi5lMWU4YTA0MDRjNWIgMTAwNjQ0Ci0tLSBhL2ZzL2tlcm5mcy9pbm9kZS5jCisrKyBi
L2ZzL2tlcm5mcy9pbm9kZS5jCkBAIC0yNzIsNiArMjcyLDcgQEAgc3RydWN0IGlub2RlICprZXJu
ZnNfZ2V0X2lub2RlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBrZXJuZnNfbm9kZSAq
a24pCiAKIAlyZXR1cm4gaW5vZGU7CiB9CitFWFBPUlRfU1lNQk9MKGtlcm5mc19nZXRfaW5vZGUp
OwogCiAvKgogICogVGhlIGtlcm5mc19ub2RlIHNlcnZlcyBhcyBib3RoIGFuIGlub2RlIGFuZCBh
IGRpcmVjdG9yeSBlbnRyeSBmb3IKLS0gCjIuMTQuMwoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxA
bGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxt
YW4vbGlzdGluZm8vZHJpLWRldmVsCg==
