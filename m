From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: memcontrol: use per-cpu stocks for socket memory
 uncharging
Date: Wed, 30 Aug 2017 13:57:29 +0100
Message-ID: <20170830125729.GA12012@castle.DHCP.thefacebook.com>
References: <20170829100150.4580-1-guro@fb.com>
 <20170830123655.6kce7yfkrhrhwubu@dhcp22.suse.cz>
 <20170830124459.GA10438@castle.DHCP.thefacebook.com>
 <20170830125543.um72yjhzps4lbj4t@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=MaZgV7zcnPk9ODAntfbLzNoTEyVN6BSlGALc2ZkzF/M=;
 b=HFwXkCGduVF2P/pAIN4ylCkjJYvUtErKWwO9lb4vdbXjRtWfHjuLXMIJR/VflvvRlLxZ
 PG9kIAnNE9poeYU5o+kBbJdyVzPiCEmfEgbd0CXi8YLWdrpdrz2dVuB1CTJ9ybtdE6JF
 EHlrQX8m6LWMptLWkeObymdPqoPpMAjEtzc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MaZgV7zcnPk9ODAntfbLzNoTEyVN6BSlGALc2ZkzF/M=;
 b=j0ao9cYDJ0QGS/QKHQRm5oAVmU6s5BDqSCSPd2qQQdX1uVNovVm5G8VpBcakUr21rVWHkA35o/KPJn/HFFXE8ow+hmS61e7r1YaDGg+ISanm4Ds0EnC7g6BhXje9rpklADavhljO1eHdWq+7MzWcXIXPJ0twRWlycyG+GHHRh+Q=
Content-Disposition: inline
In-Reply-To: <20170830125543.um72yjhzps4lbj4t@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org

On Wed, Aug 30, 2017 at 02:55:43PM +0200, Michal Hocko wrote:
> On Wed 30-08-17 13:44:59, Roman Gushchin wrote:
> > On Wed, Aug 30, 2017 at 02:36:55PM +0200, Michal Hocko wrote:
> > > On Tue 29-08-17 11:01:50, Roman Gushchin wrote:
> > > [...]
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index b9cf3cf4a3d0..a69d23082abf 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -1792,6 +1792,9 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > >  	}
> > > >  	stock->nr_pages += nr_pages;
> > > >  
> > > > +	if (stock->nr_pages > CHARGE_BATCH)
> > > > +		drain_stock(stock);
> > > > +
> > > >  	local_irq_restore(flags);
> > > >  }
> > > 
> > > Why do we need this? In other words, why cannot we rely on draining we
> > > already do?
> > 
> > The existing draining depends on memory pressure, so to keep
> > the accounting (which we expose to a user) reasonable accurate
> > even without memory pressure, we need to limit the size of per-cpu stocks.
> 
> Why don't we need this for regular page charges? Or maybe we do but that
> sounds like a seprate and an unrealted fix to me.

Because we never refill more than CHARGE_BATCH.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
