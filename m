From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Thu, 24 Jul 2014 11:02:57 +0200
Message-ID: <20140724090257.GB14578@dhcp22.suse.cz>
References: <20140718144554.GG29639@cmpxchg.org>
 <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
 <20140719173911.GA1725@cmpxchg.org>
 <20140722150825.GA4517@dhcp22.suse.cz>
 <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
 <20140723143847.GB16721@dhcp22.suse.cz>
 <20140723150608.GF1725@cmpxchg.org>
 <CAJfpegs-k5QC+42SzLKUSaHrdPxWBaT_dF+SOPqoDvg8h5p_Tw@mail.gmail.com>
 <20140723210241.GH1725@cmpxchg.org>
 <20140724084644.GA14578@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140724084644.GA14578-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu 24-07-14 10:46:44, Michal Hocko wrote:
> On Wed 23-07-14 17:02:41, Johannes Weiner wrote:
[...]
> We can reduce the lookup only to lruvec==true case, no?

Dohh
s@can@should@

newpage shouldn't charged in all other cases and it would be bug.
Or am I missing something?

> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> > ---
> >  mm/memcontrol.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index b7c9a202dee9..3eaa6e83c168 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6660,6 +6660,12 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
> >  	if (mem_cgroup_disabled())
> >  		return;
> >  
> > +	/* Page cache replacement: new page already charged? */
> > +	pc = lookup_page_cgroup(newpage);
> > +	if (PageCgroupUsed(pc))
> > +		return;
> > +
> > +	/* Re-entrant migration: old page already uncharged? */
> >  	pc = lookup_page_cgroup(oldpage);
> >  	if (!PageCgroupUsed(pc))
> >  		return;
> > -- 
> > 2.0.0
> > 
> 
> -- 
> Michal Hocko
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
