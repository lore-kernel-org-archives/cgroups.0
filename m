From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V8 11/16] hugetlb/cgroup: Add charge/uncharge routines
 for hugetlb cgroup
Date: Mon, 11 Jun 2012 10:38:10 +0200
Message-ID: <20120611083810.GC12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1339232401-14392-12-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 09-06-12 14:29:56, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This patchset add the charge and uncharge routines for hugetlb cgroup.
> This will be used in later patches when we allocate/free HugeTLB
> pages.

Please describe the locking rules.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  mm/hugetlb_cgroup.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
> 
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index 20a32c5..48efd5a 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -105,6 +105,93 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
>  	   return -EBUSY;
>  }
>  
> +int hugetlb_cgroup_charge_page(int idx, unsigned long nr_pages,
> +			       struct hugetlb_cgroup **ptr)

Missing doc.

> +{
> +	int ret = 0;
> +	struct res_counter *fail_res;
> +	struct hugetlb_cgroup *h_cg = NULL;
> +	unsigned long csize = nr_pages * PAGE_SIZE;
> +
> +	if (hugetlb_cgroup_disabled())
> +		goto done;
> +	/*
> +	 * We don't charge any cgroup if the compound page have less
> +	 * than 3 pages.
> +	 */
> +	if (hstates[idx].order < 2)
> +		goto done;

huge_page_order here? Not that important because we are using order in
the code directly at many places but easier for grep and maybe worth a
separate clean up patch.

> +again:
> +	rcu_read_lock();
> +	h_cg = hugetlb_cgroup_from_task(current);
> +	if (!h_cg)
> +		h_cg = root_h_cgroup;
> +
> +	if (!css_tryget(&h_cg->css)) {
> +		rcu_read_unlock();
> +		goto again;
> +	}
> +	rcu_read_unlock();
> +
> +	ret = res_counter_charge(&h_cg->hugepage[idx], csize, &fail_res);
> +	css_put(&h_cg->css);
> +done:
> +	*ptr = h_cg;
> +	return ret;
> +}
> +
> +void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> +				  struct hugetlb_cgroup *h_cg,
> +				  struct page *page)
> +{
> +	if (hugetlb_cgroup_disabled() || !h_cg)
> +		return;
> +
> +	spin_lock(&hugetlb_lock);
> +	if (hugetlb_cgroup_from_page(page)) {

How can this happen? Is it possible that two CPUs are trying to charge
one page?

> +		hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
> +		goto done;
> +	}
> +	set_hugetlb_cgroup(page, h_cg);
> +done:
> +	spin_unlock(&hugetlb_lock);
> +	return;
> +}
> +
> +void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
> +				  struct page *page)
> +{
> +	struct hugetlb_cgroup *h_cg;
> +	unsigned long csize = nr_pages * PAGE_SIZE;
> +
> +	if (hugetlb_cgroup_disabled())
> +		return;
> +
> +	spin_lock(&hugetlb_lock);
> +	h_cg = hugetlb_cgroup_from_page(page);
> +	if (unlikely(!h_cg)) {
> +		spin_unlock(&hugetlb_lock);
> +		return;
> +	}
> +	set_hugetlb_cgroup(page, NULL);
> +	spin_unlock(&hugetlb_lock);
> +
> +	res_counter_uncharge(&h_cg->hugepage[idx], csize);
> +	return;
> +}
> +
> +void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
> +				    struct hugetlb_cgroup *h_cg)
> +{

Really worth a separate function to do the same tests again?
Will have a look at the follow up patches. It would be much easier if
the functions were used in the same patch...

> +	unsigned long csize = nr_pages * PAGE_SIZE;
> +
> +	if (hugetlb_cgroup_disabled() || !h_cg)
> +		return;
> +
> +	res_counter_uncharge(&h_cg->hugepage[idx], csize);
> +	return;
> +}
> +
>  struct cgroup_subsys hugetlb_subsys = {
>  	.name = "hugetlb",
>  	.create     = hugetlb_cgroup_create,
> -- 
> 1.7.10
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
