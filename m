From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 1/4] cgroup: Honor caller's cgroup NS when resolving path
Date: Fri, 26 Aug 2022 18:52:35 +0200
Message-ID: <20220826165238.30915-2-mkoutny@suse.com>
References: <20220826165238.30915-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661532778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WiAwBHSULI+FTo4qfy3+3mhtUrcHKXxhKOkgtoN7B58=;
        b=WSzyydoTKHO/jQ41DTq4QqKpX9wedu7wj+UBK86xB8hAMsH2xhxwmBDemrXNbNqMB5cVpP
        B9jjLQ7d+HcXy0f6g0gbHQSA9Vc5mXoDqFV7DqPce9xNlmbD8kWI+aI/KqY7tcbHOu/cz1
        mabZKKw6kXLtxviHnH+FIyGiykTHERE=
In-Reply-To: <20220826165238.30915-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Muneendra Kumar <muneendra.kumar-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Y2dyb3VwX2dldF9mcm9tX3BhdGgoKSBpcyBub3Qgd2lkZWx5IHVzZWQgZnVuY3Rpb24uIEl0cyBj
YWxsZXJzIHByZXN1bWUKdGhlIHBhdGggaXMgcmVzb2x2ZWQgdW5kZXIgY2dyb3VwIG5hbWVzcGFj
ZS4gKFRoZXJlIGlzIG9uZSBjYWxsZXIKY3VycmVudGx5IGFuZCByZXNvbHZpbmcgaW4gaW5pdCBO
UyB3b24ndCBtYWtlIGhhcm0gKG5ldGZpbHRlcikuIEhvd2V2ZXIsCmZ1dHVyZSB1c2VycyBtYXkg
YmUgc3ViamVjdCB0byBkaWZmZXJlbnQgZWZmZWN0cyB3aGVuIHJlc29sdmluZwpnbG9iYWxseS4p
ClNpbmNlLCB0aGVyZSdzIGN1cnJlbnRseSBubyB1c2UgZm9yIHRoZSBnbG9iYWwgcmVzb2x1dGlv
biwgbW9kaWZ5IHRoZQpleGlzdGluZyBmdW5jdGlvbiB0byB0YWtlIGNncm91cCBOUyBpbnRvIGFj
Y291bnQuCgpGaXhlczogYTc5YTkwOGZkMmIwICgiY2dyb3VwOiBpbnRyb2R1Y2UgY2dyb3VwIG5h
bWVzcGFjZXMiKQpTaWduZWQtb2ZmLWJ5OiBNaWNoYWwgS291dG7DvSA8bWtvdXRueS1JQmk5Ukcv
YjY3a0BwdWJsaWMuZ21hbmUub3JnPgotLS0KIGtlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgfCA2ICsr
KysrLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlm
ZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgYi9rZXJuZWwvY2dyb3VwL2Nncm91cC5j
CmluZGV4IDVmNDUwMmFhMmIzYi4uMWE4YjUwZDE1ZWJmIDEwMDY0NAotLS0gYS9rZXJuZWwvY2dy
b3VwL2Nncm91cC5jCisrKyBiL2tlcm5lbC9jZ3JvdXAvY2dyb3VwLmMKQEAgLTY1OTgsOCArNjU5
OCwxMiBAQCBzdHJ1Y3QgY2dyb3VwICpjZ3JvdXBfZ2V0X2Zyb21fcGF0aChjb25zdCBjaGFyICpw
YXRoKQogewogCXN0cnVjdCBrZXJuZnNfbm9kZSAqa247CiAJc3RydWN0IGNncm91cCAqY2dycCA9
IEVSUl9QVFIoLUVOT0VOVCk7CisJc3RydWN0IGNncm91cCAqcm9vdF9jZ3JwOwogCi0Ja24gPSBr
ZXJuZnNfd2Fsa19hbmRfZ2V0KGNncnBfZGZsX3Jvb3QuY2dycC5rbiwgcGF0aCk7CisJc3Bpbl9s
b2NrX2lycSgmY3NzX3NldF9sb2NrKTsKKwlyb290X2NncnAgPSBjdXJyZW50X2NnbnNfY2dyb3Vw
X2Zyb21fcm9vdCgmY2dycF9kZmxfcm9vdCk7CisJa24gPSBrZXJuZnNfd2Fsa19hbmRfZ2V0KHJv
b3RfY2dycC0+a24sIHBhdGgpOworCXNwaW5fdW5sb2NrX2lycSgmY3NzX3NldF9sb2NrKTsKIAlp
ZiAoIWtuKQogCQlnb3RvIG91dDsKIAotLSAKMi4zNy4wCgo=
