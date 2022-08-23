From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: Fix race condition at rebind_subsystems()
Date: Tue, 23 Aug 2022 13:03:58 +0530
Message-ID: <45e18c45-1c09-863a-65a0-3ae03ba4f859@quicinc.com>
References: <20220823054148.29346-1-Jing-Ting.Wu@mediatek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=3d/ElBXcPYxKWyW49KyvVjAnEwq+qBCx+4YLXDcWY5k=;
 b=SaDJhOAG/4gQ0onXSxFKM92KFD5cJU3jtNBuWjvn4DFo87n6AM77r46kFw39bsFSQ8ai
 E9JDHh31e8YzMtCepEro/qOb88neXAtYAFOMXm/0HsZfPRfaVtWc++ztIcqpXiALHp1e
 5QS8NFLtCCDILYcwluQnJERkJb5r9pcWJy85KRzM4qTt3JAsnUGdrAZCf+Vz/UZZlRRz
 sVljtmbkPISxsK+7XtLLznl2zglxSGhhTsoPjtfiBco/CXBoeH2kwA24cM88YK4pfE+J
 +A1DiBli75rgxkwScHDJiEpNu527ye6an99ivw2sABtOa1iDw+eU7O9AIFPtca+c3+DU 3A== 
Content-Language: en-US
In-Reply-To: <20220823054148.29346-1-Jing-Ting.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"; format="flowed"
To: Jing-Ting Wu <Jing-Ting.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jonathan.JMChen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Lixiong.Liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, Wenju.Xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

CgpPbiA4LzIzLzIwMjIgMTE6MTEgQU0sIEppbmctVGluZyBXdSB3cm90ZToKPiBSb290IGNhdXNl
Ogo+IFRoZSByZWJpbmRfc3Vic3lzdGVtcygpIGlzIG5vIGxvY2sgaGVsZCB3aGVuIG1vdmUgY3Nz
IG9iamVjdCBmcm9tIEEKPiBsaXN0IHRvIEIgbGlzdCx0aGVuIGxldCBCJ3MgaGVhZCBiZSB0cmVh
dGVkIGFzIGNzcyBub2RlIGF0Cj4gbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UoKS4KPiAKPiBTb2x1
dGlvbjoKPiBBZGQgZ3JhY2UgcGVyaW9kIGJlZm9yZSBpbnZhbGlkYXRpbmcgdGhlIHJlbW92ZWQg
cnN0YXRfY3NzX25vZGUuCj4gCj4gUmVwb3J0ZWQtYnk6IEppbmctVGluZyBXdSA8amluZy10aW5n
Lnd1LU51UzVMdk5VcGNKV2swSHRpazNKL3dAcHVibGljLmdtYW5lLm9yZz4KPiBTdWdnZXN0ZWQt
Ynk6IE1pY2hhbCBLb3V0bsO9IDxta291dG55LUlCaTlSRy9iNjdrQHB1YmxpYy5nbWFuZS5vcmc+
Cj4gU2lnbmVkLW9mZi1ieTogSmluZy1UaW5nIFd1IDxqaW5nLXRpbmcud3UtTnVTNUx2TlVwY0pX
azBIdGlrM0ovd0BwdWJsaWMuZ21hbmUub3JnPgo+IFRlc3RlZC1ieTogSmluZy1UaW5nIFd1IDxq
aW5nLXRpbmcud3UtTnVTNUx2TlVwY0pXazBIdGlrM0ovd0BwdWJsaWMuZ21hbmUub3JnPgo+IExp
bms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWFybS1rZXJuZWwvZDhmMGJjNWUyZmI2
ZWQyNTlmOTMzNGM4MzI3OWI0YzAxMTI4M2M0MS5jYW1lbC1OdVM1THZOVXBjSldrMEh0aWszSi93
QHB1YmxpYy5nbWFuZS5vcmcvVC8KPiAtLS0KPiAgIGtlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgfCAx
ICsKPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo+IAo+IGRpZmYgLS1naXQgYS9r
ZXJuZWwvY2dyb3VwL2Nncm91cC5jIGIva2VybmVsL2Nncm91cC9jZ3JvdXAuYwo+IGluZGV4IGZm
YWNjZDYzNzNmMS4uMGQwYzk1OTk2NmVkIDEwMDY0NAo+IC0tLSBhL2tlcm5lbC9jZ3JvdXAvY2dy
b3VwLmMKPiArKysgYi9rZXJuZWwvY2dyb3VwL2Nncm91cC5jCj4gQEAgLTE4MjAsNiArMTgyMCw3
IEBAIGludCByZWJpbmRfc3Vic3lzdGVtcyhzdHJ1Y3QgY2dyb3VwX3Jvb3QgKmRzdF9yb290LCB1
MTYgc3NfbWFzaykKPiAgIAo+ICAgCQlpZiAoc3MtPmNzc19yc3RhdF9mbHVzaCkgewo+ICAgCQkJ
bGlzdF9kZWxfcmN1KCZjc3MtPnJzdGF0X2Nzc19ub2RlKTsKPiArCQkJc3luY2hyb25pemVfcmN1
KCk7Cj4gICAJCQlsaXN0X2FkZF9yY3UoJmNzcy0+cnN0YXRfY3NzX25vZGUsCj4gICAJCQkJICAg
ICAmZGNncnAtPnJzdGF0X2Nzc19saXN0KTsKPiAgIAkJfQoKR29vZCBjYXRjaC4KCkFja2VkLWJ5
OiBNdWtlc2ggT2poYSA8cXVpY19tb2poYS1qZkpOYTJwMWdIMUJEZ2pLN3k3VFVRQHB1YmxpYy5n
bWFuZS5vcmc+CgotTXVrZXNoCgo=
