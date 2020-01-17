From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Date: Fri, 17 Jan 2020 10:10:02 +0100
Message-ID: <20200117091002.GM19428@dhcp22.suse.cz>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001161357240.109233-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 16-01-20 14:01:59, David Rientjes wrote:
> On Thu, 16 Jan 2020, Kirill Tkhai wrote:
> 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index c5b5f74cfd4d..6450bbe394e2 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
> > >  	}
> > >  
> > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -	if (compound && !list_empty(page_deferred_list(page))) {
> > > +	if (compound) {
> > >  		spin_lock(&from->deferred_split_queue.split_queue_lock);
> > > -		list_del_init(page_deferred_list(page));
> > > -		from->deferred_split_queue.split_queue_len--;
> > > +		if (!list_empty(page_deferred_list(page))) {
> > > +			list_del_init(page_deferred_list(page));
> > > +			from->deferred_split_queue.split_queue_len--;
> > > +		}
> > >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> > >  	}
> > >  #endif
> > > @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
> > >  	page->mem_cgroup = to;
> > >  
> > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -	if (compound && list_empty(page_deferred_list(page))) {
> > > +	if (compound) {
> > >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> > > -		list_add_tail(page_deferred_list(page),
> > > -			      &to->deferred_split_queue.split_queue);
> > > -		to->deferred_split_queue.split_queue_len++;
> > > +		if (list_empty(page_deferred_list(page))) {
> > > +			list_add_tail(page_deferred_list(page),
> > > +				      &to->deferred_split_queue.split_queue);
> > > +			to->deferred_split_queue.split_queue_len++;
> > > +		}
> > >  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
> > >  	}
> > >  #endif
> > 
> > The patch looks OK for me. But there is another question. I forget, why we unconditionally
> > add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
> > it was initially in the list? Something like:
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d4394ae4e5be..0be0136adaa6 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
> >  	struct pglist_data *pgdat;
> >  	unsigned long flags;
> >  	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
> > +	bool split = false;
> >  	int ret;
> >  	bool anon;
> >  
> > @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
> >  		if (!list_empty(page_deferred_list(page))) {
> >  			list_del_init(page_deferred_list(page));
> >  			from->deferred_split_queue.split_queue_len--;
> > +			split = true;
> >  		}
> >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> >  	}
> > @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
> >  	page->mem_cgroup = to;
> >  
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -	if (compound) {
> > +	if (compound && split) {
> >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> >  		if (list_empty(page_deferred_list(page))) {
> >  			list_add_tail(page_deferred_list(page),
> > 
> 
> I think that's a good point, especially considering that the current code 
> appears to unconditionally place any compound page on the deferred split 
> queue of the destination memcg.  The correct list that it should appear 
> on, I believe, depends on whether the pmd has been split for the process 
> being moved: note the MC_TARGET_PAGE caveat in 
> mem_cgroup_move_charge_pte_range() that does not move the charge for 
> compound pages with split pmds.  So when mem_cgroup_move_account() is 
> called with compound == true, we're moving the charge of the entire 
> compound page: why would it appear on that memcg's deferred split queue?

I believe Kirill asked how do we know that the page should be actually
added to the deferred list just from the list_empty check. In other
words what if the page hasn't been split at all?

-- 
Michal Hocko
SUSE Labs
