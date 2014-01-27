From: Dermot McGahon <dmcgahon-mOLzCpKykOlBDgjK7y7TUQ@public.gmane.org>
Subject: Fwd: CGroups and pthreads
Date: Mon, 27 Jan 2014 16:38:11 +0000
Message-ID: <CALaYU_DoyN+aAbS-ubkYRCwnOBd2knxvnhNTYWF-nJoUXMqXnw@mail.gmail.com>
References: <CALaYU_BZ8iuHnAgkss1wO7BK3qULgotYSpmX4nqX=uC+aTnddA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c309ea929d2104f0f656c3
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waratek.com; s=waratek;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        bh=hZrwIPD4EK6LCdPupWhRwIQvVxfvINKGmgU/mhmBIJg=;
        b=DxDGBMiJBU+S5cKjkMOpDJM5Ald5mf7IgEtkkK9fcfx6k0eAePQdsDJ5RYgzcFBVcH
         pvFKANNHfGtyYudGYFRncM3ZRqG6hXqCNGMpm4tkxsp2BqWZJcsaKw/T6Lmz/e5ygzUR
         f3Iz1op+CtI2afUcuQIpzHvobPyi03rTb729M=
In-Reply-To: <CALaYU_BZ8iuHnAgkss1wO7BK3qULgotYSpmX4nqX=uC+aTnddA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--001a11c309ea929d2104f0f656c3
Content-Type: text/plain; charset=ISO-8859-1

Is it possible to apply cgroup memory subsystem controls to threads created with
pthread_create() / clone or only tasks that have been created using
fork and exec?

In testing, we seem to be seeing that all allocations are accounted
for against the
PPID / TGID and never the pthread_create()'d TID, even though the TID is an LWP
and can be seen using top (though RSS is aggregate and global of course).

Attached is a simple test program used to print PID / TID and allocate memory
from a cloned TID. After setting breakpoints in child and parent and
setting up a
cgroups hierarchy of 'parent' and 'child', apply memory.limit_in_bytes and
memory.memsw.limit_in_bytes to the child cgroup only and adding the PID to
the parent group and the TID to the child group we see that behaviour.

Is that expected? I realise that the subsystems are all different but
what is confusing
us slightly is that we have previously used the CPU subsystem to set cpu_shares
and adding LWP / TID's to individual cgroups worked just fine for that

Am I misconfiguring somehow or is this a known difference between CPU and
MEMORY subsystems?

--001a11c309ea929d2104f0f656c3
Content-Type: text/x-csrc; charset=US-ASCII; name="pthread_test.c"
Content-Disposition: attachment; filename="pthread_test.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqxy6q1x0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0ZGxpYi5o
PgojaW5jbHVkZSA8c3lzL3N5c2NhbGwuaD4KCnZvaWQgdGhyZWFkX2Z1bmMoKQp7CiAgICBwcmlu
dGYoICJ0aHJlYWQgcGlkPSVkLCB0aHJlYWQgdGlkPSVkXG4iLCBnZXRwaWQoKSwgc3lzY2FsbCgg
U1lTX2dldHRpZCApICk7CgogICAgc2l6ZV90IG9uZV9odW5kcmVkX21iID0gMTAwICogMTAyNCAq
IDEwMjQ7CiAgICB2b2lkICogYWxsb2NhdGVkQ2h1bmsgPSBtYWxsb2MgKCBvbmVfaHVuZHJlZF9t
YiApOwogICAgbWVtc2V0KCBhbGxvY2F0ZWRDaHVuaywgMCwgb25lX2h1bmRyZWRfbWIgKTsKCiAg
ICBpZiAoIGFsbG9jYXRlZENodW5rID09IE5VTEwgKQogICAgewogICAgICAgIHByaW50ZigiY291
bGRuJ3QgYWxsb2NhdGVcbiIpOwogICAgfQogICAgZWxzZQogICAgewogICAgICAgIGludCB0aWQg
PSBzeXNjYWxsKCBTWVNfZ2V0dGlkICk7CiAgICAgICAgcHJpbnRmKCAiUElEOiAlZCwgVElEOiAl
ZCAtIGhhcyBhbGxvY2F0ZWQgMTAwbWJcbiIsIGdldHBpZCgpLCBzeXNjYWxsKCBTWVNfZ2V0dGlk
ICkgKTsKICAgIH0KCiAgICBzbGVlcCgxMDAwKTsKfQoKdm9pZCBtYWluKCkKewogICAgcHJpbnRm
KCAibWFpbiBwaWQ9JWQsIG1haW4gdGlkPSVkXG4iLCBnZXRwaWQoKSwgc3lzY2FsbCggU1lTX2dl
dHRpZCApICk7CgogICAgcHRocmVhZF90IHRocmVhZDE7CiAgICBwdGhyZWFkX2NyZWF0ZSggJnRo
cmVhZDEsIE5VTEwsICh2b2lkICopJnRocmVhZF9mdW5jLCBOVUxMKTsKCi8qICAgIHBpZF90IGNo
aWxkcGlkOwogICAgY2hpbGRwaWQgPSBmb3JrKCk7CgogICAgaWYgKCBjaGlsZHBpZCA+PSAwICkK
ICAgIHsKICAgICAgIGlmICggY2hpbGRwaWQgPT0gMCApCiAgICAgICB7CiAgICAgICAgICB0aHJl
YWRfZnVuYygpOyAvLyBjaGlsZAogICAgICAgfQogICAgICAgZWxzZQogICAgICAgewogICAgICAg
ICAgc2xlZXAoMTAwMCk7IC8vIHBhcmVudAogICAgICAgfQogICAgfQogICAgZWxzZQogICAgewog
ICAgICAgcGVycm9yKCJmb3JrIik7CiAgICAgICBleGl0KDApOwogICAgfSAqLwoKICAgIHNsZWVw
KDEwMDApOwp9Cgo=
--001a11c309ea929d2104f0f656c3--
