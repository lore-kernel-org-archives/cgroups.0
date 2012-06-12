From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH -V8 11/16] hugetlb/cgroup: Add charge/uncharge routines
 for hugetlb cgroup
Date: Tue, 12 Jun 2012 17:08:25 +0900
Message-ID: <4FD6F8F9.2040901@jp.fujitsu.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339232401-14392-12-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/06/09 17:59), Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V"<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This patchset add the charge and uncharge routines for hugetlb cgroup.
> This will be used in later patches when we allocate/free HugeTLB
> pages.
> 
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>


I'm sorry if following has been already pointed out.

> ---
>   mm/hugetlb_cgroup.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 87 insertions(+)
> 
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index 20a32c5..48efd5a 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -105,6 +105,93 @@ static int hugetlb_cgroup_pre_destroy(struct cgroup *cgroup)
>   	   return -EBUSY;
>   }
> 
> +int hugetlb_cgroup_charge_page(int idx, unsigned long nr_pages,
> +			       struct hugetlb_cgroup **ptr)
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
> +	if (hstates[idx].order<  2)
> +		goto done;
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
> +	ret = res_counter_charge(&h_cg->hugepage[idx], csize,&fail_res);
> +	css_put(&h_cg->css);
> +done:
> +	*ptr = h_cg;
> +	return ret;
> +}
> +

Memory cgroup uses very complicated 'charge' routine for handling pageout...
which gets sleep.

For hugetlbfs, it has not sleep routine, you can do charge in simple way.
I guess...get/put here is overkill.

For example, h_cg cannot be freed while it has tasks. So, if 'current' is
belongs to the cgroup, it cannot be disappear. Then, you don't need get/put,
additional atomic ops for holding cgroup.

	rcu_read_lock();
	h_cg = hugetlb_cgroup_from_task(current);
	ret = res_counter_charge(&h_cg->hugetpage[idx], csize,  &fail_res);
	rcu_read_unlock();

	return ret;

Thanks,
-Kame
