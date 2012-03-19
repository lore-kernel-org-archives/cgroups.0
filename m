From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH -V4 08/10] hugetlbfs: Add a list for tracking in-use HugeTLB
 pages
Date: Mon, 19 Mar 2012 12:00:43 +0900
Message-ID: <4F66A15B.7070804@jp.fujitsu.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331919570-2264-9-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/03/17 2:39), Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> hugepage_activelist will be used to track currently used HugeTLB pages.
> We need to find the in-use HugeTLB pages to support memcg removal.
> On memcg removal we update the page's memory cgroup to point to
> parent cgroup.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
 
seems ok to me but...why the new list is not per node ? no benefit ?

Thanks,
-Kame

> ---
>  include/linux/hugetlb.h |    1 +
>  mm/hugetlb.c            |   23 ++++++++++++++++++-----
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index cbd8dc5..6919100 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -217,6 +217,7 @@ struct hstate {
>  	unsigned long resv_huge_pages;
>  	unsigned long surplus_huge_pages;
>  	unsigned long nr_overcommit_huge_pages;
> +	struct list_head hugepage_activelist;
>  	struct list_head hugepage_freelists[MAX_NUMNODES];
>  	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>  	unsigned int free_huge_pages_node[MAX_NUMNODES];
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 684849a..8fd465d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -433,7 +433,7 @@ void copy_huge_page(struct page *dst, struct page *src)
>  static void enqueue_huge_page(struct hstate *h, struct page *page)
>  {
>  	int nid = page_to_nid(page);
> -	list_add(&page->lru, &h->hugepage_freelists[nid]);
> +	list_move(&page->lru, &h->hugepage_freelists[nid]);
>  	h->free_huge_pages++;
>  	h->free_huge_pages_node[nid]++;
>  }
> @@ -445,7 +445,7 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
>  	if (list_empty(&h->hugepage_freelists[nid]))
>  		return NULL;
>  	page = list_entry(h->hugepage_freelists[nid].next, struct page, lru);
> -	list_del(&page->lru);
> +	list_move(&page->lru, &h->hugepage_activelist);
>  	set_page_refcounted(page);
>  	h->free_huge_pages--;
>  	h->free_huge_pages_node[nid]--;
> @@ -542,13 +542,14 @@ static void free_huge_page(struct page *page)
>  	page->mapping = NULL;
>  	BUG_ON(page_count(page));
>  	BUG_ON(page_mapcount(page));
> -	INIT_LIST_HEAD(&page->lru);
>  
>  	if (mapping)
>  		mem_cgroup_hugetlb_uncharge_page(hstate_index(h),
>  						 pages_per_huge_page(h), page);
>  	spin_lock(&hugetlb_lock);
>  	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
> +		/* remove the page from active list */
> +		list_del(&page->lru);
>  		update_and_free_page(h, page);
>  		h->surplus_huge_pages--;
>  		h->surplus_huge_pages_node[nid]--;
> @@ -562,6 +563,7 @@ static void free_huge_page(struct page *page)
>  
>  static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
>  {
> +	INIT_LIST_HEAD(&page->lru);
>  	set_compound_page_dtor(page, free_huge_page);
>  	spin_lock(&hugetlb_lock);
>  	h->nr_huge_pages++;
> @@ -1861,6 +1863,7 @@ void __init hugetlb_add_hstate(unsigned order)
>  	h->free_huge_pages = 0;
>  	for (i = 0; i < MAX_NUMNODES; ++i)
>  		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
> +	INIT_LIST_HEAD(&h->hugepage_activelist);
>  	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
>  	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
>  	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
> @@ -2319,14 +2322,24 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
>  		page = pte_page(pte);
>  		if (pte_dirty(pte))
>  			set_page_dirty(page);
> -		list_add(&page->lru, &page_list);
> +
> +		spin_lock(&hugetlb_lock);
> +		list_move(&page->lru, &page_list);
> +		spin_unlock(&hugetlb_lock);
>  	}
>  	spin_unlock(&mm->page_table_lock);
>  	flush_tlb_range(vma, start, end);
>  	mmu_notifier_invalidate_range_end(mm, start, end);
>  	list_for_each_entry_safe(page, tmp, &page_list, lru) {
>  		page_remove_rmap(page);
> -		list_del(&page->lru);
> +		/*
> +		 * We need to move it back huge page active list. If we are
> +		 * holding the last reference, below put_page will move it
> +		 * back to free list.
> +		 */
> +		spin_lock(&hugetlb_lock);
> +		list_move(&page->lru, &h->hugepage_activelist);
> +		spin_unlock(&hugetlb_lock);
>  		put_page(page);
>  	}
>  }


