From: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Skip test_mem_cgroup_node_reclaimable()
 when no MAX_NUMNODES or not more than 1
Date: Sun, 07 Dec 2014 21:53:47 +0800
Message-ID: <51ggckac0utecg6rqx48nkmc.1417960383505@email.android.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:subject:message-id:from:to:cc:mime-version:content-type
         :content-transfer-encoding;
        bh=HJ/H6JC8FqnnudXkRUbH9aj7/zhTZEO6I/h8/826r+Q=;
        b=RQogKmJ+kFKgzRMew5QCveIkt6nxp4GCcHEBlqQ4NXM37V6Kqu0I1503wPsI+/B8oi
         0V3pTC+xlE0UA/zJk9M8qD6HDwVJ0VruzOv/9cO+XUF8JnK9WdcThNSAVxR3sxLsfVfd
         m1mMJ2RUbqi5DgjldBRvqhlYYF5ee33+uIRSx1IyJRAWaF/Si10+o5oWu67pwWmph+6e
         lqeiig78rqiLU3oAfPZ7Tm0fX8HS+BiWcjjYLeSPEC/HuhLnXKhB/7CSpOWS0YlCgPpN
         TSDpVEVQ+/lD7oPJ/a4IZG32THWBcMpoI3nA6+PqOge3GqoqzCDSM9uwITS+S2FZJqif
         56Cg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, " linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

T0ssIHRoYW5rcy4gSSBzaGFsbCB0cnkgdG8gc2VuZCBhbm90aGVyIHBhdGNoIHRvIHVwc3RyZWFt
IGtlcm5lbAp3aXRoaW4gdGhpcyBtb250aC4KClNlbmQgZnJvbSBMZW5vdm8gQTc4OHQuCgpNaWNo
YWwgSG9ja28gPG1ob2Nrb0BzdXNlLmN6PiB3cm90ZToKCj5IaSwKPnRoaXMgaGFzIGJlZW4gZml4
ZWQgbGFzdCB3ZWVrIGFscmVhZHkKPmh0dHA6Ly9tYXJjLmluZm8vP2w9bGludXgtbW0mbT0xNDE3
NTE4NDc3MTA4NjQmdz0yCj4KPk9uIFNhdCAwNi0xMi0xNCAwNjoyNzo1NywgQ2hlbiBHYW5nIHdy
b3RlOgo+PiB0ZXN0X21lbV9jZ3JvdXBfbm9kZV9yZWNsYWltYWJsZSgpIGlzIG9ubHkgdXNlZCB3
aGVuICJNQVhfTlVNTk9ERVMgPiAxIiwKPj4gc28gbW92ZSBpdCBpbnRvIHJlbGF0ZWQgcXVvdGUu
Cj4+IAo+PiBUaGUgcmVsYXRlZCB3YXJuaW5nICh3aXRoIGFsbG1vZGNvbmZpZyB1bmRlciBwYXJp
c2MpOgo+PiAKPj4gICAgIENDICAgICAgbW0vbWVtY29udHJvbC5vCj4+ICAgbW0vbWVtY29udHJv
bC5jOjE2Mjk6MTM6IHdhcm5pbmc6ICd0ZXN0X21lbV9jZ3JvdXBfbm9kZV9yZWNsYWltYWJsZScg
ZGVmaW5lZCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWZ1bmN0aW9uXQo+PiAgICBzdGF0aWMgYm9v
bCB0ZXN0X21lbV9jZ3JvdXBfbm9kZV9yZWNsYWltYWJsZShzdHJ1Y3QgbWVtX2Nncm91cCAqbWVt
Y2csCj4+ICAgICAgICAgICAgICAgIF4KPj4gCj4+IFNpZ25lZC1vZmYtYnk6IENoZW4gR2FuZyA8
Z2FuZy5jaGVuLjVpNWpAZ21haWwuY29tPgo+PiAtLS0KPj4gIG1tL21lbWNvbnRyb2wuYyB8IDIg
Ky0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+PiAK
Pj4gZGlmZiAtLWdpdCBhL21tL21lbWNvbnRyb2wuYyBiL21tL21lbWNvbnRyb2wuYwo+PiBpbmRl
eCBjNmFjNTBlLi5kNTM4YjA4IDEwMDY0NAo+PiAtLS0gYS9tbS9tZW1jb250cm9sLmMKPj4gKysr
IGIvbW0vbWVtY29udHJvbC5jCj4+IEBAIC0xNjE2LDYgKzE2MTYsNyBAQCBzdGF0aWMgdm9pZCBt
ZW1fY2dyb3VwX291dF9vZl9tZW1vcnkoc3RydWN0IG1lbV9jZ3JvdXAgKm1lbWNnLCBnZnBfdCBn
ZnBfbWFzaywKPj4gIAkJCSBOVUxMLCAiTWVtb3J5IGNncm91cCBvdXQgb2YgbWVtb3J5Iik7Cj4+
ICB9Cj4+ICAKPj4gKyNpZiBNQVhfTlVNTk9ERVMgPiAxCj4+ICAvKioKPj4gICAqIHRlc3RfbWVt
X2Nncm91cF9ub2RlX3JlY2xhaW1hYmxlCj4+ICAgKiBAbWVtY2c6IHRoZSB0YXJnZXQgbWVtY2cK
Pj4gQEAgLTE2MzgsNyArMTYzOSw2IEBAIHN0YXRpYyBib29sIHRlc3RfbWVtX2Nncm91cF9ub2Rl
X3JlY2xhaW1hYmxlKHN0cnVjdCBtZW1fY2dyb3VwICptZW1jZywKPj4gIAlyZXR1cm4gZmFsc2U7
Cj4+ICAKPj4gIH0KPj4gLSNpZiBNQVhfTlVNTk9ERVMgPiAxCj4+ICAKPj4gIC8qCj4+ICAgKiBB
bHdheXMgdXBkYXRpbmcgdGhlIG5vZGVtYXNrIGlzIG5vdCB2ZXJ5IGdvb2QgLSBldmVuIGlmIHdl
IGhhdmUgYW4gZW1wdHkKPj4gLS0gCj4+IDEuOS4zCj4KPi0tIAo+TWljaGFsIEhvY2tvCj5TVVNF
IExhYnMK
