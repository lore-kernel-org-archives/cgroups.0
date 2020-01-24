From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH v2 0/3] cgroup: Iterate tasks that did not finish do_exit()
Date: Fri, 24 Jan 2020 12:40:14 +0100
Message-ID: <20200124114017.8363-1-mkoutny@suse.com>
References: <20200120145635.GA30904@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:To:From:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=fBu5P9PuWyVB38uP0Um5ZriQDoJKHmS/un+Q3IWYSRE=; b=BLHOFG5ibVFQLT
	3oDv9SuW/5Dz/zCBtCFGDlCCg37VJUPoA9m70gaj5pnLw0sHioKYGN9l4EuLg/aryaeZTNQUOmq55
	LA8nHk8jBJHvobsrqHPuVsdKY4VWbwyIKrGZYxKK6ur0c3yywfalTW7mSZwWq8CYqoIOniyR1ptsP
	WY5ynkm5Qfmn8KTuHGQD8Zh1dYmDDsHq5uYGUjjp8A7rghnU3cC/uFbrpIgmWhBYlpicEzB8mNIjl
	Rs8wXaYDrQcmDlazNbOu2sFtZ1bn94Ix1mYSlTfiAHSX5sCnDGv0bOVUaqo8UeX3IkW3Pu0YOkg7h
	D0id3T4Rs4IIy7oE17kA==;
In-Reply-To: <20200120145635.GA30904@blackbody.suse.cz>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>, 
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>, 
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org
Content-Type: text/plain; charset="macroman"
To: cgroups@vger.kernel.org
Cc: linger.lee@mediatek.com, tomcherry@google.com, shuah@kernel.org, linux-kernel@vger.kernel.org, surenb@google.com, tj@kernel.org, lizefan@huawei.com, linux-mediatek@lists.infradead.org, linux-kselftest@vger.kernel.org, hannes@cmpxchg.org, matthias.bgg@gmail.com, alex.shi@linux.alibaba.com, kernel-team@android.com, guro@fb.com, linux-arm-kernel@lists.infradead.org

SGksCnRoYW5rcyBmb3IgeW91ciBmZWVkYmFjay4gSSdtIHNlbmRpbmcgdXBkYXRlZCBzb2x1dGlv
biB0aGF0IGNoYW5nZXMgdGFzawppdGVyYXRpb24gdG8gYmUgY29uc2lzdGVudCB3aXRoIGNncm91
cF9pc19wb3B1bGF0ZWQoKSBjaGVjayBhbmQgbW92aW5nIHRoZQpyZXNwb25zaWJpbGl0eSB0byBj
aGVjayBQRl9FWElUSU5HIG9uIHRoZSBjb25zdW1lcnMgb2YgaXRlcmF0b3IgQVBJLgoKQ2hhbmdl
cyBmcm9tIHYxCi0gdjE6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMDAxMTcxNTE1
MzMuMTIzODEtMS1ta291dG55QHN1c2UuY29tLwotIFN3YXAgdGhlIGZpeGluZyBhbmQgcmVmYWN0
b3JpbmcgcGF0Y2ggKGluIG9yZGVyIHRvIG1ha2UgdGhlIGZpeCBlYXNpZXIgZm9yCiAgYmFja3Bv
cnQpCi0gRG9uJ3QgaW50cm9kdWNlIHRhc2tzIGxpc3RzIGFycmF5IGJlY2F1c2Ugb2YgdW5uZWNl
c3NhcmlseSBsb25nIGFjY2VzcyBjb2RlCi0gRml4IGNvbW1lbnQgaW4gc2VsZnRlc3QKLSBJIGxl
YXZlIHRoZSBDQzpzdGFibGUgb24gZGlzY3JldGlvbiBvZiB0aGUgbWFpbnRhaW5lcgoKTWljaGFs
IEtvdXRuw70gKDIpOgogIGNncm91cDogSXRlcmF0ZSB0YXNrcyB0aGF0IGRpZCBub3QgZmluaXNo
IGRvX2V4aXQoKQogIGNncm91cDogQ2xlYW4gdXAgY3NzX3NldCB0YXNrIHRyYXZlcnNhbAoKU3Vy
ZW4gQmFnaGRhc2FyeWFuICgxKToKICBrc2VsZnRlc3QvY2dyb3VwOiBhZGQgY2dyb3VwIGRlc3Ry
dWN0aW9uIHRlc3QKCiBpbmNsdWRlL2xpbnV4L2Nncm91cC5oICAgICAgICAgICAgICAgICAgICAg
fCAgIDQgKy0KIGtlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgICAgICAgICAgICAgICAgICAgICB8ICA2
MCArKysrKystLS0tLQogdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL3Rlc3RfY29yZS5j
IHwgMTEzICsrKysrKysrKysrKysrKysrKysrKwogMyBmaWxlcyBjaGFuZ2VkLCAxNDYgaW5zZXJ0
aW9ucygrKSwgMzEgZGVsZXRpb25zKC0pCgotLSAKMi4yNC4xCgoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWlsaW5nIGxp
c3QKbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZy
YWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
