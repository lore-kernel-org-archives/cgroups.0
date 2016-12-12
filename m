From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.10] cgroup: cgroup_sk_alloc() is allowed to
 increase reference on a dead cgroup
Date: Mon, 12 Dec 2016 16:48:11 -0500
Message-ID: <20161212214811.GJ13864@htj.duckdns.org>
References: <CAH=7=un56LL12Meu0j+6+ZRcdsnUHomfDLuq=raC6ZtQEwLqTA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=bEL24Sfp+29qprC0Teb8yQhguKJogJqHI9CsnTQLRVg=;
        b=HPxgFmLgkBrtH/mBgv6+SmAB7rxJdzR/vehvcf+Uh+XbJxm9DD7257uxIxT/Hu7rUQ
         I5gxNGRYYWlEx7fJ5UP+8tWOuWBhSmyhv9DF6lbPtdmSC+Xropz1paXU9TBHspKtXiA/
         BC/M8MrtdGp216OS3Rb63gPiBBIIL9kZiQ4OjB96butGfeoMjCGEk0JdJks4tvRjOlBc
         hvLp4P2YXazWXDdKm2kuwUyF0t44rQ/nYVVunfmxAnF6+wNxX+zq0VpW4lT/Tdv/W3H5
         W/k1YQypRThkWDRYzqMHoeol7ffJKZRtU8d0mwz2F8GgWEjbftH/kcP0gtgJFqWkJgO7
         6Wmw==
Content-Disposition: inline
In-Reply-To: <CAH=7=un56LL12Meu0j+6+ZRcdsnUHomfDLuq=raC6ZtQEwLqTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Jes=FAs_Rodr=EDguez?= Acosta <jesus.rodriguez.acosta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Jes=FAs,

I applied the following patch to cgroup/for-4.10 and will soon push
out to Linus.  I'm pretty sure this is what you saw but can you please
verify that the warning goes away with it applied?

Thanks a lot for the report.

------ 8< ------
From 89bb3eed858ec2ea36ceae822bbf81f1ef24e80d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 12 Dec 2016 16:30:29 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

When a listening socket associated with a cgroup creates a new
connection, it gets cloned and the reference on the cgroup is
incremented by calling cgroup_get().  Such a socket can be left behind
in an empty cgroup after processes are migrated away from it.  As an
empty cgroup may be removed, the socket may end up trying to clone new
sockets while associated with a removed cgroup.

This doesn't break anything in terms of reference counting; however,
as a precaution, cgroup_get() triggers WARN when it's called on a
removed cgroup, which cgroup_sk_alloc() can trigger spuriously.

We know this path is legit, open code cgroup_get() in
cgroup_sk_alloc() without the sanity check to avoid spuriously
triggering the warning.

Reported-by: Jes=FAs Rodr=EDguez Acosta <jesus.rodriguez.acosta-Re5JQEeQqe8=
AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Link: http://lkml.kernel.org/r/CAH=3D7=3Dun56LL12Meu0j+6+ZRcdsnUHomfDLuq=3D=
raC6ZtQEwLqTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
Fixes: d979a39d7242 ("cgroup: duplicate cgroup reference when cloning socke=
ts")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.5+
Cc: Johannes Weiner <jweiner-b10kYP2dOMg@public.gmane.org>
---
 kernel/cgroup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 85bc9be..7fe26595 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6318,9 +6318,13 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 	if (cgroup_sk_alloc_disabled)
 		return;
=20
-	/* Socket clone path */
+	/*
+	 * Socket clone path.  We open-code cgroup_get() here to avoid the
+	 * cgroup_is_dead() sanity check as a listening socket left in a
+	 * dead cgroup can still get cloned for new connections.
+	 */
 	if (skcd->val) {
-		cgroup_get(sock_cgroup_ptr(skcd));
+		css_get(&sock_cgroup_ptr(skcd)->self);
 		return;
 	}
=20
--=20
2.9.3
