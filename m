From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/4] mm: memcontrol: re-use global VM event enum
Date: Mon, 10 Apr 2017 10:17:34 -0400
Message-ID: <20170410141734.GB16119@cmpxchg.org>
References: <20170404220148.28338-1-hannes@cmpxchg.org>
 <20170404220148.28338-2-hannes@cmpxchg.org>
 <20170406084923.GB2268@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=D4m+C0FxCAxvaLg34Urm7h6bUwPg34GudN9LbPireP4=; b=yNTgi91N8uJhjxGYXQraCrtkNO
	DmQYUUWiQaNqvg/uZsesXDVuO24D56M5IWXHPalrqM6l8ukextbtM/Aq6E7mCXptrTO3RMz0juudF
	Vhr4+x6zXeCCtj7rIYdYoryu3jYYK6SGWfB3efYfYWZ7vEYY8JVDvqr6nGo0BU7bzF8I=;
Content-Disposition: inline
In-Reply-To: <20170406084923.GB2268@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Apr 06, 2017 at 11:49:24AM +0300, Vladimir Davydov wrote:
> On Tue, Apr 04, 2017 at 06:01:46PM -0400, Johannes Weiner wrote:
> > The current duplication is a high-maintenance mess, and it's painful
> > to add new items.
> > 
> > This increases the size of the event array, but we'll eventually want
> > most of the VM events tracked on a per-cgroup basis anyway.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Although the increase in the mem_cgroup struct introduced by this patch
> looks scary, I agree this is a reasonable step toward unification of
> vmstat, as most vm_even_item entries do make sense to be accounted per
> cgroup as well.
> 
> Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

Thanks!

> > @@ -608,9 +601,9 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
> >  
> >  	/* pagein of a big page is an event. So, ignore page size */
> >  	if (nr_pages > 0)
> > -		__this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGIN]);
> > +		__this_cpu_inc(memcg->stat->events[PGPGIN]);
> >  	else {
> > -		__this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGPGOUT]);
> > +		__this_cpu_inc(memcg->stat->events[PGPGOUT]);
> >  		nr_pages = -nr_pages; /* for event */
> >  	}
> 
> AFAIR this doesn't exactly match system-wide PGPGIN/PGPGOUT: they are
> supposed to account only paging events involving IO while currently they
> include faulting in zero pages and zapping a process address space.
> Probably, this should be revised before rolling out to cgroup v2.

Yeah, that stat item doesn't make much sense in cgroup1. Cgroup2
doesn't export it at all right now. Should we export it in the future,
we can add special MEMCG1_PGPGIN_SILLY events and let cgroup2 use the
real thing. Or remove/fix the stats in cgroup1, because I cannot think
how this would be useful at all right now, anyway.

But it's ooold behavior, so no urgency to tackle this right now.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
