From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH] mm, memcg: reset low limit during memcg offlining
Date: Wed, 26 Jul 2017 11:30:17 +0300
Message-ID: <20170726083017.3yzeucmi7lcj46qd@esperanza>
References: <20170725114047.4073-1-guro@fb.com>
 <20170725120537.o4kgzjhcjcjmopzc@esperanza>
 <20170725123113.GB12635@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5L4bfYlvLJIbqdz3lyaFHzdts+OfmULocZagpXhqJO4=;
        b=UXliWwP+OGDQlCqdEZ9jXzZfFDch+zqRwFjhfaE6Y1Wp1E/LXzFI9tCRRnf1usThfI
         dgkY33I7BFQB3n+bOndkfeeD9q/Cgv2ekMBgLNVpvSKTL+u/wLcqrof9wqIeWWrSm4CZ
         V6lmpVWTCPadtKqV7VfeBIlvO4FK+MgtRLQz0N56BcdlO92+bXp5aPVoRwctKLcRxwt9
         T8WncJI7fk/eJ+aFHRmyfwXxjHPyzfh+dNLZ+FPYPFs6KZpGShLdg+4wyg/yiCDaDnfC
         9agk/T0LWIqwVKL/xcLz6Vt0ZI82YY51rFkSpdxmtxPuLZ9ANbVriq+pqmzR39HFPvz2
         cOpg==
Content-Disposition: inline
In-Reply-To: <20170725123113.GB12635@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 25, 2017 at 01:31:13PM +0100, Roman Gushchin wrote:
> On Tue, Jul 25, 2017 at 03:05:37PM +0300, Vladimir Davydov wrote:
> > On Tue, Jul 25, 2017 at 12:40:47PM +0100, Roman Gushchin wrote:
> > > A removed memory cgroup with a defined low limit and some belonging
> > > pagecache has very low chances to be freed.
> > > 
> > > If a cgroup has been removed, there is likely no memory pressure inside
> > > the cgroup, and the pagecache is protected from the external pressure
> > > by the defined low limit. The cgroup will be freed only after
> > > the reclaim of all belonging pages. And it will not happen until
> > > there are any reclaimable memory in the system. That means,
> > > there is a good chance, that a cold pagecache will reside
> > > in the memory for an undefined amount of time, wasting
> > > system resources.
> > > 
> > > Fix this issue by zeroing memcg->low during memcg offlining.
> > > 
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Michal Hocko <mhocko@kernel.org>
> > > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > > Cc: kernel-team@fb.com
> > > Cc: cgroups@vger.kernel.org
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  mm/memcontrol.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index aed11b2d0251..2aa204b8f9fd 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -4300,6 +4300,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
> > >  	}
> > >  	spin_unlock(&memcg->event_list_lock);
> > >  
> > > +	memcg->low = 0;
> > > +
> > >  	memcg_offline_kmem(memcg);
> > >  	wb_memcg_offline(memcg);
> > >  
> > 
> > We already have that - see mem_cgroup_css_reset().
> 
> Hm, I see...
> 
> But are you sure, that calling mem_cgroup_css_reset() from offlining path
> is always a good idea?
> 
> As I understand, css_reset() callback is intended to _completely_ disable all
> limits, as if there were no cgroup at all.

But that's exactly what cgroup offline is: deletion of a cgroup as if it
never existed. The fact that we leave the zombie dangling until all
pages charged to the cgroup are gone is an implementation detail. IIRC
we would "reparent" those charges and delete the mem_cgroup right away
if it were not inherently racy.

> And it's main purpose to be called
> when controllers are detached from the hierarhy.
> 
> Offlining is different: some limits make perfect sence after offlining
> (e.g. we want to limit the writeback speed), and other might be tweaked
> (e.g. we can set soft limit to prioritize reclaiming of abandoned cgroups).

The user can't tweak limits of an offline cgroup, because the cgroup
directory no longer exist. So IMHO resetting all limits is reasonable.
If you want to keep the cgroup limits effective, you shouldn't have
deleted it in the first place, I suppose.

You might also want to check out this:

  http://www.spinics.net/lists/linux-mm/msg102995.html

> 
> So, I'd prefer to move this code to the offlining callback,
> and not to call css_reset.
> 
> But, anyway, thanks for pointing at the mem_cgroup_css_reset().
