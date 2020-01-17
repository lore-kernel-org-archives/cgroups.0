From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Date: Sat, 18 Jan 2020 01:57:13 +0300
Message-ID: <20200117225713.6acrtyuymklccglv@black.fi.intel.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
 <20200117091002.GM19428@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001170125350.20618@chino.kir.corp.google.com>
 <20200117153839.pcnfomzuaha3dafh@box>
 <4d117021-da90-6069-1991-4df2249567f8@linux.alibaba.com>
 <20200117221859.GA29229@richard>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200117221859.GA29229@richard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Fri, Jan 17, 2020 at 10:18:59PM +0000, Wei Yang wrote:
> On Fri, Jan 17, 2020 at 11:17:38AM -0800, Yang Shi wrote:
> >
> >
> >On 1/17/20 7:38 AM, Kirill A. Shutemov wrote:
> >> On Fri, Jan 17, 2020 at 01:31:50AM -0800, David Rientjes wrote:
> >> > On Fri, 17 Jan 2020, Michal Hocko wrote:
> >> > 
> >> > > On Thu 16-01-20 14:01:59, David Rientjes wrote:
> >> > > > On Thu, 16 Jan 2020, Kirill Tkhai wrote:
> >> > > > 
> >> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> > > > > > index c5b5f74cfd4d..6450bbe394e2 100644
> >> > > > > > --- a/mm/memcontrol.c
> >> > > > > > +++ b/mm/memcontrol.c
> >> > > > > > @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
> >> > > > > >   	}
> >> > > > > >   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >> > > > > > -	if (compound && !list_empty(page_deferred_list(page))) {
> >> > > > > > +	if (compound) {
> >> > > > > >   		spin_lock(&from->deferred_split_queue.split_queue_lock);
> >> > > > > > -		list_del_init(page_deferred_list(page));
> >> > > > > > -		from->deferred_split_queue.split_queue_len--;
> >> > > > > > +		if (!list_empty(page_deferred_list(page))) {
> >> > > > > > +			list_del_init(page_deferred_list(page));
> >> > > > > > +			from->deferred_split_queue.split_queue_len--;
> >> > > > > > +		}
> >> > > > > >   		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> >> > > > > >   	}
> >> > > > > >   #endif
> >> > > > > > @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
> >> > > > > >   	page->mem_cgroup = to;
> >> > > > > >   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >> > > > > > -	if (compound && list_empty(page_deferred_list(page))) {
> >> > > > > > +	if (compound) {
> >> > > > > >   		spin_lock(&to->deferred_split_queue.split_queue_lock);
> >> > > > > > -		list_add_tail(page_deferred_list(page),
> >> > > > > > -			      &to->deferred_split_queue.split_queue);
> >> > > > > > -		to->deferred_split_queue.split_queue_len++;
> >> > > > > > +		if (list_empty(page_deferred_list(page))) {
> >> > > > > > +			list_add_tail(page_deferred_list(page),
> >> > > > > > +				      &to->deferred_split_queue.split_queue);
> >> > > > > > +			to->deferred_split_queue.split_queue_len++;
> >> > > > > > +		}
> >> > > > > >   		spin_unlock(&to->deferred_split_queue.split_queue_lock);
> >> > > > > >   	}
> >> > > > > >   #endif
> >> > > > > The patch looks OK for me. But there is another question. I forget, why we unconditionally
> >> > > > > add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
> >> > > > > it was initially in the list? Something like:
> >> > > > > 
> >> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> > > > > index d4394ae4e5be..0be0136adaa6 100644
> >> > > > > --- a/mm/memcontrol.c
> >> > > > > +++ b/mm/memcontrol.c
> >> > > > > @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
> >> > > > >   	struct pglist_data *pgdat;
> >> > > > >   	unsigned long flags;
> >> > > > >   	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
> >> > > > > +	bool split = false;
> >> > > > >   	int ret;
> >> > > > >   	bool anon;
> >> > > > > @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
> >> > > > >   		if (!list_empty(page_deferred_list(page))) {
> >> > > > >   			list_del_init(page_deferred_list(page));
> >> > > > >   			from->deferred_split_queue.split_queue_len--;
> >> > > > > +			split = true;
> >> > > > >   		}
> >> > > > >   		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> >> > > > >   	}
> >> > > > > @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
> >> > > > >   	page->mem_cgroup = to;
> >> > > > >   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >> > > > > -	if (compound) {
> >> > > > > +	if (compound && split) {
> >> > > > >   		spin_lock(&to->deferred_split_queue.split_queue_lock);
> >> > > > >   		if (list_empty(page_deferred_list(page))) {
> >> > > > >   			list_add_tail(page_deferred_list(page),
> >> > > > > 
> >> > > > I think that's a good point, especially considering that the current code
> >> > > > appears to unconditionally place any compound page on the deferred split
> >> > > > queue of the destination memcg.  The correct list that it should appear
> >> > > > on, I believe, depends on whether the pmd has been split for the process
> >> > > > being moved: note the MC_TARGET_PAGE caveat in
> >> > > > mem_cgroup_move_charge_pte_range() that does not move the charge for
> >> > > > compound pages with split pmds.  So when mem_cgroup_move_account() is
> >> > > > called with compound == true, we're moving the charge of the entire
> >> > > > compound page: why would it appear on that memcg's deferred split queue?
> >> > > I believe Kirill asked how do we know that the page should be actually
> >> > > added to the deferred list just from the list_empty check. In other
> >> > > words what if the page hasn't been split at all?
> >> > > 
> >> > Right, and I don't think that it necessarily is and the second
> >> > conditional in Wei's patch will always succeed unless we have raced.  That
> >> > patch is for a lock concern but I think Kirill's question has uncovered
> >> > something more interesting.
> >> > 
> >> > Kirill S would definitely be best to answer Kirill T's question, but from
> >> > my understanding when mem_cgroup_move_account() is called with
> >> > compound == true that we always have an intact pmd (we never migrate
> >> > partial page charges for pages on the deferred split queue with the
> >> > current charge migration implementation) and thus the underlying page is
> >> > not eligible to be split and shouldn't be on the deferred split queue.
> >> > 
> >> > In other words, a page being on the deferred split queue for a memcg
> >> > should only happen when it is charged to that memcg.  (This wasn't the
> >> > case when we only had per-node split queues.)  I think that's currently
> >> > broken in mem_cgroup_move_account() before Wei's patch.
> >> Right. It's broken indeed.
> >
> >Hmm... Yes, definitely. I wasn't realized this at the first place.
> >
> >> 
> >> We are dealing with anon page here. And it cannot be on deferred list as
> >> long as it's mapped with PMD. We cannot get compound == true &&
> >> !list_empty() on the (first) enter to the function. Any PMD-mapped page
> >> will be put onto deferred by the function. This is wrong.
> >> 
> >> The fix is not obvious.
> >> 
> >> This comment got in mem_cgroup_move_charge_pte_range() my attention:
> >> 
> >> 			/*
> >> 			 * We can have a part of the split pmd here. Moving it
> >> 			 * can be done but it would be too convoluted so simply
> >> 			 * ignore such a partial THP and keep it in original
> >> 			 * memcg. There should be somebody mapping the head.
> >> 			 */
> >> 
> >> That's exactly the case we care about: PTE-mapped THP that has to be split
> >> under load. We don't move charge of them between memcgs and therefore we
> >> should not move the page to different memcg.
> >> 
> >> I guess this will do the trick :P
> >
> >It seems correct to me. In addition, memcg move charge just move PMD mapped
> >THP, the THP should be never on the deferred split queue of "from" if it is
> >PMD mapped, so actually we don't have to move it to the deferred split queue
> >of "to".
> >
> 
> Well, I got the point.
> 
> Since Kirill S found the correct solution, should I prepare v3 or Kirill will
> send it?

Go ahead. With my Suggested-by.

-- 
 Kirill A. Shutemov
