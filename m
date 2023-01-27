From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 10:23:28 +0100
Message-ID: <Y9OYEAs+FzuiYd+j@dhcp22.suse.cz>
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
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674811409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2xvZjQHSmlkJ++xydcKZz/+IOLXbzOFKz6MRvf+IGoQ=;
        b=QYrMxh5iF8tEZkkIFQiaE0AmzYlUt1+vYWDsddn9lZSskr2jXsldh5NvFZbS6xqZHH9a8d
        uZwo40l3QwPpd4O9Ws+Lgz2Ss0yY/Rd4JXSO7AA1yqFZGpnGEFRWK8pc9UK4jbMEbt8qmu
        hNG0Yiin9IUP1Enty4F5i+/fAEiPJ2Y=
Content-Disposition: inline
In-Reply-To: <601fc35a8cc2167e53e45c636fccb2d899fd7c50.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbecker-l3A5Bk7waGM@public.gmane.org>

On Fri 27-01-23 05:12:13, Leonardo Br=E1s wrote:
> On Fri, 2023-01-27 at 04:22 -0300, Leonardo Br=E1s wrote:
> > On Fri, 2023-01-27 at 08:11 +0100, Michal Hocko wrote:
> > > [Cc Frederic]
> > >=20
> > > On Thu 26-01-23 15:12:35, Roman Gushchin wrote:
> > > > On Thu, Jan 26, 2023 at 08:41:34AM +0100, Michal Hocko wrote:
> > > [...]
> > > > > > Essentially each cpu will try to grab the remains of the memory=
 quota
> > > > > > and move it locally. I wonder in such circumstances if we need =
to disable the pcp-caching
> > > > > > on per-cgroup basis.
> > > > >=20
> > > > > I think it would be more than sufficient to disable pcp charging =
on an
> > > > > isolated cpu.
> > > >=20
> > > > It might have significant performance consequences.
> > >=20
> > > Is it really significant?
> > >=20
> > > > I'd rather opt out of stock draining for isolated cpus: it might sl=
ightly reduce
> > > > the accuracy of memory limits and slightly increase the memory foot=
print (all
> > > > those dying memcgs...), but the impact will be limited. Actually it=
 is limited
> > > > by the number of cpus.
> > >=20
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

Or maybe we can get a nice abstract API so that we do not have to really
care about those low level details. I do not really know what those
really mean and hopefully I shouldn't really need to know.

--=20
Michal Hocko
SUSE Labs
