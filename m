From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH] cgroup: rstat: Mark benign data race to silence KCSAN
Date: Wed,  3 Nov 2021 17:58:45 +0100
Message-ID: <20211103165845.38226-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635958795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CZTso4db4Dar0whtzqs3akzB0bY3rGVZ6G9gzNMkSvI=;
        b=m+8PyeoG2r9EvepaoRjSnJhUauQo7s69RvD++FEIn8UMwIML+is4JVtNWHsifUCGI4EOAp
        EZK6n+P42yGr8EYHTRj3zKa6U16OmB6na3SLHMU4VAD69/2ptgtGqqG9d0n39liyYw68S0
        XMxf3jwmqkMCTZZFj4aNWh7KVmKR4j8=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: cgroups@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Hao Sun <sunhao.th@gmail.com>, linux-kernel@vger.kernel.org

VGhlcmUgaXMgYSByYWNlIGJldHdlZW4gdXBkYXRlcnMgYW5kIGZsdXNoZXJzIChmbHVzaCBjYW4g
cG9zc2libHkgbWlzcwp0aGUgbGF0ZXN0IHVwZGF0ZShzKSkuIFRoaXMgaXMgZXhwZWN0ZWQgYXMg
ZXhwbGFpbmVkIGluCmNncm91cF9yc3RhdF91cGRhdGVkKCkgY29tbWVudCwgYWRkIGFsc28gbWFj
aGluZSByZWFkYWJsZSBhbm5vdGF0aW9uIHNvCnRoYXQgS0NTQU4gcmVzdWx0cyBhcmVuJ3Qgbm9p
c3kuCgpSZXBvcnRlZC1ieTogSGFvIFN1biA8c3VuaGFvLnRoQGdtYWlsLmNvbT4KTGluazogaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci9DQUNrQmpzYlBWZGt1Yj1lLUUtcDFXQk9MeFM1MTVpdGgt
NTNTRmRtRkhXVl9RTW80MHdAbWFpbC5nbWFpbC5jb20KU3VnZ2VzdGVkLWJ5OiBIYW8gU3VuIDxz
dW5oYW8udGhAZ21haWwuY29tPgoKU2lnbmVkLW9mZi1ieTogTWljaGFsIEtvdXRuw70gPG1rb3V0
bnlAc3VzZS5jb20+Ci0tLQoga2VybmVsL2Nncm91cC9yc3RhdC5jIHwgMiArLQogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpIYW8gd2FzIHNpbGVudCBpbiB0
aGUgcmVwb3J0aW5nIG1haWwgdGhyZWFkLCBzbyBJJ20gc2VuZGluZyB0aGUKc3VnZ2VzdGVkIGFu
bm90YXRpbmcgcGF0Y2guCgpkaWZmIC0tZ2l0IGEva2VybmVsL2Nncm91cC9yc3RhdC5jIGIva2Vy
bmVsL2Nncm91cC9yc3RhdC5jCmluZGV4IDE0ODY3NjhmMjMxOC4uMWFiZTc0MTE0NTI3IDEwMDY0
NAotLS0gYS9rZXJuZWwvY2dyb3VwL3JzdGF0LmMKKysrIGIva2VybmVsL2Nncm91cC9yc3RhdC5j
CkBAIC0zNSw3ICszNSw3IEBAIHZvaWQgY2dyb3VwX3JzdGF0X3VwZGF0ZWQoc3RydWN0IGNncm91
cCAqY2dycCwgaW50IGNwdSkKIAkgKiBpbnN0ZWFkIG9mIE5VTEwsIHdlIGNhbiB0ZWxsIHdoZXRo
ZXIgQGNncnAgaXMgb24gdGhlIGxpc3QgYnkKIAkgKiB0ZXN0aW5nIHRoZSBuZXh0IHBvaW50ZXIg
Zm9yIE5VTEwuCiAJICovCi0JaWYgKGNncm91cF9yc3RhdF9jcHUoY2dycCwgY3B1KS0+dXBkYXRl
ZF9uZXh0KQorCWlmIChkYXRhX3JhY2UoY2dyb3VwX3JzdGF0X2NwdShjZ3JwLCBjcHUpLT51cGRh
dGVkX25leHQpKQogCQlyZXR1cm47CiAKIAlyYXdfc3Bpbl9sb2NrX2lycXNhdmUoY3B1X2xvY2ss
IGZsYWdzKTsKLS0gCjIuMzMuMQoK
