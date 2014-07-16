From: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Wed, 16 Jul 2014 10:57:36 -0400
Message-ID: <20140716145736.GA9794@nhori.redhat.com>
References: <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715155537.GA19454@nhori.bos.redhat.com>
 <20140715160735.GB29269@dhcp22.suse.cz>
 <20140715173439.GU29639@cmpxchg.org>
 <20140715184358.GA31550@nhori.bos.redhat.com>
 <20140715190454.GW29639@cmpxchg.org>
 <20140715204953.GA21016@nhori.bos.redhat.com>
 <20140715214843.GX29639@cmpxchg.org>
 <20140716133050.GA4644@nhori.redhat.com>
 <20140716141447.GY29639@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140716141447.GY29639-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 16, 2014 at 10:14:47AM -0400, Johannes Weiner wrote:
...
> > >  	free_hot_cold_page(page, false);
> > >  }
> > >  
> > > @@ -75,7 +75,10 @@ static void __put_compound_page(struct page *page)
> > >  {
> > >  	compound_page_dtor *dtor;
> > >  
> > > -	__page_cache_release(page);
> > > +	if (!PageHuge(page)) {
> > > +		__page_cache_release(page);
> > > +		mem_cgroup_uncharge_page(page);
> 
> I reverted all these mm/swap.c changes again as well.  Instead,
> mem_cgroup_uncharge() now does a preliminary check if the page is
> charged before it touches page->lru.
> 
> That should be much more robust: now the vetting whether a page is
> valid for memcg happens at charge time only, all other operations
> check first if a page is charged before doing anything else to it.
> 
> These two places should be the only ones that need fixing then:

This change also passed my testing, so the problem should be fixed.

Thanks,
Naoya Horiguchi
