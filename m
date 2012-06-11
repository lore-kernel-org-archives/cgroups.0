From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V8 14/16] hugetlb/cgroup: add charge/uncharge calls for
 HugeTLB alloc/free
Date: Mon, 11 Jun 2012 11:21:33 +0200
Message-ID: <20120611092133.GI12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1339232401-14392-15-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 09-06-12 14:29:59, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This adds necessary charge/uncharge calls in the HugeTLB code.  We do
> hugetlb cgroup charge in page alloc and uncharge in compound page destructor.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
>  mm/hugetlb.c        |   16 +++++++++++++++-
>  mm/hugetlb_cgroup.c |    7 +------
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index bf79131..4ca92a9 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -628,6 +628,8 @@ static void free_huge_page(struct page *page)
>  	BUG_ON(page_mapcount(page));
>  
>  	spin_lock(&hugetlb_lock);
> +	hugetlb_cgroup_uncharge_page(hstate_index(h),
> +				     pages_per_huge_page(h), page);
>  	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
>  		/* remove the page from active list */
>  		list_del(&page->lru);
> @@ -1116,7 +1118,10 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *page;
>  	long chg;
> +	int ret, idx;
> +	struct hugetlb_cgroup *h_cg;
>  
> +	idx = hstate_index(h);
>  	/*
>  	 * Processes that did not create the mapping will have no
>  	 * reserves and will not have accounted against subpool
> @@ -1132,6 +1137,11 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  		if (hugepage_subpool_get_pages(spool, chg))
>  			return ERR_PTR(-ENOSPC);
>  
> +	ret = hugetlb_cgroup_charge_page(idx, pages_per_huge_page(h), &h_cg);

So we do not have any page yet and hugetlb_cgroup_charge_cgroup sound
more appropriate

[...]
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
