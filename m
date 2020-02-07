From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 7/9] hugetlb: support file_region coalescing again
Date: Thu, 6 Feb 2020 16:17:25 -0800
Message-ID: <2541c294-9f61-083b-9a0d-0dfdc3dcac68@oracle.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-7-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8q+PI4HBBqgk9/uOmX8KlKH3mh56uqUtkuyGi+Xq8xI=;
 b=YLcZjr0a0Gu7ySbbcLubRXz8fUtzseoH51sGm3fpzyK6n2nK16yza+zolWiSJbTh6QYX
 HSbyGWsQH9MX1eCOmmc6IpSna8jzq6vBEhTUBvzMJZQaPO6vjfnPmEacv+IY6kOP4GBV
 KM5M0xys+WVcxv9dlINeqLPoHwMeHVNsIR+X4tqlqxZOvEP2+DeYtX1h9lYQFdAgqLNY
 BRpUD9Kzyq/4F12nLmneTnlReIXRiw/CyxFo3vE549/foO84xrH3mOWQPdXg6/cXSQxs
 CPe9GVDhjaMS+QPx3DMzSU85aGJrgN77HTuBVvWic0xXaxE/kRtSc1vkdCmdJHgGEfYp UA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=8q+PI4HBBqgk9/uOmX8KlKH3mh56uqUtkuyGi+Xq8xI=;
 b=NTbyxK9ePH9emfK9Fnrf2fl3L7E9Lt2p0q4OLaExqY2YudCP+WduBnrGRe8Xl1F/uSXK
 hOxjl6xWnaC7tvRUP8tNyMwA08o6qs0W2fEOTpD3qpAaQVhqgAmI5GtuqhyA1eSePCKl
 iIaP6dTSHD5Z+DFdvnQjIRDsaTFKfFxLaJ9RG8l5mmkMjgskdFsiwv30NESTRcrKfXas
 wqc929/Ubh/C79G9JfACTuTQ5btkMqx2vZrdWyGEJuT6MuINL7zDEGtk+GU0VsRRbqlv
 2xL8aQpZ6jmzybCUvsbWnYfpL65EqNYnCoNyGAdnM4gUmQBHd6VMgdP/PJRsQGN42QB+ 8g== 
