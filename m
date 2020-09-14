From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm/memcg: Simplify mem_cgroup_get_max()
Date: Mon, 14 Sep 2020 17:29:04 -0400
Message-ID: <20200914212904.GB175618@cmpxchg.org>
References: <20200914024452.19167-1-longman@redhat.com>
 <20200914024452.19167-3-longman@redhat.com>
 <20200914114825.GM16999@dhcp22.suse.cz>
 <e8ddc443-b56a-1dd6-6d41-ad217e9aea80@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yrT8gC4TTWet6cZ9YwSESn7cnuC6utKAOdmSGQgzcPU=;
        b=W3aKslhundhu3B/Fi871b2e1Fj2OCJtvs3SQyw2QoDeAfHiT1b1gbC21cgtxcN50dv
         Cl4JMtBfvUJmy9RKwjSs56Q31TGv1HgO7nxpzUNGD2+pg4uDX6AE4R5Ma8mwZ3Erc/YK
         lW+50k3WsMh8OoaNKn4SxKilIjiwgWYIclfyPq2DbbLw6Xei5uUMHF4p0ObonXrxcZhT
         TmmRrdD/VsUAEtTbbTdj4+IQ0mvQ2mXthq0yJpFmfnrEohvPyxMISwsI7I1wjKJQ1F6Z
         ERw5AsyT/pD/oIHNusD7gJKQH56XMtLUL5i7yaHDmTZx8Se9E5lzKJn9MmkGYrnKmxGU
         6FZA==
Content-Disposition: inline
In-Reply-To: <e8ddc443-b56a-1dd6-6d41-ad217e9aea80-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Sep 14, 2020 at 09:51:26AM -0400, Waiman Long wrote:
> On 9/14/20 7:48 AM, Michal Hocko wrote:
> > On Sun 13-09-20 22:44:51, Waiman Long wrote:
> > > The mem_cgroup_get_max() function used to get memory+swap max from
> > > both the v1 memsw and v2 memory+swap page counters & return the maxim=
um
> > > of these 2 values. This is redundant and it is more efficient to just
> > > get either the v1 or the v2 values depending on which one is currently
> > > in use.
> > >=20
> > > Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gma=
ne.org>
> > > ---
> > >   mm/memcontrol.c | 20 +++++++++-----------
> > >   1 file changed, 9 insertions(+), 11 deletions(-)
> > >=20
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 8c74f1200261..ca36bed588d1 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -1633,17 +1633,15 @@ void mem_cgroup_print_oom_meminfo(struct mem_=
cgroup *memcg)
> > >    */
> > >   unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
> > >   {
> > > -	unsigned long max;
> > > -
> > > -	max =3D READ_ONCE(memcg->memory.max);
> > > -	if (mem_cgroup_swappiness(memcg)) {
> > > -		unsigned long memsw_max;
> > > -		unsigned long swap_max;
> > > -
> > > -		memsw_max =3D memcg->memsw.max;
> > > -		swap_max =3D READ_ONCE(memcg->swap.max);
> > > -		swap_max =3D min(swap_max, (unsigned long)total_swap_pages);
> > > -		max =3D min(max + swap_max, memsw_max);
> > > +	unsigned long max =3D READ_ONCE(memcg->memory.max);
> > > +
> > > +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
> > > +		if (mem_cgroup_swappiness(memcg))
> > > +			max +=3D min(READ_ONCE(memcg->swap.max),
> > > +				   (unsigned long)total_swap_pages);
> > > +	} else { /* v1 */
> > > +		if (mem_cgroup_swappiness(memcg))
> > > +			max =3D memcg->memsw.max;
> > I agree that making v1 vs. v2 distinction here makes the code more
> > obvious. But I do not think your code is correct for v1. In a default
> > state it would lead to max =3D PAGE_COUNTER_MAX which is not something
> > we want, right?
> >=20
> > instead you want
> > 		max +=3D min(READ_ONCE(memcg->memsw.max), total_swap_pages);
> >=20
> You are right, it is a bit tricky for v1.
>=20
> I will change it to
>=20
> =A0=A0=A0 max +=3D min(READ_ONCE(memcg->memsw.max) - max, total_swap_page=
s):

memsw.max can be smaller than max.

max =3D min3(max, READ_ONCE(memcg->memsw.max), total_swap_pages)?
