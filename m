From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH -V4 05/10] hugetlb: add charge/uncharge calls for HugeTLB
 alloc/free
Date: Mon, 19 Mar 2012 11:41:07 +0900
Message-ID: <4F669CC3.9070007@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331919570-2264-6-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/03/17 2:39), Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This adds necessary charge/uncharge calls in the HugeTLB code
> 
> Acked-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
A nitpick below.

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


Can't we this initialization in mem_cgroup_hugetlb_charge_page() ?

Thanks,
-Kame
