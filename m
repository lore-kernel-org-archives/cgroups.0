From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: remove rcu_read_lock from
 get_mem_cgroup_from_page
Date: Fri, 5 Feb 2021 17:06:18 +0100
Message-ID: <YB1s+puR+zPnkIFe@dhcp22.suse.cz>
References: <20210205062719.74431-1-songmuchun@bytedance.com>
 <YB0DnAlCaQza4Uf9@dhcp22.suse.cz>
 <CAMZfGtVhBrwgkJVwiah6eDsppSf8fYp+uZ=tZmHBLDFeTmQX3w@mail.gmail.com>
 <YB0euLiMU+T/9bMK@dhcp22.suse.cz>
 <CALvZod65SY3yVXSwxO02VCZeEg9KsBqq9_Ph3pq2gfQ0eH=kFw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612541179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X0eNZnPZ2yvNSsohyfO18yi1he4bt+Z9BswCbs9pY3o=;
        b=YTiJoqhqHI2WHfc/9NOnQxXomFQnQCUwdI5oE5KBAXc1O9bZPxV2+A/3GrVxmdvJKCbIc8
        9ChcfYP2M7iEcMltkcdxKxBeP+1W6fktGOqgAaFVj4vBCU4AuFA1sVBIwma+QHOIqOGPkd
        HlvyEvn0XK+Z44oQX8eZCi+9KntjaFw=
Content-Disposition: inline
In-Reply-To: <CALvZod65SY3yVXSwxO02VCZeEg9KsBqq9_Ph3pq2gfQ0eH=kFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri 05-02-21 07:59:06, Shakeel Butt wrote:
> +Cc Roman
> 
> On Fri, Feb 5, 2021 at 2:49 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> [snip]
> > > > > Also, css_get is enough because page
> > > > > has a reference to the memcg.
> > > >
> > > > tryget used to be there to guard against offlined memcg but we have
> > > > concluded this is impossible in this path. tryget stayed there to catch
> > > > some unexpected cases IIRC.
> > >
> > > Yeah, it can catch some unexpected cases. But why is this path
> > > special so that we need a tryget?
> >
> > I do not remember details and the changelog of that change is not
> > explicit but I suspect it was just because this one could trigger as
> > there are external callers to memcg. Is this protection needed? I am not
> > sure, this is for you to justify if you want to remove it.
> >
> 
> It used to be css_tryget_online() which was changed to css_tryget()
> and from the discussion at [1], it seemed css_get() would be enough
> but we took a safer route.
> 
> Anyways, I think we can either take the page_memcg_rcu() route or put
> explicit restrictions with page lock or lock_page_memcg() to guarantee
> page and memcg binding. I don't have a strong opinion either way but I
> think removing restrictions in future for new use-cases will be much
> harder, so, page_memcg_rcu() approach seems more appropriate at least
> for now.

Yeah, I would like to not have very special locking requirements here.
Definitely not page_lock as that one is too overloaded already.

> 
> [1] https://lore.kernel.org/linux-mm/CALvZod5pAv=u8L2Tgk0hDY7XAiiF2dvjC1omQ5BSfzFu_2zSXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

-- 
Michal Hocko
SUSE Labs
