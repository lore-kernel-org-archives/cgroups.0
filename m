From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 02/13] mm: use page_off_lru()
Date: Fri, 18 Sep 2020 13:24:21 +0200
Message-ID: <20200918112421.GL28827@dhcp22.suse.cz>
References: <20200918030051.650890-1-yuzhao@google.com>
 <20200918030051.650890-3-yuzhao@google.com>
 <20200918073700.GE28827@dhcp22.suse.cz>
 <20200918102713.GB1004594@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600428262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d9PDsqIPyVPgLukahRA3ETtD+nKIvQ1Ol6YmX3nuefQ=;
        b=FN30aRJ+ozUNW8fiN2FsyLCLrqgxgpM8NlMau1poGqllAwZcl0sFk4WIV0FXGuQOCDsHaB
        xt5dtdhGhw0LG9dsXVvBh0Eww6TzCSGW9Zmd4Zj+jJlGBwh4qNgpD+nmqrKsHRxQpwpjT5
        fs8B3XBQGbuNi3wHzkHLM0Y0N7GQDXc=
Content-Disposition: inline
In-Reply-To: <20200918102713.GB1004594-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pankaj Gupta <pankaj.gupta.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaewon Kim <jaewon31.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 18-09-20 04:27:13, Yu Zhao wrote:
> On Fri, Sep 18, 2020 at 09:37:00AM +0200, Michal Hocko wrote:
[...]
> And I have asked this before: why does 'the compound page situation'
> even matter here? Perhaps if you could give a concrete example related
> to the code change and help me understand your concern?

Forgot to answer this part. The compound page concern is a misreading of
the patch on my end. I have missed you are using page_off_lru in this
(move_pages_to_lru) path and that you rely on release_pages to do the
clean up on you. I still find it rather awkward that page_off_lru has
such side effects but I am not deeply familiar with the reasoning
behind so I will rather shut up now.

[...]
> > > @@ -1860,14 +1859,11 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
> > >  		lruvec = mem_cgroup_page_lruvec(page, pgdat);
> > >  
> > >  		SetPageLRU(page);
> > > -		lru = page_lru(page);
> > > -
> > >  		add_page_to_lru_list(page, lruvec, lru);
> > >  
> > >  		if (put_page_testzero(page)) {
> > >  			__ClearPageLRU(page);
> > > -			__ClearPageActive(page);
> > > -			del_page_from_lru_list(page, lruvec, lru);
> > > +			del_page_from_lru_list(page, lruvec, page_off_lru(page));
> > >  
> > >  			if (unlikely(PageCompound(page))) {
> > >  				spin_unlock_irq(&pgdat->lru_lock);
> > > -- 
> > > 2.28.0.681.g6f77f65b4e-goog
> > 
> > -- 
> > Michal Hocko
> > SUSE Labs

-- 
Michal Hocko
SUSE Labs
