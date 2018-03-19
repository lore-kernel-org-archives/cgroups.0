From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] cgroup: cgroup_idr_lock can be static
Date: Mon, 19 Mar 2018 13:41:27 +0800
Message-ID: <20180319054127.GA6844@intel17>
References: <20180317000905.7091-2-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180317000905.7091-2-matthew.d.roper@intel.com>
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
To: Matt Roper <matthew.d.roper@intel.com>
Cc: Alexei Starovoitov <ast@fb.com>, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, kbuild-all@01.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

CkZpeGVzOiBkNmRlNGU3ZTllNjAgKCJjZ3JvdXA6IEFsbG93IHJlZ2lzdHJhdGlvbiBhbmQgbG9v
a3VwIG9mIGNncm91cCBwcml2YXRlIGRhdGEgKHYyKSIpClNpZ25lZC1vZmYtYnk6IEZlbmdndWFu
ZyBXdSA8ZmVuZ2d1YW5nLnd1QGludGVsLmNvbT4KLS0tCiBjZ3JvdXAuYyB8ICAgIDIgKy0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBh
L2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgYi9rZXJuZWwvY2dyb3VwL2Nncm91cC5jCmluZGV4IGM3
Nzg4MzAuLjlhZjYwODYgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMKKysrIGIv
a2VybmVsL2Nncm91cC9jZ3JvdXAuYwpAQCAtOTEsNyArOTEsNyBAQCBzdGF0aWMgREVGSU5FX0lE
UihjZ3JvdXBfcHJpdl9pZHIpOwogICogUHJvdGVjdHMgY2dyb3VwX2lkciwgY3NzX2lkciwgYW5k
IGNncm91cF9wcml2X2lkciBzbyB0aGF0IElEcyBjYW4gYmUKICAqIHJlbGVhc2VkIHdpdGhvdXQg
Z3JhYmJpbmcgY2dyb3VwX211dGV4LgogICovCi1ERUZJTkVfU1BJTkxPQ0soY2dyb3VwX2lkcl9s
b2NrKTsKK3N0YXRpYyBERUZJTkVfU1BJTkxPQ0soY2dyb3VwX2lkcl9sb2NrKTsKIAogLyoKICAq
IFByb3RlY3RzIGNncm91cF9maWxlLT5rbiBmb3IgIXNlbGYgY3NzZXMuICBJdCBzeW5jaHJvbml6
ZXMgbm90aWZpY2F0aW9ucwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3Rv
cC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRl
bC1nZngK
