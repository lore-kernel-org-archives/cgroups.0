From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 4/8] cgroup: rstat: support cgroup1
Date: Wed, 17 Feb 2021 15:52:59 -0500
Message-ID: <YC2CKyaeF2bqvpMk@cmpxchg.org>
References: <20210209163304.77088-1-hannes@cmpxchg.org>
 <20210209163304.77088-5-hannes@cmpxchg.org>
 <20210217174232.GA19239@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/nI5rj9bvE6w+kmHwM58CvDkIfatHnQ+1wEcvE6t0qM=;
        b=LRegk7bSkLpAy9xvp3N/hncxZhzP8Xrlr1UaRRu2N5qWlQWPo52bjTvGA8VIv4kbEF
         lShAhk2O99mAa5clhSXPVAdxFkq1AKCbtlnxLGkUORLjGHudJIhkQeT0LGFRVqc5czce
         olwaIu6YmleDNMi6Guf87kfg0jryOdIC22S8AdK8aVVunaMZgAICA1OTr0M2XS8qZzcJ
         HJ/Ene0AyDh2JrCED8TVxmid8NiihzpDXbpRyzZXTsibJGK4tUGn/lpepfII6xFrarI0
         OrxhWiNJ0YIv4ARellkRePr3xqNExRIieZ/h2vVX/HYHYfLPkwImW+FqC2dlsRHhIy7W
         UcUQ==
Content-Disposition: inline
In-Reply-To: <20210217174232.GA19239@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Feb 17, 2021 at 06:42:32PM +0100, Michal Koutn=FD wrote:
> Hello.
>=20
> On Tue, Feb 09, 2021 at 11:33:00AM -0500, Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > @@ -1971,10 +1978,14 @@ int cgroup_setup_root(struct cgroup_root *root,=
 u16 ss_mask)
> >  	if (ret)
> >  		goto destroy_root;
> > =20
> > -	ret =3D rebind_subsystems(root, ss_mask);
> > +	ret =3D cgroup_rstat_init(root_cgrp);
> Would it make sense to do cgroup_rstat_init() only if there's a subsys
> in ss_mask that makes use of rstat?
> (On legacy systems there could be individual hierarchy for each
> controller so the rstat space can be saved.)

It's possible, but I don't think worth the trouble.

It would have to be done from rebind_subsystems(), as remount can add
more subsystems to an existing cgroup1 root. That in turn means we'd
have to have separate init paths for cgroup1 and cgroup2.

While we split cgroup1 and cgroup2 paths where necessary in the code,
it's a significant maintenance burden and a not unlikely source of
subtle errors (see the recent 'fix swap undercounting in cgroup2').

In this case, we're talking about a relatively small data structure
and the overhead is per mountpoint. Comparatively, we're allocating
the full vmstats structures for cgroup1 groups which barely use them,
and cgroup1 softlimit tree structures for each cgroup2 group.

So I don't think it's a good tradeoff. Subtle bugs that require kernel
patches are more disruptive to the user experience than the amount of
memory in question here.

> > @@ -285,8 +285,6 @@ void __init cgroup_rstat_boot(void)
> > =20
> >  	for_each_possible_cpu(cpu)
> >  		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
> > -
> > -	BUG_ON(cgroup_rstat_init(&cgrp_dfl_root.cgrp));
> >  }
> Regardless of the suggestion above, this removal obsoletes the comment
> cgroup_rstat_init:
>=20
>          int cpu;
> =20
> -        /* the root cgrp has rstat_cpu preallocated */
>          if (!cgrp->rstat_cpu) {
>                  cgrp->rstat_cpu =3D alloc_percpu(struct cgroup_rstat_cpu=
);

Oh, I'm not removing the init call, I'm merely moving it from
cgroup_rstat_boot() to cgroup_setup_root().

The default root group has statically preallocated percpu data before
and after this patch. See cgroup.c:

  static DEFINE_PER_CPU(struct cgroup_rstat_cpu, cgrp_dfl_root_rstat_cpu);

  /* the default hierarchy */
  struct cgroup_root cgrp_dfl_root =3D { .cgrp.rstat_cpu =3D &cgrp_dfl_root=
_rstat_cpu };
  EXPORT_SYMBOL_GPL(cgrp_dfl_root);
