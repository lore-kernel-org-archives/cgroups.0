From: Jing-Ting Wu <Jing-Ting.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/1] cgroup: Fix race condition at rebind_subsystems()
Date: Tue, 23 Aug 2022 13:41:46 +0800
Message-ID: <20220823054148.29346-1-Jing-Ting.Wu@mediatek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=fu5ShSj1KW2IHzRk7qvbTGi9RMnjs01NSv05MXGrhK8=;
        b=aOu84Ko+ZmisIdEvkENOEF+f2BgvowOG+nJ+fse8IxsZYPcUGq7b1E/Dh49mraBmkJ3ER0Fx99rz+FDumtpgsj738Tie50tgfNU9eSb2lYexOHkWc68/Ud16Z0y+0uPUngRfXzBX4T3Qheq2H4jVVQ6P9sZW8iMKjQu2uEAvNXY=;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Lixiong.Liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Wenju.Xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Jing-Ting Wu <Jing-Ting.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Jing-Ting Wu <jing-ting.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

Um9vdCBjYXVzZToKVGhlIHJlYmluZF9zdWJzeXN0ZW1zKCkgaXMgbm8gbG9jayBoZWxkIHdoZW4g
bW92ZSBjc3Mgb2JqZWN0IGZyb20gQQpsaXN0IHRvIEIgbGlzdCx0aGVuIGxldCBCJ3MgaGVhZCBi
ZSB0cmVhdGVkIGFzIGNzcyBub2RlIGF0Cmxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KCkuCgpTb2x1
dGlvbjoKQWRkIGdyYWNlIHBlcmlvZCBiZWZvcmUgaW52YWxpZGF0aW5nIHRoZSByZW1vdmVkIHJz
dGF0X2Nzc19ub2RlLgoKUmVwb3J0ZWQtYnk6IEppbmctVGluZyBXdSA8amluZy10aW5nLnd1LU51
UzVMdk5VcGNKV2swSHRpazNKL3dAcHVibGljLmdtYW5lLm9yZz4KU3VnZ2VzdGVkLWJ5OiBNaWNo
YWwgS291dG7DvSA8bWtvdXRueS1JQmk5UkcvYjY3a0BwdWJsaWMuZ21hbmUub3JnPgpTaWduZWQt
b2ZmLWJ5OiBKaW5nLVRpbmcgV3UgPGppbmctdGluZy53dS1OdVM1THZOVXBjSldrMEh0aWszSi93
QHB1YmxpYy5nbWFuZS5vcmc+ClRlc3RlZC1ieTogSmluZy1UaW5nIFd1IDxqaW5nLXRpbmcud3Ut
TnVTNUx2TlVwY0pXazBIdGlrM0ovd0BwdWJsaWMuZ21hbmUub3JnPgpMaW5rOiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9saW51eC1hcm0ta2VybmVsL2Q4ZjBiYzVlMmZiNmVkMjU5ZjkzMzRjODMy
NzliNGMwMTEyODNjNDEuY2FtZWwtTnVTNUx2TlVwY0pXazBIdGlrM0ovd0BwdWJsaWMuZ21hbmUu
b3JnL1QvCi0tLQoga2VybmVsL2Nncm91cC9jZ3JvdXAuYyB8IDEgKwogMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEva2VybmVsL2Nncm91cC9jZ3JvdXAuYyBiL2tl
cm5lbC9jZ3JvdXAvY2dyb3VwLmMKaW5kZXggZmZhY2NkNjM3M2YxLi4wZDBjOTU5OTY2ZWQgMTAw
NjQ0Ci0tLSBhL2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMKKysrIGIva2VybmVsL2Nncm91cC9jZ3Jv
dXAuYwpAQCAtMTgyMCw2ICsxODIwLDcgQEAgaW50IHJlYmluZF9zdWJzeXN0ZW1zKHN0cnVjdCBj
Z3JvdXBfcm9vdCAqZHN0X3Jvb3QsIHUxNiBzc19tYXNrKQogCiAJCWlmIChzcy0+Y3NzX3JzdGF0
X2ZsdXNoKSB7CiAJCQlsaXN0X2RlbF9yY3UoJmNzcy0+cnN0YXRfY3NzX25vZGUpOworCQkJc3lu
Y2hyb25pemVfcmN1KCk7CiAJCQlsaXN0X2FkZF9yY3UoJmNzcy0+cnN0YXRfY3NzX25vZGUsCiAJ
CQkJICAgICAmZGNncnAtPnJzdGF0X2Nzc19saXN0KTsKIAkJfQotLSAKMi4xOC4wCgo=
