From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC] mm/hugetlb_cgroup: Add huge_page_order check to avoid incorrectly uncharge
Date: Tue, 10 Jul 2012 23:11:07 +0530
Message-ID: <87394z1pl8.fsf@skywalker.in.ibm.com>
References: <1341914712-4588-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1341914712-4588-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
> Against linux-next:
>
> Function alloc_huge_page will call hugetlb_cgroup_charge_cgroup
> to charge pages, the compound page have less than 3 pages will not
> charge to hugetlb cgroup. When alloc_huge_page fails it will call
> hugetlb_cgroup_uncharge_cgroup to uncharge pages, however,
> hugetlb_cgroup_uncharge_cgroup doesn't have huge_page_order check.
> That means it will uncharge pages even if the compound page have less
> than 3 pages. Add huge_page_order check to avoid this incorrectly
> uncharge.
>
> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

 Reviewed-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>



> ---
>  mm/hugetlb_cgroup.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index b834e8d..2b9e214 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -252,6 +252,9 @@ void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>
>  	if (hugetlb_cgroup_disabled() || !h_cg)
>  		return;
> +
> +	if (huge_page_order(&hstates[idx]) < HUGETLB_CGROUP_MIN_ORDER)
> +		return;
>
>  	res_counter_uncharge(&h_cg->hugepage[idx], csize);
>  	return;
> -- 
> 1.7.5.4

-aneesh
