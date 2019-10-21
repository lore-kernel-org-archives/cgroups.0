From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v6 5/9] hugetlb: disable region_add file_region coalescing
Date: Mon, 21 Oct 2019 12:02:46 -0700
Message-ID: <982efbbc-f795-5819-83a8-7d328537e070@oracle.com>
References: <20191013003024.215429-1-almasrymina@google.com>
 <20191013003024.215429-5-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=WPm6ksNVKuUPres28dmOnwW/E7lwkBzoIiqD3p9+fOw=;
 b=b3tQuHZe4LZMbrfZPa3X7I1reh0ZReMoZBOVz9Q7OVe3hZMZ4u/BxeAL3vBcrz+g9e77
 xFnCo8pcKJ3qRikVTYvjB0M27aOguojA7DOTVp1Ei6xmXRofHVzRZqUjDVtdR0/vXwI7
 Jouy02MSr7s+Nmm2oEHhNYNtaU7V9NmP6yohCtIWbzwgRH7fskIj8wPQ3l6slg3Df4e4
 Z6MsAAy2oYsqZqXLR1Yp5BL3BapudFMN/yQbpQhNt5xxphzROMPwEhQygofchW8ymFao
 3GZVNo4HEy5qza2q0ZDMjN6gv9Jd6/5kwh4GFcwjHa13VZk6pWt0xDHpWLdhhyPGu2CN Cw== 
In-Reply-To: <20191013003024.215429-5-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, khalid.aziz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com, mkoutny@suse.com

On 10/12/19 5:30 PM, Mina Almasry wrote:
> A follow up patch in this series adds hugetlb cgroup uncharge info the
> file_region entries in resv->regions. The cgroup uncharge info may
> differ for different regions, so they can no longer be coalesced at
> region_add time. So, disable region coalescing in region_add in this
> patch.
> 
> Behavior change:
> 
> Say a resv_map exists like this [0->1], [2->3], and [5->6].
> 
> Then a region_chg/add call comes in region_chg/add(f=0, t=5).
> 
> Old code would generate resv->regions: [0->5], [5->6].
> New code would generate resv->regions: [0->1], [1->2], [2->3], [3->5],
> [5->6].
> 
> Special care needs to be taken to handle the resv->adds_in_progress
> variable correctly. In the past, only 1 region would be added for every
> region_chg and region_add call. But now, each call may add multiple
> regions, so we can no longer increment adds_in_progress by 1 in region_chg,
> or decrement adds_in_progress by 1 after region_add or region_abort. Instead,
> region_chg calls add_reservation_in_range() to count the number of regions
> needed and allocates those, and that info is passed to region_add and
> region_abort to decrement adds_in_progress correctly.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> ---
> 
> Changes in v6:
> - Fix bug in number of region_caches allocated by region_chg
> 
> ---
>  mm/hugetlb.c | 256 +++++++++++++++++++++++++++++----------------------
>  1 file changed, 147 insertions(+), 109 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a60d7d44b4c3..f9c1947925bb9 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
<snip>
> -static long region_chg(struct resv_map *resv, long f, long t)
> +static long region_chg(struct resv_map *resv, long f, long t,
> +		       long *out_regions_needed)
>  {
> +	struct file_region *trg = NULL;
>  	long chg = 0;
> 
> +	/* Allocate the maximum number of regions we're going to need for this
> +	 * reservation. The maximum number of regions we're going to need is
> +	 * (t - f) / 2 + 1, which corresponds to a region with alternating
> +	 * reserved and unreserved pages.
> +	 */
> +	*out_regions_needed = (t - f) / 2 + 1;
> +
>  	spin_lock(&resv->lock);
> -retry_locked:
> -	resv->adds_in_progress++;
> +
> +	resv->adds_in_progress += *out_regions_needed;
> 
>  	/*
>  	 * Check for sufficient descriptors in the cache to accommodate
>  	 * the number of in progress add operations.
>  	 */
> -	if (resv->adds_in_progress > resv->region_cache_count) {
> -		struct file_region *trg;
> -
> -		VM_BUG_ON(resv->adds_in_progress - resv->region_cache_count > 1);
> +	while (resv->region_cache_count < resv->adds_in_progress) {
>  		/* Must drop lock to allocate a new descriptor. */
> -		resv->adds_in_progress--;
>  		spin_unlock(&resv->lock);
> -
>  		trg = kmalloc(sizeof(*trg), GFP_KERNEL);
>  		if (!trg)
>  			return -ENOMEM;
> @@ -393,9 +395,9 @@ static long region_chg(struct resv_map *resv, long f, long t)
>  		spin_lock(&resv->lock);
>  		list_add(&trg->link, &resv->region_cache);
>  		resv->region_cache_count++;
> -		goto retry_locked;
>  	}


I know that I suggested allocating the worst case number of entries, but this
is going to be too much of a hit for existing hugetlbfs users.  It is not
uncommon for DBs to have a shared areas in excess of 1TB mapped by hugetlbfs.
With this new scheme, the above while loop will allocate over a half million
file region entries and end up only using one.

I think we need to step back and come up with a different approach.  Let me
give it some more thought before throwing out ideas that may waste more of
your time.  Sorry.
-- 
Mike Kravetz
