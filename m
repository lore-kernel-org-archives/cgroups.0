From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol:rewrite mem_cgroup_page_lruvec()
Date: Thu, 5 Nov 2020 08:26:52 +0100
Message-ID: <20201105072652.GA21348@dhcp22.suse.cz>
References: <20201104142516.GA106571@rlk>
 <20201104223800.GD1938922@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604561213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7u8WU2glLXwmDXGmWhq8HEE0VcTO5euQA0K+KFX8imM=;
        b=CKGlAZyPZ4aTYZUlXLHpQXRt2TISR1HhHVdLGTH0ns+IR/vvZeP4nXAmF7xQs8Gcm3mcAT
        364yvAObtYTkvBCbY5jTa9rz2u287WqQHDXs7j6mvVgx2r6trkHfmAr8j8LmivMGE5LPb/
        lN+iKojPT5oJ3DBCBVRt+vpDOFUb9eU=
Content-Disposition: inline
In-Reply-To: <20201104223800.GD1938922-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 04-11-20 14:38:00, Roman Gushchin wrote:
> On Wed, Nov 04, 2020 at 10:25:16PM +0800, Hui Su wrote:
> > mem_cgroup_page_lruvec() in memcontrol.c and
> > mem_cgroup_lruvec() in memcontrol.h is very similar
> > except for the param(page and memcg) which also can be
> > convert to each other.
> > 
> > So rewrite mem_cgroup_page_lruvec() with mem_cgroup_lruvec().
> > 
> > Signed-off-by: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
> > ---
> >  include/linux/memcontrol.h | 18 +++++++++++++++--
> >  mm/memcontrol.c            | 40 --------------------------------------
> >  2 files changed, 16 insertions(+), 42 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index e391e3c56de5..a586363fb766 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -457,9 +457,10 @@ mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
> >  /**
> >   * mem_cgroup_lruvec - get the lru list vector for a memcg & node
> >   * @memcg: memcg of the wanted lruvec
> > + * @pgdat: pglist_data
> >   *
> >   * Returns the lru list vector holding pages for a given @memcg &
> > - * @node combination. This can be the node lruvec, if the memory
> > + * @pgdat combination. This can be the node lruvec, if the memory
> >   * controller is disabled.
> >   */
> >  static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
> > @@ -489,7 +490,20 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
> >  	return lruvec;
> >  }
> 
> Hi Hui,
> 
> >  
> > -struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
> > +/**
> > + * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
> > + * @page: the page
> > + * @pgdat: pgdat of the page
> > + *
> > + * This function relies on page->mem_cgroup being stable.
> > + */
> > +static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
> > +						struct pglist_data *pgdat)
> 
> Hm, do we need to pass page and pgdat?

Not really because page already knows its node so pgdat can be easily
taken from there. I suspect the only reason for having pgdat here is
that many callers already know it and we optimize for memcg disable
case. Hard to tell whether this actually matters because most of those
paths are not really hot but something that would require a deeper
investigation. Hint hint...

Anyway, this looks like a nice simplification already. There were some
attempts to do similar thing recently but they were adding nodeid as an
additional argument and I really disliked those.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

-- 
Michal Hocko
SUSE Labs
