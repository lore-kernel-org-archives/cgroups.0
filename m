From: Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH 02/13] mm: use page_off_lru()
Date: Fri, 18 Sep 2020 04:27:13 -0600
Message-ID: <20200918102713.GB1004594@google.com>
References: <20200918030051.650890-1-yuzhao@google.com>
 <20200918030051.650890-3-yuzhao@google.com>
 <20200918073700.GE28827@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NGiEMA4XCl4K+615B920D7aQUry3FhMY/+Djt+whFqk=;
        b=BfSusiEEsa1NXeEVIhqZLCV1KtYitRimBhpYQvTDRPjZwA8Niznd44p/mt3fvgqz92
         TyOI3sUfqBAVzIA5ZyjIsM2Jnv91UbxibfyvI8MEQKlG9rlIkdCILCx3qb6dANANbQMu
         C9JT8sDI4gKJXulouBx0u0liWJiAy6/Uhjzs+V8dLiXmMZXTA0q36Ze0BOJZ5S0dJoZ/
         8gocaTvRbHYOvwKYUNbv6uqH+NPCoJnyojRoATvIc5O5eFSHoFNjU34njF/nJItwsu/B
         uQaCvVr40K27xwOrYgP8X15+qCP8KWx/kVTgTnWbPwj2D+8poiRAcoOFCG11iH5fIB/0
         8BOg==
Content-Disposition: inline
In-Reply-To: <20200918073700.GE28827@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alex.shi@linux.alibaba.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Huang Ying <ying.huang@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Matthew Wilcox <willy@infradead.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Minchan Kim <minchan@kernel.org>, Jaewon Kim <jaewon31.kim@samsung.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri, Sep 18, 2020 at 09:37:00AM +0200, Michal Hocko wrote:
> On Thu 17-09-20 21:00:40, Yu Zhao wrote:
> > This patch replaces the only open-coded __ClearPageActive() with
> > page_off_lru(). There is no open-coded __ClearPageUnevictable()s.
> > 
> > Before this patch, we have:
> > 	__ClearPageActive()
> > 	add_page_to_lru_list()
> > 
> > After this patch, we have:
> > 	page_off_lru()
> > 		if PageUnevictable()
> > 			__ClearPageUnevictable()
> > 		else if PageActive()
> > 			__ClearPageActive()
> > 	add_page_to_lru_list()
> > 
> > Checking PageUnevictable() shouldn't be a problem because these two
> > flags are mutually exclusive. Leaking either will trigger bad_page().
> 
> I am sorry but the changelog is really hard to grasp. What are you
> trying to achieve, why and why it is safe. This should be a general
> outline for any patch. I have already commented on the previous patch
> and asked you for the explanation why removing __ClearPageActive from
> this path is desirable and safe. I have specifically asked to clarify
> the compound page situation as that is using its oen destructor in the
> freeing path and that might result in page_off_lru to be not called.

Haven't I explained we are NOT removing __ClearPageActive()? Is my
notion of the code structure above confusing you? Or 'open-coded'
could mean different things?

And I have asked this before: why does 'the compound page situation'
even matter here? Perhaps if you could give a concrete example related
to the code change and help me understand your concern?

> > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > ---
> >  mm/vmscan.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 503fc5e1fe32..f257d2f61574 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1845,7 +1845,6 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
> >  	int nr_pages, nr_moved = 0;
> >  	LIST_HEAD(pages_to_free);
> >  	struct page *page;
> > -	enum lru_list lru;
> >  
> >  	while (!list_empty(list)) {
> >  		page = lru_to_page(list);
> > @@ -1860,14 +1859,11 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
> >  		lruvec = mem_cgroup_page_lruvec(page, pgdat);
> >  
> >  		SetPageLRU(page);
> > -		lru = page_lru(page);
> > -
> >  		add_page_to_lru_list(page, lruvec, lru);
> >  
> >  		if (put_page_testzero(page)) {
> >  			__ClearPageLRU(page);
> > -			__ClearPageActive(page);
> > -			del_page_from_lru_list(page, lruvec, lru);
> > +			del_page_from_lru_list(page, lruvec, page_off_lru(page));
> >  
> >  			if (unlikely(PageCompound(page))) {
> >  				spin_unlock_irq(&pgdat->lru_lock);
> > -- 
> > 2.28.0.681.g6f77f65b4e-goog
> 
> -- 
> Michal Hocko
> SUSE Labs
