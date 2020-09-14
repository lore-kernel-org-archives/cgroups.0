From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/3] mm/memcg: Simplify mem_cgroup_get_max()
Date: Mon, 14 Sep 2020 17:32:00 -0400
Message-ID: <20200914213200.GC175618@cmpxchg.org>
References: <20200914024452.19167-1-longman@redhat.com>
 <20200914024452.19167-3-longman@redhat.com>
 <20200914114825.GM16999@dhcp22.suse.cz>
 <e8ddc443-b56a-1dd6-6d41-ad217e9aea80@redhat.com>
 <20200914212904.GB175618@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=M6GRxBpT2cC25wV82DuNi9J3pqiD8OWCE31gUld/UhE=;
        b=rwyLUxhptQJc4HOqwpHP2HBqm700/ViMyS+157/Rz8Xv6Kt/qW1SS8hfob3t+geEaN
         jgum4YbUdr9Z/zipYDu1H+ZK7te0x5IIz2kR1YJOnnYec34roru9spTQuD3GhyqhJY7E
         wn6kotmIL/HBuARMoYXTBU3L5Is9LfKgxWv9elRtM1XilCShSVzx3Ee6PqpwV6evdyUI
         5R0Pbsb0l9+ce6wHYdnl+Rg3xvN1fh/T6OtQePz+hvQMJgIBut1tgGPjsxnwwtaxvPnl
         5v3i2B/3e9WAQVVQIaAWihJ0Sv6vxWISBtn5UOkRsG58l7XOP20RC+5xHSPvcaET7Uoe
         hfqg==
Content-Disposition: inline
In-Reply-To: <20200914212904.GB175618@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>

On Mon, Sep 14, 2020 at 05:29:06PM -0400, Johannes Weiner wrote:
> On Mon, Sep 14, 2020 at 09:51:26AM -0400, Waiman Long wrote:
> > On 9/14/20 7:48 AM, Michal Hocko wrote:
> > > On Sun 13-09-20 22:44:51, Waiman Long wrote:
> > > > The mem_cgroup_get_max() function used to get memory+swap max from
> > > > both the v1 memsw and v2 memory+swap page counters & return the max=
imum
> > > > of these 2 values. This is redundant and it is more efficient to ju=
st
> > > > get either the v1 or the v2 values depending on which one is curren=
tly
> > > > in use.
> > > >=20
> > > > Signed-off-by: Waiman Long <longman@redhat.com>
> > > > ---
> > > >   mm/memcontrol.c | 20 +++++++++-----------
> > > >   1 file changed, 9 insertions(+), 11 deletions(-)
> > > >=20
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 8c74f1200261..ca36bed588d1 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -1633,17 +1633,15 @@ void mem_cgroup_print_oom_meminfo(struct me=
m_cgroup *memcg)
> > > >    */
> > > >   unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
> > > >   {
> > > > -	unsigned long max;
> > > > -
> > > > -	max =3D READ_ONCE(memcg->memory.max);
> > > > -	if (mem_cgroup_swappiness(memcg)) {
> > > > -		unsigned long memsw_max;
> > > > -		unsigned long swap_max;
> > > > -
> > > > -		memsw_max =3D memcg->memsw.max;
> > > > -		swap_max =3D READ_ONCE(memcg->swap.max);
> > > > -		swap_max =3D min(swap_max, (unsigned long)total_swap_pages);
> > > > -		max =3D min(max + swap_max, memsw_max);
> > > > +	unsigned long max =3D READ_ONCE(memcg->memory.max);
> > > > +
> > > > +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
> > > > +		if (mem_cgroup_swappiness(memcg))
> > > > +			max +=3D min(READ_ONCE(memcg->swap.max),
> > > > +				   (unsigned long)total_swap_pages);
> > > > +	} else { /* v1 */
> > > > +		if (mem_cgroup_swappiness(memcg))
> > > > +			max =3D memcg->memsw.max;
> > > I agree that making v1 vs. v2 distinction here makes the code more
> > > obvious. But I do not think your code is correct for v1. In a default
> > > state it would lead to max =3D PAGE_COUNTER_MAX which is not something
> > > we want, right?
> > >=20
> > > instead you want
> > > 		max +=3D min(READ_ONCE(memcg->memsw.max), total_swap_pages);
> > >=20
> > You are right, it is a bit tricky for v1.
> >=20
> > I will change it to
> >=20
> > =A0=A0=A0 max +=3D min(READ_ONCE(memcg->memsw.max) - max, total_swap_pa=
ges):
>=20
> memsw.max can be smaller than max.
>=20
> max =3D min3(max, READ_ONCE(memcg->memsw.max), total_swap_pages)?

Nevermind, I saw the follow-up below, and it's indeed not allowed to
configure it like that.
