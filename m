From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2 2/5] selftests: memcg: Expect no low events in unprotected sibling
Date: Wed, 18 May 2022 18:18:56 +0200
Message-ID: <20220518161859.21565-3-mkoutny@suse.com>
References: <20220518161859.21565-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652890752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uw2274IZaH6wHNxtdm16PTTjUp+I1Z5ZIJ2mltVHUsc=;
        b=T1leMHYScHQXCHXKxIS31MNB010gnhRdlHC98iwM804mCi19qxcC197VPWaP36dT0zb3wp
        0FBkGKRx1AWNjpOA5TzOlVxHWCH/c+KxuCpt0JLj85qx9CLmRWKvJNKOQ4bgeTS1NXGGh3
        YA71RSOsklz1HPm+85BDiDjO8A7stjo=
In-Reply-To: <20220518161859.21565-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

VGhpcyBpcyBlZmZlY3RpdmVseSBhIHJldmVydCBvZiBjb21taXQgY2RjNjk0NThhNWYzICgiY2dy
b3VwOiBhY2NvdW50CmZvciBtZW1vcnlfcmVjdXJzaXZlcHJvdCBpbiB0ZXN0X21lbWNnX2xvdygp
IikuIFRoZSBjYXNlIHRlc3RfbWVtY2dfbG93CndpbGwgZmFpbCB3aXRoIG1lbW9yeV9yZWN1cnNp
dmVwcm90IHVudGlsIHJlc29sdmVkIGluIHJlY2xhaW0KY29kZS4KSG93ZXZlciwgdGhpcyBwYXRj
aCBwcmVzZXJ2ZXMgdGhlIGV4aXN0aW5nIGhlbHBlcnMgYW5kIHZhcmlhYmxlcyBmb3IKbGF0ZXIg
dXNlcy4KClNpZ25lZC1vZmYtYnk6IE1pY2hhbCBLb3V0bsO9IDxta291dG55LUlCaTlSRy9iNjdr
QHB1YmxpYy5nbWFuZS5vcmc+ClJldmlld2VkLWJ5OiBEYXZpZCBWZXJuZXQgPHZvaWQtZ3E2ajJR
R0JpZkhieTNpVnJrWnEyQUBwdWJsaWMuZ21hbmUub3JnPgotLS0KIHRvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2Nncm91cC90ZXN0X21lbWNvbnRyb2wuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2Nncm91cC90ZXN0X21lbWNvbnRyb2wuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2Nncm91cC90ZXN0X21lbWNvbnRyb2wuYwppbmRleCBjMDEyZGI5ZDA3ZDYuLjQ5MjQ0MjU2
MzliMCAxMDA2NDQKLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL3Rlc3RfbWVt
Y29udHJvbC5jCisrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2Nncm91cC90ZXN0X21lbWNv
bnRyb2wuYwpAQCAtNTI4LDcgKzUyOCw3IEBAIHN0YXRpYyBpbnQgdGVzdF9tZW1jZ19sb3coY29u
c3QgY2hhciAqcm9vdCkKIAl9CiAKIAlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShjaGlsZHJl
bik7IGkrKykgewotCQlpbnQgbm9fbG93X2V2ZW50c19pbmRleCA9IGhhc19yZWN1cnNpdmVwcm90
ID8gMiA6IDE7CisJCWludCBub19sb3dfZXZlbnRzX2luZGV4ID0gMTsKIAogCQlvb20gPSBjZ19y
ZWFkX2tleV9sb25nKGNoaWxkcmVuW2ldLCAibWVtb3J5LmV2ZW50cyIsICJvb20gIik7CiAJCWxv
dyA9IGNnX3JlYWRfa2V5X2xvbmcoY2hpbGRyZW5baV0sICJtZW1vcnkuZXZlbnRzIiwgImxvdyAi
KTsKLS0gCjIuMzUuMwoK
