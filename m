From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Fix incorrect warning from
 cgroup_apply_control_disable()
Date: Mon, 13 Sep 2021 08:45:16 -1000
Message-ID: <YT+cPPyDPimHibSC@slm.duckdns.org>
References: <20210910024256.7615-1-longman@redhat.com>
 <YT+TA6ItnF9xM3cR@slm.duckdns.org>
 <125c4202-68d1-1a4e-03d6-2b18f0794ba4@redhat.com>
 <dbb1a221-b3d2-5086-e47b-8a2c764d60ad@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YWQhTVi3cs3JhEQkXnoGLByH48od8NQU5b4m5WXkDH8=;
        b=ajImzOPzIfdLH/DVFsbWet7ZSb4LKXdqbbLvOKr39wNgttg3S9EUsZh2Rhpg+Z1pAl
         O/qjf5fIPJ/GlnGp8VI95IZYWODrwbOiJAll9AUY9Z/mBaae9oApuuqBMBzmeqJ2TaJM
         8Am5CkD+Nnzn2Ap9p7owSLLz00FZVNRxUhKzhT6lJ4LuYI4dzOcynuUi0uQAaF4WgDS0
         pY4rrBTCTgrhDFuPE5JdAcMsfRVEuurYBEVXBxaydbgJuCKsgSmCaN2Wa4iHgAvnB0IE
         BHp/92Ogv//OqKQ1Ds3Wb8TUQMLhISBbltyE+D77K/yT9yjrionF6VAtBYdygTUSXsF4
         MxLA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <dbb1a221-b3d2-5086-e47b-8a2c764d60ad-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 13, 2021 at 02:43:44PM -0400, Waiman Long wrote:
> > The problem with percpu_ref_is_dying() is the fact that it becomes true
> > after percpu_ref_exit() is called in css_free_rwork_fn() which has an
> > RCU delay. If you want to catch the fact that kill_css() has been
> > called, we can check the CSS_DYING flag which is set in kill_css() by
> > commit 33c35aa481786 ("cgroup: Prevent kill_css() from being called more
> > than once"). Will that be an acceptable alternative?
>=20
> Something like
>=20
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 881ce1470beb..851e54800ad8 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3140,6 +3140,9 @@ static void cgroup_apply_control_disable(struct cgr=
oup
> *cg
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if =
(!css)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 continue;
>=20
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (c=
ss->flags & CSS_DYING)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 continue;
> +

So, I don't think this would be correct. It is assumed that there are no
dying csses when control reaches this point. The right fix is making sure
that remount path clears up dying csses before calling into this path.

Thanks.

--=20
tejun
