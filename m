From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Question] Do we need remote charging for cpu and cpuacct subsys?
Date: Fri, 02 Jul 2021 08:26:27 -0000
Message-ID: <60decdb6.1c69fb81.6130e.7642@mx.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:to:cc:subject:mime-version:date
         :content-transfer-encoding;
        bh=dX6i2Y1Ly1681d2mbj0j/9kxKdKTvA3NyPTEzjPTIAo=;
        b=O0MCkaYt1focsaJcVAnZ1S3briveTgqC3Ppgjih1yaYijWRG7f96cLefa3xqTEXomV
         L4dvYp//TA70BCp2Y3yTdZEUpbA0RcpZayLdNh/QtlwhM2qs/gL+IAN8/dqfZH1VTgnk
         7CCVSwasXmTbRUGlu+Kap89MRd5Gy4dF7cX0NSXi14ofkkD7KtRIMohmR1zUkUD4iSmJ
         HT6OVSzRb61vhdKRpbQ4ftZEdX7zg7/FJl36V7/CQME95EO0rmAaaAYZsh6Qm+o2i0MG
         wZY8xzG6jSN8YhuaG1XCLriRGNqQx9yr/ciYt31BR9wJaIsJHCWl41Hn/7tP/HPRD6Aa
         mI+Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

SGksCgptZW1jZyBjdXJyZW50bHkgaGFzIGEgcmVtb3RlIGNoYXJnaW5nIG1lY2hhbmlzbSB0aGF0
IGNhbiBjaGFyZ2UgdXNhZ2UgdG8gb3RoZXIKbWVtY2cgaW5zdGVhZCBvZiB0aGUgb25lIHRoZSB0
YXNrIGJlbG9uZ3MgdG8uCgpJbiBvdXIgZW52aXJvbm1lbnQsIHdlIG5lZWQgdG8gYWNjb3VudCB0
aGUgY3B1IHVzYWdlIGNvbnN1bWVkIGJ5IHNvbWUga3dvcmtlcnMKdG8gYSBzcGVjaWZpYyBjZ3Jv
dXAuIFRodXMsIHdlIHdhbnQgdG8gaW50cm9kdWNlIGEgcmVtb3RlLWNoYXJnaW5nIG1lY2hhbmlz
bSB0bwpjcHUgYW5kIGNwdWFjY3Qgc3Vic3lzIGluIG91ciBrZXJuZWwuCgpJIHdhbnQgdG8ga25v
dyBpZiB0aGUgY29tbXVuaXR5IGhhcyBhIHBsYW4gdG8gZG8gdGhpcz8KV2hhdCB3aWxsIHRoZSBj
b21tdW5pdHkgYXBwcm9hY2ggbG9vayBsaWtlPwoKSSB0aGluayB3ZSBuZWVkIHRvIG1vdmUgdGhl
IGFjdGl2ZV9tZW1jZyB0byBhIHNlcGFyYXRlZCBhY3RpdmVfY2dyb3VwIHN0cnVjdCwKYW5kIHRo
ZSBsYXR0ZXIgd2lsbCBjb250YWluIGFjdGl2ZV9tZW1jZywgYWN0aXZlX3RnLCBhbmQgYWN0aXZl
X2NwdWFjY3QuCgoKUmVnYXJkcywKSGFvIExlZQo=