In-Reply-To: <20200203232248.104733-7-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/3/20 3:22 PM, Mina Almasry wrote:
> An earlier patch in this series disabled file_region coalescing in order
> to hang the hugetlb_cgroup uncharge info on the file_region entries.
> 
> This patch re-adds support for coalescing of file_region entries.
> Essentially everytime we add an entry, we check to see if the
> hugetlb_cgroup uncharge info is the same as any adjacent entries. If it
> is, instead of adding an entry we simply extend the appropriate entry.
> 
> This is an important performance optimization as private mappings add
> their entries page by page, and we could incur big performance costs for
> large mappings with lots of file_region entries in their resv_map.
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  mm/hugetlb.c | 62 +++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 52 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ec0b55ea1506e..058dd9c8269cf 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -272,6 +272,22 @@ static void record_hugetlb_cgroup_uncharge_info(struct hugetlb_cgroup *h_cg,
>  #endif
>  }
> 
> +static bool has_same_uncharge_info(struct file_region *rg,
> +				   struct hugetlb_cgroup *h_cg,
> +				   struct hstate *h)
> +{
> +#ifdef CONFIG_CGROUP_HUGETLB
> +	return rg &&
> +	       rg->reservation_counter ==
> +		       &h_cg->rsvd_hugepage[hstate_index(h)] &&
> +	       rg->pages_per_hpage == pages_per_huge_page(h) &&
> +	       rg->css == &h_cg->css;
> +
> +#else
> +	return true;
> +#endif
> +}
> +
>  /* Must be called with resv->lock held. Calling this with count_only == true
>   * will count the number of pages to be added but will not modify the linked
>   * list. If regions_needed != NULL and count_only == true, then regions_needed
> @@ -286,7 +302,7 @@ static long add_reservation_in_range(struct resv_map *resv, long f, long t,
>  	long add = 0;
>  	struct list_head *head = &resv->regions;
>  	long last_accounted_offset = f;
> -	struct file_region *rg = NULL, *trg = NULL, *nrg = NULL;
> +	struct file_region *rg = NULL, *trg = NULL, *nrg = NULL, *prg = NULL;
> 
>  	if (regions_needed)
>  		*regions_needed = 0;
> @@ -318,16 +334,34 @@ static long add_reservation_in_range(struct resv_map *resv, long f, long t,

I seem to be missing something.  For context, here is the beginning of that
loop:

	/* In this loop, we essentially handle an entry for the range
	 * [last_accounted_offset, rg->from), at every iteration, with some
	 * bounds checking.
	 */
	list_for_each_entry_safe(rg, trg, head, link) {
		/* Skip irrelevant regions that start before our range. */
		if (rg->from < f) {
			/* If this region ends after the last accounted offset,
			 * then we need to update last_accounted_offset.
			 */
			if (rg->to > last_accounted_offset)
				last_accounted_offset = rg->to;
			continue;
		}

		/* When we find a region that starts beyond our range, we've
		 * finished.
		 */
		if (rg->from > t)
			break;

Suppose the resv_map contains one entry [0,2) and we are going to add
[2,4).  Will we not 'continue' after the first entry and then exit loop
without setting prg?  So, there is no chance for coalescing?

-- 
Mike Kravetz

>  		if (rg->from > last_accounted_offset) {
>  			add += rg->from - last_accounted_offset;
>  			if (!count_only) {
> -				nrg = get_file_region_entry_from_cache(
> -					resv, last_accounted_offset, rg->from);
> -				record_hugetlb_cgroup_uncharge_info(h_cg, nrg,
> -								    h);
> -				list_add(&nrg->link, rg->link.prev);
> +				/* Check if the last region can be extended. */
> +				if (prg && prg->to == last_accounted_offset &&
> +				    has_same_uncharge_info(prg, h_cg, h)) {
> +					prg->to = rg->from;
> +				/* Check if the next region can be extended. */
> +				} else if (has_same_uncharge_info(rg, h_cg,
> +								  h)) {
> +					rg->from = last_accounted_offset;
> +				/* If neither of the regions can be extended,
> +				 * add a region.
> +				 */
> +				} else {
> +					nrg = get_file_region_entry_from_cache(
> +						resv, last_accounted_offset,
> +						rg->from);
> +					record_hugetlb_cgroup_uncharge_info(
> +						h_cg, nrg, h);
> +					list_add(&nrg->link, rg->link.prev);
> +				}
>  			} else if (regions_needed)
>  				*regions_needed += 1;
>  		}
> 
>  		last_accounted_offset = rg->to;
> +		/* Record rg as the 'previous file region' incase we need it
> +		 * for the next iteration.
> +		 */
> +		prg = rg;
>  	}
> 
>  	/* Handle the case where our range extends beyond
> @@ -336,10 +370,18 @@ static long add_reservation_in_range(struct resv_map *resv, long f, long t,
>  	if (last_accounted_offset < t) {
>  		add += t - last_accounted_offset;
>  		if (!count_only) {
> -			nrg = get_file_region_entry_from_cache(
> -				resv, last_accounted_offset, t);
> -			record_hugetlb_cgroup_uncharge_info(h_cg, nrg, h);
> -			list_add(&nrg->link, rg->link.prev);
> +			/* Check if the last region can be extended. */
> +			if (prg && prg->to == last_accounted_offset &&
> +			    has_same_uncharge_info(prg, h_cg, h)) {
> +				prg->to = last_accounted_offset;
> +			} else {
> +				/* If not, just create a new region. */
> +				nrg = get_file_region_entry_from_cache(
> +					resv, last_accounted_offset, t);
> +				record_hugetlb_cgroup_uncharge_info(h_cg, nrg,
> +								    h);
> +				list_add(&nrg->link, rg->link.prev);
> +			}
>  		} else if (regions_needed)
>  			*regions_needed += 1;
>  	}
> --
> 2.25.0.341.g760bfbb309-goog
> 
