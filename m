From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] cgroup/cpuset: Skip task update if hotplug doesn't affect current cpuset
Date: Fri, 17 Mar 2023 11:15:06 -0400
Message-ID: <20230317151508.1225282-3-longman@redhat.com>
References: <20230317151508.1225282-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679066135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amVdrpHTvDqA9NrS62Whbl25Xahg4lsNNZAsfD0/8D0=;
        b=BUDU3m7DKG88JRA1whDcemj0RFaT+VLMYzrEI37zwHDo/5aqxmFcxYsAIX5DmR+HaA4e7p
        vpcpg5vU00LbjiLLNwWIHVyhxf0+pAPnSod/h5KvZWijC391TIGCvc/pmER4uoOaQqAnIv
        ZHqHv8CAIjHBrWVsMFWBcxau0h4bw9Q=
In-Reply-To: <20230317151508.1225282-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

SWYgYSBob3RwbHVnIGV2ZW50IGRvZXNuJ3QgYWZmZWN0IHRoZSBjdXJyZW50IGNwdXNldCwgdGhl
cmUgaXMgbm8gcG9pbnQKdG8gY2FsbCBob3RwbHVnX3VwZGF0ZV90YXNrcygpIG9yIGhvdHBsdWdf
dXBkYXRlX3Rhc2tzX2xlZ2FjeSgpLiBTbwpqdXN0IHNraXAgaXQuCgpTaWduZWQtb2ZmLWJ5OiBX
YWltYW4gTG9uZyA8bG9uZ21hbi1IK3dYYUh4ZjdhTFFUMGRaUitBbGZBQHB1YmxpYy5nbWFuZS5v
cmc+ClJldmlld2VkLWJ5OiBNaWNoYWwgS291dG7DvSA8bWtvdXRueS1JQmk5UkcvYjY3a0BwdWJs
aWMuZ21hbmUub3JnPgotLS0KIGtlcm5lbC9jZ3JvdXAvY3B1c2V0LmMgfCAzICsrKwogMSBmaWxl
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9jZ3JvdXAvY3B1
c2V0LmMgYi9rZXJuZWwvY2dyb3VwL2NwdXNldC5jCmluZGV4IGYzMTA5MTVkMTI1Ny4uNWI4ZDc2
MzU1NWIwIDEwMDY0NAotLS0gYS9rZXJuZWwvY2dyb3VwL2NwdXNldC5jCisrKyBiL2tlcm5lbC9j
Z3JvdXAvY3B1c2V0LmMKQEAgLTM1MTYsNiArMzUxNiw4IEBAIHN0YXRpYyB2b2lkIGNwdXNldF9o
b3RwbHVnX3VwZGF0ZV90YXNrcyhzdHJ1Y3QgY3B1c2V0ICpjcywgc3RydWN0IHRtcG1hc2tzICp0
bXApCiB1cGRhdGVfdGFza3M6CiAJY3B1c191cGRhdGVkID0gIWNwdW1hc2tfZXF1YWwoJm5ld19j
cHVzLCBjcy0+ZWZmZWN0aXZlX2NwdXMpOwogCW1lbXNfdXBkYXRlZCA9ICFub2Rlc19lcXVhbChu
ZXdfbWVtcywgY3MtPmVmZmVjdGl2ZV9tZW1zKTsKKwlpZiAoIWNwdXNfdXBkYXRlZCAmJiAhbWVt
c191cGRhdGVkKQorCQlnb3RvIHVubG9jazsJLyogSG90cGx1ZyBkb2Vzbid0IGFmZmVjdCB0aGlz
IGNwdXNldCAqLwogCiAJaWYgKG1lbXNfdXBkYXRlZCkKIAkJY2hlY2tfaW5zYW5lX21lbXNfY29u
ZmlnKCZuZXdfbWVtcyk7CkBAIC0zNTI3LDYgKzM1MjksNyBAQCBzdGF0aWMgdm9pZCBjcHVzZXRf
aG90cGx1Z191cGRhdGVfdGFza3Moc3RydWN0IGNwdXNldCAqY3MsIHN0cnVjdCB0bXBtYXNrcyAq
dG1wKQogCQlob3RwbHVnX3VwZGF0ZV90YXNrc19sZWdhY3koY3MsICZuZXdfY3B1cywgJm5ld19t
ZW1zLAogCQkJCQkgICAgY3B1c191cGRhdGVkLCBtZW1zX3VwZGF0ZWQpOwogCit1bmxvY2s6CiAJ
cGVyY3B1X3VwX3dyaXRlKCZjcHVzZXRfcndzZW0pOwogfQogCi0tIAoyLjMxLjEKCg==
