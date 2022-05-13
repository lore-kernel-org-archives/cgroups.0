From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 2/4] selftests: memcg: Expect no low events in unprotected sibling
Date: Fri, 13 May 2022 19:18:09 +0200
Message-ID: <20220513171811.730-3-mkoutny@suse.com>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652462320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0s4UvaoqQhOvXVFcayQAcYm+9aULoAvV0U7raXaG3hU=;
        b=hAxfeK1s31Q67Yk2BZX0bHSa1CN0N4iFjkC2N/+vcsFLQO0AYGFP3CR6BxH8eZeRpwNAXS
        m/WiwKNmEAsTzuLDH+wsJilbG8PMCyNq+zmMFeu72BzEjxOO1SOeBcyk+DxrmpsybuTgjx
        OSZLD8vRwQIce1z/5LbVgwRpfnmxr1o=
In-Reply-To: <20220513171811.730-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

VGhpcyBpcyBlZmZlY3RpdmVseSBhIHJldmVydCBvZiBjb21taXQgY2RjNjk0NThhNWYzICgiY2dy
b3VwOiBhY2NvdW50CmZvciBtZW1vcnlfcmVjdXJzaXZlcHJvdCBpbiB0ZXN0X21lbWNnX2xvdygp
IikuIFRoZSBjYXNlIHRlc3RfbWVtY2dfbG93CndpbGwgZmFpbCB3aXRoIG1lbW9yeV9yZWN1cnNp
dmVwcm90IHVudGlsIHJlc29sdmVkIGluIHJlY2xhaW0KY29kZS4KSG93ZXZlciwgdGhpcyBwYXRj
aCBwcmVzZXJ2ZXMgdGhlIGV4aXN0aW5nIGhlbHBlcnMgYW5kIHZhcmlhYmxlcyBmb3IKbGF0ZXIg
dXNlcy4KClNpZ25lZC1vZmYtYnk6IE1pY2hhbCBLb3V0bsO9IDxta291dG55LUlCaTlSRy9iNjdr
QHB1YmxpYy5nbWFuZS5vcmc+Ci0tLQogdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL3Rl
c3RfbWVtY29udHJvbC5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3Vw
L3Rlc3RfbWVtY29udHJvbC5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL3Rlc3Rf
bWVtY29udHJvbC5jCmluZGV4IDQ5NThiNDIyMDFhOS4uZWJhMjUyZmE2NGFjIDEwMDY0NAotLS0g
YS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9jZ3JvdXAvdGVzdF9tZW1jb250cm9sLmMKKysrIGIv
dG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL3Rlc3RfbWVtY29udHJvbC5jCkBAIC01Mjgs
NyArNTI4LDcgQEAgc3RhdGljIGludCB0ZXN0X21lbWNnX2xvdyhjb25zdCBjaGFyICpyb290KQog
CX0KIAogCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKGNoaWxkcmVuKTsgaSsrKSB7Ci0JCWlu
dCBub19sb3dfZXZlbnRzX2luZGV4ID0gaGFzX3JlY3Vyc2l2ZXByb3QgPyAyIDogMTsKKwkJaW50
IG5vX2xvd19ldmVudHNfaW5kZXggPSAxOwogCiAJCW9vbSA9IGNnX3JlYWRfa2V5X2xvbmcoY2hp
bGRyZW5baV0sICJtZW1vcnkuZXZlbnRzIiwgIm9vbSAiKTsKIAkJbG93ID0gY2dfcmVhZF9rZXlf
bG9uZyhjaGlsZHJlbltpXSwgIm1lbW9yeS5ldmVudHMiLCAibG93ICIpOwotLSAKMi4zNS4zCgo=
