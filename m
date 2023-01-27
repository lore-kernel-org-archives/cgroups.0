From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 14:03:59 +0100
Message-ID: <Y9PLvzI8WU0vYWUt@lothringen>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
 <Y9N5CI8PpsfiaY9c@dhcp22.suse.cz>
 <52a0f1e593b1ec0ca7e417ba37680d65df22de82.camel@redhat.com>
 <601fc35a8cc2167e53e45c636fccb2d899fd7c50.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674824642;
        bh=5/c2AB+sVfBr3bN7TBwjNlpfu3p70/0YG6h0yWH9Mpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UHJpxk7EFq6ak/R8ldY7KoUAXIlE2dZyXktge26XKHv9g66w8Izx9NuNibJZEOrwz
         HxgvWvRBRErjHhikZlfyKKCHqBxbFM3JYu6q2pUincrQeHyB5ye561Ic/ed1NnY5wC
         znydMQCtv2iEuj6odOpLLra+NAdugUihIlaD7nwrbZnuZI8L9JMr2az2IqhC5Lsy+h
         y45Gis+7DoDk/XNeosPI979PPqlzsCRl6GF73eF9/yUAZxdtDwFVVvgxEQudOUhGH7
         ZY1rOejeZI0pqRMK2/Wk+85B4AZ/IhS29y6GRuxXlaDIuQ5CWk6Zg/qxpmyau11j8o
         rSLXu+bX8FWaw==
Content-Disposition: inline
In-Reply-To: <601fc35a8cc2167e53e45c636fccb2d899fd7c50.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbecker-l3A5Bk7waGM@public.gmane.org>

On Fri, Jan 27, 2023 at 05:12:13AM -0300, Leonardo Br=E1s wrote:
> On Fri, 2023-01-27 at 04:22 -0300, Leonardo Br=E1s wrote:
> > > Hmm, OK, I have misunderstood your proposal. Yes, the overal pcp char=
ges
> > > potentially left behind should be small and that shouldn't really be a
> > > concern for memcg oom situations (unless the limit is very small and
> > > workloads on isolated cpus using small hard limits is way beyond my
> > > imagination).
> > >=20
> > > My first thought was that those charges could be left behind without =
any
> > > upper bound but in reality sooner or later something should be running
> > > on those cpus and if the memcg is gone the pcp cache would get refill=
ed
> > > and old charges gone.
> > >=20
> > > So yes, this is actually a better and even simpler solution. All we n=
eed
> > > is something like this
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index ab457f0394ab..13b84bbd70ba 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2344,6 +2344,9 @@ static void drain_all_stock(struct mem_cgroup *=
root_memcg)
> > >  		struct mem_cgroup *memcg;
> > >  		bool flush =3D false;
> > > =20
> > > +		if (cpu_is_isolated(cpu))
> > > +			continue;
> > > +
> > >  		rcu_read_lock();
> > >  		memcg =3D stock->cached;
> > >  		if (memcg && stock->nr_pages &&
> > >=20
> > > There is no such cpu_is_isolated() AFAICS so we would need a help from
> > > NOHZ and cpuisol people to create one for us. Frederic, would such an
> > > abstraction make any sense from your POV?
> >=20
> >=20
> > IIUC, 'if (cpu_is_isolated())' would be instead:
> >=20
> > if (!housekeeping_cpu(smp_processor_id(), HK_TYPE_DOMAIN) ||
> > !housekeeping_cpu(smp_processor_id(), HK_TYPE_WQ)
>=20
> oh, sorry 's/smp_processor_id()/cpu/' here:
>=20
> if(!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) || !housekeeping_cpu(cpu, HK_TY=
PE_WQ))

Do you also need to handle cpuset.sched_load_balance=3D0 (aka. cpuset v2 "i=
solated"
partition type). It has the same effect as isolcpus=3D, but it can be chang=
ed at
runtime.

And then on_null_domain() look like what you need. You'd have to make that =
API
more generally available though, and rename it to something like
"bool cpu_has_null_domain(int cpu)".

But then you also need to handle concurrent cpuset changes. If you can tole=
rate
it to be racy, then RCU alone is fine.

Thanks.
