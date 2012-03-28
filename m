From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V4 05/10] hugetlb: add charge/uncharge calls for HugeTLB
 alloc/free
Date: Wed, 28 Mar 2012 15:17:06 +0200
Message-ID: <20120328131706.GF20949@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1331919570-2264-6-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 16-03-12 23:09:25, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This adds necessary charge/uncharge calls in the HugeTLB code

This begs for more description...
Other than that it looks correct.

> Acked-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  mm/hugetlb.c    |   21 ++++++++++++++++++++-
>  mm/memcontrol.c |    5 +++++
>  2 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c672187..91361a0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -21,6 +21,8 @@
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
>  #include <linux/swapops.h>
> +#include <linux/memcontrol.h>
> +#include <linux/page_cgroup.h>
>  
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
> @@ -542,6 +544,9 @@ static void free_huge_page(struct page *page)
>  	BUG_ON(page_mapcount(page));
>  	INIT_LIST_HEAD(&page->lru);
>  
> +	if (mapping)
> +		mem_cgroup_hugetlb_uncharge_page(hstate_index(h),
> +						 pages_per_huge_page(h), page);
>  	spin_lock(&hugetlb_lock);
>  	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
>  		update_and_free_page(h, page);
> @@ -1019,12 +1024,15 @@ static void vma_commit_reservation(struct hstate *h,
>  static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  				    unsigned long addr, int avoid_reserve)
>  {
> +	int ret, idx;
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *page;
> +	struct mem_cgroup *memcg = NULL;
>  	struct address_space *mapping = vma->vm_file->f_mapping;
>  	struct inode *inode = mapping->host;
>  	long chg;
>  
> +	idx = hstate_index(h);
>  	/*
>  	 * Processes that did not create the mapping will have no reserves and
>  	 * will not have accounted against quota. Check that the quota can be
> @@ -1039,6 +1047,12 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  		if (hugetlb_get_quota(inode->i_mapping, chg))
>  			return ERR_PTR(-ENOSPC);
>  
> +	ret = mem_cgroup_hugetlb_charge_page(idx, pages_per_huge_page(h),
> +					     &memcg);
> +	if (ret) {
> +		hugetlb_put_quota(inode->i_mapping, chg);
> +		return ERR_PTR(-ENOSPC);
> +	}
>  	spin_lock(&hugetlb_lock);
>  	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
>  	spin_unlock(&hugetlb_lock);
> @@ -1046,6 +1060,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	if (!page) {
>  		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
>  		if (!page) {
> +			mem_cgroup_hugetlb_uncharge_memcg(idx,
> +							 pages_per_huge_page(h),
> +							 memcg);
>  			hugetlb_put_quota(inode->i_mapping, chg);
>  			return ERR_PTR(-ENOSPC);
>  		}
> @@ -1054,7 +1071,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	set_page_private(page, (unsigned long) mapping);
>  
>  	vma_commit_reservation(h, vma, addr);
> -
> +	/* update page cgroup details */
> +	mem_cgroup_hugetlb_commit_charge(idx, pages_per_huge_page(h),
> +					 memcg, page);
>  	return page;
>  }
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4b36c5e..7a9ea94 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2901,6 +2901,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
>  
>  	if (PageSwapCache(page))
>  		return NULL;
> +	/*
> +	 * HugeTLB page uncharge happen in the HugeTLB compound page destructor
> +	 */
> +	if (PageHuge(page))
> +		return NULL;
>  
>  	if (PageTransHuge(page)) {
>  		nr_pages <<= compound_order(page);
> -- 
> 1.7.9
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
