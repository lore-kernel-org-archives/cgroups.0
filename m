From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH -V7 10/14] hugetlbfs: Add new HugeTLB cgroup
Date: Thu, 31 May 2012 11:13:16 +0530
Message-ID: <20120531054316.GD24855@skywalker.linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120531011953.GE401@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120531011953.GE401-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konrad Rzeszutek Wilk <konrad-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 30, 2012 at 09:19:54PM -0400, Konrad Rzeszutek Wilk wrote:
> > +static inline bool hugetlb_cgroup_have_usage(struct cgroup *cg)
> > +{
> > +	int idx;
> > +	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_cgroup(cg);
> > +
> > +	for (idx = 0; idx < HUGE_MAX_HSTATE; idx++) {
> > +		if ((res_counter_read_u64(&h_cg->hugepage[idx], RES_USAGE)) > 0)
> > +			return 1;
> 
> return true;
> > +	}
> > +	return 0;
> 
> And return false here
> > +}
> > +
> > +static struct cgroup_subsys_state *hugetlb_cgroup_create(struct cgroup *cgroup)
> > +{
> > +	int idx;
> > +	struct cgroup *parent_cgroup;
> > +	struct hugetlb_cgroup *h_cgroup, *parent_h_cgroup;
> > +
> > +	h_cgroup = kzalloc(sizeof(*h_cgroup), GFP_KERNEL);
> > +	if (!h_cgroup)
> > +		return ERR_PTR(-ENOMEM);
> > +
> 
> No need to check cgroup for NULL?

Other cgroups (memcg) doesn't do that. Can we really get NULL cgroup tere ?


> 
> > +	parent_cgroup = cgroup->parent;
> > +	if (parent_cgroup) {
> > +		parent_h_cgroup = hugetlb_cgroup_from_cgroup(parent_cgroup);
> > +		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
> > +			res_counter_init(&h_cgroup->hugepage[idx],
> > +					 &parent_h_cgroup->hugepage[idx]);
> > +	} else {
> > +		root_h_cgroup = h_cgroup;
> > +		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
> > +			res_counter_init(&h_cgroup->hugepage[idx], NULL);
> > +	}
> > +	return &h_cgroup->css;
> > +}
> > +
> > +static int hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
> > +				      struct page *page)
> > +{
> > +	int csize,  ret = 0;
> > +	struct page_cgroup *pc;
> > +	struct res_counter *counter;
> > +	struct res_counter *fail_res;
> > +	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
> > +	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
> > +
> > +	if (!get_page_unless_zero(page))
> > +		goto out;
> 
> Hmm, so it goes to out, and does return ret. ret is zero. Is
> that correct? Should ret be set to -EBUSY or such?
> 

Fixed

> > +
> > +	pc = lookup_page_cgroup(page);
> 
> What if pc is NULL? Or is it guaranteed that it will
> never happen so?
> 
> > +	lock_page_cgroup(pc);
> > +	if (!PageCgroupUsed(pc) || pc->cgroup != cgroup)
> > +		goto err_out;
> 
> err is still set to zero. Is that OK? Should it be -EINVAL
> or such?
> 

Fixed

> > +
> > +	csize = PAGE_SIZE << compound_order(page);
> > +	/* If use_hierarchy == 0, we need to charge root */
> > +	if (!parent) {
> > +		parent = root_h_cgroup;
> > +		/* root has no limit */
> > +		res_counter_charge_nofail(&parent->hugepage[idx],
> > +					  csize, &fail_res);
> > +	}
> > +	counter = &h_cg->hugepage[idx];
> > +	res_counter_uncharge_until(counter, counter->parent, csize);
> > +
> > +	pc->cgroup = cgroup->parent;
> > +err_out:
> > +	unlock_page_cgroup(pc);
> > +	put_page(page);
> > +out:
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Force the hugetlb cgroup to empty the hugetlb resources by moving them to
> > + * the parent cgroup.
> > + */
> > +static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
> > +{
> > +	struct hstate *h;
> > +	struct page *page;
> > +	int ret = 0, idx = 0;
> > +
> > +	do {
> > +		if (cgroup_task_count(cgroup) ||
> > +		    !list_empty(&cgroup->children)) {
> > +			ret = -EBUSY;
> > +			goto out;
> > +		}
> > +		/*
> > +		 * If the task doing the cgroup_rmdir got a signal
> > +		 * we don't really need to loop till the hugetlb resource
> > +		 * usage become zero.
> 
> Why don't we need to loop? Is somebody else (and if so can you
> say who) doing the deletion?
> 

No we just come out without doing the deletion and handle the signal.

> > +		 */
> > +		if (signal_pending(current)) {
> > +			ret = -EINTR;
> > +			goto out;
> > +		}
> > +		for_each_hstate(h) {
> > +			spin_lock(&hugetlb_lock);
> > +			list_for_each_entry(page, &h->hugepage_activelist, lru) {
> > +				ret = hugetlb_cgroup_move_parent(idx, cgroup, page);
> > +				if (ret) {
> > +					spin_unlock(&hugetlb_lock);
> > +					goto out;
> > +				}
> > +			}
> > +			spin_unlock(&hugetlb_lock);
> > +			idx++;
> > +		}
> > +		cond_resched();
> > +	} while (hugetlb_cgroup_have_usage(cgroup));
> > +out:
> > +	return ret;
> > +}
> > +
> > +static void hugetlb_cgroup_destroy(struct cgroup *cgroup)
> > +{
> > +	struct hugetlb_cgroup *h_cgroup;
> > +
> > +	h_cgroup = hugetlb_cgroup_from_cgroup(cgroup);
> > +	kfree(h_cgroup);
> > +}
> > +
> > +int hugetlb_cgroup_charge_page(int idx, unsigned long nr_pages,
> > +			       struct hugetlb_cgroup **ptr)
> > +{
> > +	int ret = 0;
> > +	struct res_counter *fail_res;
> > +	struct hugetlb_cgroup *h_cg = NULL;
> > +	unsigned long csize = nr_pages * PAGE_SIZE;
> > +
> > +	if (hugetlb_cgroup_disabled())
> > +		goto done;
> > +again:
> > +	rcu_read_lock();
> > +	h_cg = hugetlb_cgroup_from_task(current);
> > +	if (!h_cg)
> > +		h_cg = root_h_cgroup;
> > +
> > +	if (!css_tryget(&h_cg->css)) {
> > +		rcu_read_unlock();
> > +		goto again;
> 
> You don't want some form of limit on how many times you can
> loop around?
> 

you mean fail the allocation after some tries. I am not sure memcg doesn't do that.


> > +	}
> > +	rcu_read_unlock();
> > +
> > +	ret = res_counter_charge(&h_cg->hugepage[idx], csize, &fail_res);
> > +	css_put(&h_cg->css);
> > +done:
> > +	*ptr = h_cg;
> > +	return ret;
> > +}
> > +
> 

-aneesh
