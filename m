From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v4 3/3] docs/cgroup: add entry for misc.events
Date: Fri, 17 Sep 2021 20:44:16 +0800
Message-ID: <41b702e0e9ae88b5806f4253ed30e2f2c8e70776.1631881726.git.brookxu@tencent.com>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631881726.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=EiFaqxi/eMHI447ra+FWT3fM5Oq58Q8AgI3FLcLHOAk=;
        b=lE/hBth4NSTIJYnhOU8/q6QQoji0WAiiMiQlUlzCPKOIEiuWqYCdA76+fB9r00FtqV
         6osBE4goQE2YTrzuignkcFCXu2VjGV4A7zRu/JuA8GzPM7AgzsaEw0HEXeWjnoLWH8BS
         2zrW3Ek2IwTGZCuKgk3Hdjpmo21EZ8mwxXXnQiQuuNQBvaIATtR+TYLFZTU9EJ+Mq/vb
         DChLAY/+A8PVej5zTgHYxg7ksBLoeIBh8mXbkshfrQViBP3Ncxm3/JRLCD4Q7ZiyX+G6
         ecsYLjFNcsqS3HRSmBijqBrDQP7De4FGMNFW5zXWtxC9dBzSDbgapbg/UNvgGgtNVrGF
         +Pyg==
In-Reply-To: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631881726.git.brookxu@tencent.com>
In-Reply-To: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631881726.git.brookxu@tencent.com>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631881726.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: vipinsh@google.com, mkoutny@suse.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

RnJvbTogQ2h1bmd1YW5nIFh1IDxicm9va3h1QHRlbmNlbnQuY29tPgoKQWRkZWQgZGVzY3JpcHRp
b25zIG9mIG1pc2MuZXZlbnRzLgoKU2lnbmVkLW9mZi1ieTogQ2h1bmd1YW5nIFh1IDxicm9va3h1
QHRlbmNlbnQuY29tPgpSZXZpZXdlZC1ieTogTWljaGFsIEtvdXRuw70gPG1rb3V0bnlAc3VzZS5j
b20+Ci0tLQogRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9jZ3JvdXAtdjIucnN0IHwgMTAgKysr
KysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9E
b2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2Nncm91cC12Mi5yc3QgYi9Eb2N1bWVudGF0aW9uL2Fk
bWluLWd1aWRlL2Nncm91cC12Mi5yc3QKaW5kZXggYmFiYmUwNC4uZTdhY2M1NSAxMDA2NDQKLS0t
IGEvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9jZ3JvdXAtdjIucnN0CisrKyBiL0RvY3VtZW50
YXRpb24vYWRtaW4tZ3VpZGUvY2dyb3VwLXYyLnJzdApAQCAtMjMxMCw2ICsyMzEwLDE2IEBAIE1p
c2NlbGxhbmVvdXMgY29udHJvbGxlciBwcm92aWRlcyAzIGludGVyZmFjZSBmaWxlcy4gSWYgdHdv
IG1pc2MgcmVzb3VyY2VzIChyZXNfCiAgICAgICAgIExpbWl0cyBjYW4gYmUgc2V0IGhpZ2hlciB0
aGFuIHRoZSBjYXBhY2l0eSB2YWx1ZSBpbiB0aGUgbWlzYy5jYXBhY2l0eQogICAgICAgICBmaWxl
LgogCisgIG1pc2MuZXZlbnRzCisJQSByZWFkLW9ubHkgZmxhdC1rZXllZCBmaWxlIHdoaWNoIGV4
aXN0cyBvbiBub24tcm9vdCBjZ3JvdXBzLiBUaGUKKwlmb2xsb3dpbmcgZW50cmllcyBhcmUgZGVm
aW5lZC4gVW5sZXNzIHNwZWNpZmllZCBvdGhlcndpc2UsIGEgdmFsdWUKKwljaGFuZ2UgaW4gdGhp
cyBmaWxlIGdlbmVyYXRlcyBhIGZpbGUgbW9kaWZpZWQgZXZlbnQuIEFsbCBmaWVsZHMgaW4KKwl0
aGlzIGZpbGUgYXJlIGhpZXJhcmNoaWNhbC4KKworCSAgbWF4CisJCVRoZSBudW1iZXIgb2YgdGlt
ZXMgdGhlIGNncm91cCdzIHJlc291cmNlIHVzYWdlIHdhcworCQlhYm91dCB0byBnbyBvdmVyIHRo
ZSBtYXggYm91bmRhcnkuCisKIE1pZ3JhdGlvbiBhbmQgT3duZXJzaGlwCiB+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fgogCi0tIAoxLjguMy4xCgo=
