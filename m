From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 1/3] mm: memcontrol: lockless page counters
Date: Wed, 8 Oct 2014 08:31:34 -0400
Message-ID: <20141008123134.GA14361@cmpxchg.org>
References: <1411573390-9601-1-git-send-email-hannes@cmpxchg.org>
 <1411573390-9601-2-git-send-email-hannes@cmpxchg.org>
 <20141007151543.GE14243@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20141007151543.GE14243@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov@parallels.com>, Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:15:43PM +0200, Michal Hocko wrote:
> On Wed 24-09-14 11:43:08, Johannes Weiner wrote:
> > @@ -1490,12 +1495,23 @@ int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
> >   */
> >  static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
> >  {
> > -	unsigned long long margin;
> > +	unsigned long margin = 0;
> > +	unsigned long count;
> > +	unsigned long limit;
> >  
> > -	margin = res_counter_margin(&memcg->res);
> > -	if (do_swap_account)
> > -		margin = min(margin, res_counter_margin(&memcg->memsw));
> > -	return margin >> PAGE_SHIFT;
> > +	count = page_counter_read(&memcg->memory);
> > +	limit = ACCESS_ONCE(memcg->memory.limit);
> > +	if (count < limit)
> > +		margin = limit - count;
> > +
> > +	if (do_swap_account) {
> > +		count = page_counter_read(&memcg->memsw);
> > +		limit = ACCESS_ONCE(memcg->memsw.limit);
> > +		if (count < limit)
> 
> I guess you wanted (count <= limit) here?

Yes.  Fixed it up, thanks.

> > @@ -2293,33 +2295,31 @@ static DEFINE_MUTEX(percpu_charge_mutex);
> >  static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  {
> >  	struct memcg_stock_pcp *stock;
> > -	bool ret = true;
> > +	bool ret = false;
> >  
> >  	if (nr_pages > CHARGE_BATCH)
> > -		return false;
> > +		return ret;
> >  
> >  	stock = &get_cpu_var(memcg_stock);
> > -	if (memcg == stock->cached && stock->nr_pages >= nr_pages)
> > +	if (memcg == stock->cached && stock->nr_pages >= nr_pages) {
> >  		stock->nr_pages -= nr_pages;
> > -	else /* need to call res_counter_charge */
> > -		ret = false;
> > +		ret = true;
> > +	}
> >  	put_cpu_var(memcg_stock);
> >  	return ret;
> 
> This change is not really needed but at least it woke me up after some
> monotonic and mechanical changes...

This hunk started with removing the res_counter_charge comment.  IIRC,
Andrew advocated minor cleanups in the area in the past, so I figured
I make the thing a bit more readable while I'm there anyway.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
